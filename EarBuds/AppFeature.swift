//
//  AppFeature.swift
//  EarBuds
//
//  Created by 매기 on 2023/07/05.
//

import SwiftUI
import ComposableArchitecture

struct AppFeature: ReducerProtocol {
    struct State: Equatable {
        var path = StackState<Path.State>()
        var onboarding = Onboarding.State()
    }
    
    enum Action: Equatable {
        case path(StackAction<Path.State, Path.Action>)
        case onboarding(Onboarding.Action)
    }
    
    var body: some ReducerProtocolOf<Self> {
        Scope(state: \.onboarding, action: /Action.onboarding) {
            Onboarding()
        }
        Reduce<State, Action> { state, action in
            switch action {
            case .path:
                return .none
                
            case .onboarding:
                return .none
                
            }
        }
    }
}

extension AppFeature {
    struct Path: ReducerProtocol {
        enum State: Equatable {
            case playback(Playback.State)
            case profile(ProfileFeature.State)
        }
        
        enum Action: Equatable {
            case playback(Playback.Action)
            case profile(ProfileFeature.Action)
        }
        
        var body: some ReducerProtocol<State, Action> {
            Scope(state: /State.playback, action: /Action.playback) {
                Playback()
            }
            
            Scope(state: /State.profile, action: /Action.profile) {
                ProfileFeature()
            }
        }
    }
}

struct AppView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        NavigationStackStore(self.store.scope(state: \.path, action: { .path($0) })) {
            OnboardingView(store: self.store.scope(state: \.onboarding, action: { .onboarding($0) })
            )
        } destination: {
            switch $0 {
            case .playback:
                CaseLet(
                    state: /AppFeature.Path.State.playback,
                    action: AppFeature.Path.Action.playback,
                    then: PlaybackView.init(store:)
                )
            case .profile:
                CaseLet(
                    state: /AppFeature.Path.State.profile,
                    action: AppFeature.Path.Action.profile,
                    then: ProfileView.init(store:)
                )
            }
        }
    }
}
