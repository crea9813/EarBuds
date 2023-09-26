//
//  EarBudsClient.swift
//  EarBuds
//
//  Created by 매기 on 2023/08/29.
//

import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay


// MARK: - API Error
enum EarBudsError: Error {
    case invalidURL
    case invalidToken
    case decodingError
    case missingData
    case error(code: Int)
}

// MARK: - API Models
struct SignIn: Codable, Equatable {
    let userID, password: String
}

struct SignUp: Codable, Equatable {
    let userID, username: String
    let password, confirmPassword: String
}

struct User: Codable, Equatable {
    let userID, userName: String
}

// MARK: - API client interface

struct EarBudsClient {
    var signIn: @Sendable (SignIn) async throws -> Void
    var signUp: @Sendable (SignUp) async throws -> Void
    var tokenValidation: @Sendable (String) async throws -> Void
    var addMusicToken: @Sendable (String) async throws -> Void
    var friends: @Sendable () async throws -> [User]
    var addFriend: @Sendable (String) async throws -> Void
    var friendsTrack: @Sendable () async throws -> Tracks
}

extension EarBudsClient: TestDependencyKey {
    
    static let testValue = Self(
        signIn: unimplemented("\(Self.self).signIn"),
        signUp: unimplemented("\(Self.self).signUp"),
        tokenValidation: unimplemented("\(Self.self).tokenValidation"),
        addMusicToken: unimplemented("\(Self.self).addMusicToken"),
        friends: unimplemented("\(Self.self).friends"),
        addFriend: unimplemented("\(Self.self).addFriend"),
        friendsTrack: unimplemented("\(Self.self).friendsTrack")
    )
}

extension DependencyValues {
    var earbudsClient: EarBudsClient {
        get { self[EarBudsClient.self] }
        set { self[EarBudsClient.self] = newValue }
    }
}

extension EarBudsClient: DependencyKey {
    static let liveValue = Self(
        signIn: { signIn in
            let baseURL = ProcessInfo.processInfo.environment["API_URL"]!
            var components = URLComponents(string: baseURL)
            components?.path = "/users/signin"
            
            guard let targetURL = components?.url else { throw EarBudsError.invalidURL }
            var request = URLRequest(url: targetURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(signIn)
            let (data, response) = try await URLSession.shared.data(for: request)
            return
        },
        signUp: { signUp in
            let baseURL = ProcessInfo.processInfo.environment["API_URL"]!
            var components = URLComponents(string: baseURL)
            components?.path = "/users/signup"
            
            guard let targetURL = components?.url else { throw EarBudsError.invalidURL }
            var request = URLRequest(url: targetURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(signUp)
            let (data, response) = try await URLSession.shared.data(for: request)
            return
        },
        tokenValidation: { token in
            let baseURL = ProcessInfo.processInfo.environment["API_URL"]!
            var components = URLComponents(string: baseURL)
            components?.path = "/tokenValidation"
            
            guard let targetURL = components?.url else { throw EarBudsError.invalidURL }
            var request = URLRequest(url: targetURL)
            request.httpMethod = "GET"
            request.setValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
            let (data, response) = try await URLSession.shared.data(for: request)
            return
        },
        addMusicToken: { token in
            guard let token = UserDefaults.standard.string(forKey: "USER_TOKEN") else { throw EarBudsError.invalidToken }
            let baseURL = ProcessInfo.processInfo.environment["API_URL"]!
            var components = URLComponents(string: baseURL)
            components?.path = "/users/addMusicToken"
            components?.queryItems = [URLQueryItem(name: "token", value: token)]
            
            guard let targetURL = components?.url else { throw EarBudsError.invalidURL }
            var request = URLRequest(url: targetURL)
            request.httpMethod = "POST"
            request.setValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            return
        },
        friends: {
            guard let token = UserDefaults.standard.string(forKey: "USER_TOKEN") else { throw EarBudsError.invalidToken }
            let baseURL = ProcessInfo.processInfo.environment["API_URL"]!
            var components = URLComponents(string: baseURL)
            components?.path = "/users/friends"
            
            guard let targetURL = components?.url else { throw EarBudsError.invalidURL }
            var request = URLRequest(url: targetURL)
            request.httpMethod = "GET"
            request.setValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let friends = try? jsonDecoder.decode([User].self, from: data) else { throw EarBudsError.decodingError }
            return friends
        },
        addFriend: { inviteCode in
            let baseURL = ProcessInfo.processInfo.environment["API_URL"]!
            var components = URLComponents(string: baseURL)
            components?.path = "/users/signup"
            
            guard let targetURL = components?.url else { throw EarBudsError.invalidURL }
            var request = URLRequest(url: targetURL)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(inviteCode)
            
            let (data, response) = try await URLSession.shared.data(for: request)
            return
        },
        friendsTrack: {
            guard let token = UserDefaults.standard.string(forKey: "USER_TOKEN") else { throw EarBudsError.invalidToken }
            let baseURL = ProcessInfo.processInfo.environment["API_URL"]!
            var components = URLComponents(string: baseURL)
            components?.path = "/music/friendsPlaylist"
            
            guard let targetURL = components?.url else { throw EarBudsError.invalidURL }
            var request = URLRequest(url: targetURL)
            request.httpMethod = "GET"
            request.setValue("Authorization", forHTTPHeaderField: "Bearer \(token)")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let tracks = try? jsonDecoder.decode(Tracks.self, from: data) else { throw EarBudsError.decodingError }
            return tracks
        }
    )
}

// MARK: - Mock data

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

