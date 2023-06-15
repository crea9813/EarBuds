//
//  PlaybackDomain.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/31.
//

import Foundation
import ComposableArchitecture


//TODO: - PlaybackDomain 제작
struct Playback: ReducerProtocol {
    
    struct State {
        var music: String?
    }
    
    enum Action {
        case fetchMusic
        case musicResponse(TaskResult<String>)
        case shareButtonTapped
        case playInMusicButtonTapped
    }
    
    private enum CancelID { case musicRequest }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .shareButtonTapped:
            return .none
        case .playInMusicButtonTapped:
            
            return .none
        case .musicResponse(.success(let music)):
            state.music = music
            return .none
        case .musicResponse(.failure):
            return .none
        case .fetchMusic:
            return .run { send in
                await send(
                    .musicResponse(.success("music")),
                    animation: .default
                )
            }
            .cancellable(id: CancelID.musicRequest)
        }
    }
}
