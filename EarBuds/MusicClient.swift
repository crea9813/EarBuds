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
struct Tracks: Codable, Equatable {
    let next: String
    let tracks: [Track]
    
    enum CodingKeys: String, CodingKey {
        case next
        case tracks = "data"
    }
    
    // MARK: - Datum
    struct Track: Codable, Equatable {
        let id: String
        let type: TypeEnum
        let href: String
        let attributes: Attributes
    }

    // MARK: - Attributes
    struct Attributes: Codable, Equatable {
        let albumName: String
        let genreNames: [String]
        let trackNumber: Int
        let releaseDate: String
        let durationInMillis: Int
        let isrc: String
        let artwork: Artwork
        let composerName: String?
        let url: String
        let playParams: PlayParams
        let discNumber: Int
        let hasCredits, isAppleDigitalMaster, hasLyrics: Bool
        let name: String
        let previews: [Preview]
        let contentRating: String?
        let artistName: String
    }
    
    // MARK: - Artwork
    struct Artwork: Codable, Equatable {
        let width, height: Int
        let url, bgColor, textColor1, textColor2: String
        let textColor3, textColor4: String
    }
    
    // MARK: - PlayParams
    struct PlayParams: Codable, Equatable {
        let id: String
        let kind: Kind
    }

    enum Kind: String, Codable, Equatable {
        case song = "song"
    }

    // MARK: - Preview
    struct Preview: Codable, Equatable {
        let url: String
    }

    enum TypeEnum: String, Codable, Equatable {
        case songs = "songs"
    }
}

// MARK: - API client interface

struct MusicClient {
    var recentlyPlayedTrack: @Sendable () async throws -> Tracks.Track
}

extension MusicClient: TestDependencyKey {
    
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
    static let liveValue = Self(
        recentlyPlayedTrack: {
            var components = URLComponents(string: "https://api.music.apple.com/v1/me/recent/played/tracks?types=songs")!
            
            var requestURL = URLRequest(url: (components.url)!)
            requestURL.addValue("Bearer eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjU2Njc3NTQ5WTUifQ.eyJpYXQiOjE2ODgwMDM1NDQsImV4cCI6MTcwMzU1NTU0NCwiaXNzIjoiQlpTQzg5OTMzUiJ9.buAWAurWhkV8UnIKX-W1eckRJodTO_8wRagFfuAcQCwLg7Vn5QoLgJ0wdeCx4qafyUkU2d6RVjbM8yCludNdlg", forHTTPHeaderField: "Authorization")
            requestURL.addValue("Akc02rcgXzDz74WqW7hjAcSC/XJuNU0SG3PiaLLqFjNjtOaFIPI+xm7PudI7n8GPMwDc4hdvGX2q1bpFXKuK2n9AkL9lvnGZ4o80/24eTem8z6vGKV2KX3WQw+0D6DRpEjWaQUvEgbxC/VWDAN9G1icQLWsen+c2Udow/h7V/DXx/NpLDgWpW+ObekBhNsWtj7x7A+1d/jMx5ryjT9+eHZijmd4CVehg5UdfE2ake0JPVkg7mA==", forHTTPHeaderField: "Music-User-Token")
            
            requestURL.httpMethod = "GET"
            
            let (data, response) = try await URLSession.shared.data(for: requestURL)
            
            print(String(data: data, encoding: .utf8))
            
            let tracks = try jsonDecoder.decode(Tracks.self, from: data)
            
            return tracks.tracks.first!
        }
    )
}

// MARK: - Mock data

extension Tracks {
    static let mock = Self(
        next: "",
        tracks: []
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
