//
//  Playback.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/31.
//

import SwiftUI
import ComposableArchitecture
import AVKit

struct Playback: ReducerProtocol {
    
    struct State: Equatable {
        var isSheetPresented: Bool = false
        var profile: ProfileFeature.State?
        
        var track: Tracks.Track?
        var audioPlayer: AVPlayer!
        var gradientColors: [Color] = [.gray, .white]
    }
    
    struct Song: Equatable {
        let name, artistName: String
        let artworkURL: String
    }
    
    enum Action: Equatable {
        case setSheet(isPresented: Bool)
        case profile(ProfileFeature.Action)
        case fetchMusic
        case musicResponse(TaskResult<Tracks.Track>)
        case updateBackground(TaskResult<[Color]>)
        case playPreviewTrack(String)
        case shareButtonTapped
        case playInMusicButtonTapped
    }
    
    @Dependency(\.musicClient) var musicClient
    private enum CancelID { case track }
    
    var body: some ReducerProtocol<State, Action> {
        Reduce { state, action in
            switch action {
            case .setSheet(isPresented: true):
                state.profile = ProfileFeature.State(uid: "CxdAOmfQU2asCbJ9YfQmhIX6Xd13")
                state.isSheetPresented = true
                return .none
                
            case .setSheet(isPresented: false):
                state.profile = nil
                state.isSheetPresented = false
                return .none
                
            case .profile:
                return .none
                
            case .shareButtonTapped:
                return .none
            case .playInMusicButtonTapped:
                return .none
            case .musicResponse(.success(let track)):
                state.track = track
                
                return .run { send in
                    await send(.playPreviewTrack(track.attributes.previews[0].url))
                    
                    await send(.updateBackground(
                        TaskResult { try await fetchArtwork(with: track.attributes.artwork.url.replacingOccurrences(of: "{w}", with: "1000").replacingOccurrences(of: "{h}", with: "1000"))}
                    ), animation: .none)
                }
            case .musicResponse(.failure(let error)):
                return .none
            case .updateBackground(.success(let colors)):
                state.gradientColors = colors
                return .none
            case .updateBackground(.failure):
                return .none
            case .playPreviewTrack(let previewURL):
                state.audioPlayer = AVPlayer(url: URL(string: previewURL)!)
                state.audioPlayer.play()
                return .none
            case .fetchMusic:
                return .run { send in
                    await send(
                        .musicResponse(TaskResult {
                            try await self.musicClient.recentlyPlayedTrack()
                        }),
                        animation: .none
                    )
                }
                .cancellable(id: CancelID.track)
            }
        }.ifLet(\.profile, action: /Action.profile) {
            ProfileFeature()
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
