//
//  Invite.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/20.
//

import SwiftUI
import ComposableArchitecture
import FirebaseAuth

struct Onboarding: ReducerProtocol {
    
    struct State: Equatable {
        var playbackState: Playback.State?
    }
    
    enum Action {
        case goToMainScreen
        case signInResponse(TaskResult<User>)
        case startButtonTapped
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .goToMainScreen:
            state.playbackState = Playback.State()
            return .none
        case .signInResponse(.success(let user)):
            UserDefaults.standard.set(user.uid, forKey: "uid")
            return .none
        case .signInResponse(.failure):
            return .none
        case .startButtonTapped:
            return .run { send in
                await send(.signInResponse(
                    TaskResult { try await signInAnonymously() }
                ))
            }
        }
    }
    
    func signInAnonymously() async throws -> User {
        return try await withCheckedThrowingContinuation { continuation in
            Auth.auth().signInAnonymously() { authResult, error  in
                guard let user = authResult?.user else { return }
                continuation.resume(returning: user)
            }
        }
    }
}
