//
//  PlaybackDomain.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/31.
//

import Foundation
import ComposableArchitecture

struct Playback: ReducerProtocol {
    struct State { }
    
    enum Action { }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        return .none
    }
    
   
}
