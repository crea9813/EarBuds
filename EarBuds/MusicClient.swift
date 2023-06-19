//
//  MusicClient.swift
//  EarBuds
//
//  Created by 매기 on 2023/06/19.
//

import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay


// MARK: - API Models
struct Tracks: Codable {
    let data: [Track]
    
    struct Track: Codable {
        let id, type, href: String
        let attributes: Attributes
    }
    
    struct Attributes: Codable {
        let albumName: String
        let genreNames: [String]
        let trackNumber, durationInMillis: Int
        let releaseDate, isrc: String
        let artwork: Artwork
        let composerName: String
        let url: String
        let playParams: PlayParams
        let discNumber: Int
        let hasLyrics, isAppleDigitalMaster: Bool
        let name: String
        let previews: [Preview]
        let artistName: String
    }
    struct Artwork: Codable {
        let width, height: Int
        let url, bgColor, textColor1, textColor2: String
        let textColor3, textColor4: String
    }
    
    // MARK: - PlayParams
    struct PlayParams: Codable {
        let id, kind: String
    }
    struct Preview: Codable {
        let url: String
    }
}

// MARK: - API client interface

struct MusicClient {
    var recentlyPlayedTrack: @Sendable (String) async throws -> Tracks
}

extension MusicClient: TestDependencyKey {
    static let previewValue = Self(
        recentlyPlayedTrack: { _ in .mock }
    )
    
    static let testValue = Self(
        recentlyPlayedTrack: unimplemented("\(Self.self).recentlyPlayedTrack")
    )
}

extension DependencyValues {
    var musicClient: MusicClient {
        get { self[MusicClient.self] }
        set { self[MusicClient.self] = newValue }
    }
}

extension MusicClient: DependencyKey {
    static let liveValue = MusicClient(
        recentlyPlayedTrack: { result in
            var components = URLComponents(string: "https://api.music.apple.com/v1/me/recent/played/tracks")!
            components.queryItems = [URLQueryItem(name: "Music-User-Token", value: UserDefaults.standard.string(forKey: "Music-Bud-Token"))]
            
            let (data, _) = try await URLSession.shared.data(from: components.url!)
            return try jsonDecoder.decode(Tracks.self, from: data)
        }
    )
}

// MARK: - Mock data

extension Tracks {
    static let mock = Self(
        data: []
    )
}

// MARK: - Private helpers

private let jsonDecoder: JSONDecoder = {
  let decoder = JSONDecoder()
  let formatter = DateFormatter()
  formatter.calendar = Calendar(identifier: .iso8601)
  formatter.dateFormat = "yyyy-MM-dd"
  formatter.timeZone = TimeZone(secondsFromGMT: 0)
  formatter.locale = Locale(identifier: "ko-KR")
  decoder.dateDecodingStrategy = .formatted(formatter)
  return decoder
}()
