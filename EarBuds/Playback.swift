//
//  Playback.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/31.
//

import SwiftUI
import ComposableArchitecture


//TODO: - Playback 제작
struct Playback: ReducerProtocol {
    
    struct State: Equatable {
        var song: Song?
        var gradientColors: [Color] = [.gray, .white]
    }
    
    enum Action {
        case fetchMusic
        case musicResponse(TaskResult<Song>)
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
        case .musicResponse(.success(let song)):
            state.song = song
            
//            Task {
//                state.gradientColors = try! await fetchArtwork(with: song.artworkURL)
//            }
            
            return .none
        case .musicResponse(.failure):
            return .none
        case .fetchMusic:
            return .run { send in
                await send(
                    .musicResponse(.success(Song(name: "밤", artistName: "문성욱 & 임재현", artworkURL: ""))),
                    animation: .default
                )
            }
            .cancellable(id: CancelID.musicRequest)
        }
    }
    
    private func fetchArtwork(with url: String) async throws -> [Color] {
        guard let url = URL(string: url) else { return [] }
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else { return [] }
        guard let image = UIImage(data: data) else { return [] }
        return extractColorsInImage(with: image)
    }
    
    private func extractColorsInImage(with image: UIImage) -> [Color] {
        do {
            let dominantColors = try image.dominantColorFrequencies()
            
            return dominantColors.map { $0.color }.map { Color($0) }
        } catch {
            return []
        }
    }
}
