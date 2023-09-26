//
//  Profile.swift
//  EarBuds
//
//  Created by 매기 on 2023/07/04.
//

import Foundation
import ComposableArchitecture

struct ProfileFeature: ReducerProtocol {
    
    struct State: Equatable {
        var uid: String
        var profile: UserProfile?
        var isProfileRequestInFlight = false
    }
    
    enum Action: Equatable {
        case fetchUserProfile
        case fetchUserProfileResponse(TaskResult<UserProfile>)
    }
    
    private enum CancelID { case profile }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
            
        case .fetchUserProfile:
            let userID = state.uid
            state.isProfileRequestInFlight = true
            state.profile = nil
            
            return .run { send in
                
            }
            .cancellable(id: CancelID.profile)
            
        case .fetchUserProfileResponse(.success(let profile)):
            state.isProfileRequestInFlight = false
            state.profile = profile
            return .none
            
        case .fetchUserProfileResponse(.failure):
            state.isProfileRequestInFlight = false
            return .none
        }
    }
}
