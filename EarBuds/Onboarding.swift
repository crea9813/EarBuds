//
//  Invite.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/20.
//

import SwiftUI
import ComposableArchitecture
import StoreKit
import FirebaseAuth

struct Onboarding: ReducerProtocol {
    
    enum OnboardingViewState: Equatable {
        case start
        case userID
        case password
    }
    
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
        var isNavigationActive: Bool = false
        var playback: Playback.State?
        
        var viewState: OnboardingViewState = .start
        var id: String = ""
        var password: String = ""
    }
    
    enum Action: Equatable {
        case playback(Playback.Action)
        case setNavigation(isActive: Bool)
        case alert(PresentationAction<Alert>)
        case signInResponse(TaskResult<User>)
        case startButtonTapped
        case musicAuthorizationStatusResponse(SKCloudServiceAuthorizationStatus)
        
        case idChanged(String)
        case passwordChanged(String)
        
        enum Alert: Equatable { }
        
    }
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .setNavigation(isActive: true):
                return .run { send in
                    await send(.startButtonTapped)
                }
                
            case .setNavigation(isActive: false):
                state.isNavigationActive = false
                state.playback = nil
                return .none
                
            case .signInResponse(.success(let user)):
                state.isNavigationActive = true
                state.playback = Playback.State()
                return .run { _ in
                    
                }
                
            case .signInResponse(.failure):
                state.alert = AlertState {
                    TextState(
                """
                잠시 후 다시 시도해주세요
                """
                    )
                }
                return .none
                
            case .startButtonTapped:
                state.viewState = .userID
                return .none
                
            case .musicAuthorizationStatusResponse(let status):
                switch status {
                case .authorized:
                    self.fetchUserToken()
                    return .none
                case .denied:
                    state.alert = AlertState {
                        TextState(
                    """
                    You denied access to speech recognition. This app needs access to transcribe your \
                    speech.
                    """
                        )
                    }
                    return .none
                case .notDetermined:
                    return .none
                    
                case .restricted:
                    return .none
                    
                @unknown default:
                    return .none
                }
            case .playback(_):
                return .none
            case .alert(_):
                return .none
            case .idChanged(let id):
                return .none
            case .passwordChanged(_):
                return .none
            }
        }.ifLet(\.playback, action: /Action.playback) {
            Playback()
        }
    }
    
    func requestAuthorization() async -> SKCloudServiceAuthorizationStatus {
        return await withCheckedContinuation { continuation in
            SKCloudServiceController.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
    }
    
    func signInAnonymously() async -> User {
        return await withCheckedContinuation { continuation in
        }
    }
    
    private func fetchUserToken() {
        guard let developerToken = fetchDeveloperToken() else { return }
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
            let completionHandler: (String?, Error?) -> Void = { token, error in
                guard error == nil else {
                    print("An error occurred when requesting user token: \(error!.localizedDescription)")
                    return
                }
                
                guard let token = token else {
                    print("Unexpected value from SKCloudServiceController for user token.")
                    return
                }
                
                /// Store the Music User Token for future use in your application.
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(token, forKey: "MUSIC_USER_TOKEN")
                userDefaults.synchronize()
            }
            
            if #available(iOS 11.0, *) {
                SKCloudServiceController().requestUserToken(forDeveloperToken: developerToken, completionHandler: completionHandler)
            } else {
                SKCloudServiceController().requestPersonalizationToken(forClientToken: developerToken, withCompletionHandler: completionHandler)
            }
        }
    }
    
    private func fetchDeveloperToken() -> String? {
        let token: String? = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjU2Njc3NTQ5WTUifQ.eyJpYXQiOjE2ODgwMDM1NDQsImV4cCI6MTcwMzU1NTU0NCwiaXNzIjoiQlpTQzg5OTMzUiJ9.buAWAurWhkV8UnIKX-W1eckRJodTO_8wRagFfuAcQCwLg7Vn5QoLgJ0wdeCx4qafyUkU2d6RVjbM8yCludNdlg"
        return token
    }
}

