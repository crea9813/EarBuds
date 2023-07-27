//
//  FirestoreClient.swift
//  EarBuds
//
//  Created by 매기 on 2023/07/04.
//

import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

// MARK: API client interface

struct FirestoreClient {
    var addUser: @Sendable (User) async throws -> Void
    var fetchUserProfile: @Sendable (String) async throws -> UserProfile
}

extension FirestoreClient: TestDependencyKey {
    
    static let testValue = Self(
        addUser: unimplemented("\(Self.self).addUser"),
        fetchUserProfile: unimplemented("\(Self.self).fetchUserProfile")
    )
}

extension DependencyValues {
    var firestoreClient: FirestoreClient {
        get { self[FirestoreClient.self] }
        set { self[FirestoreClient.self] = newValue }
    }
}

extension FirestoreClient: DependencyKey {
    static let liveValue = Self(
        addUser: { user in
            return try await Firestore.firestore().collection("users").document(user.uid).setData([
                "name" : "재머리",
                "uid" : user.uid,
                "userToken" : UserDefaults.standard.string(forKey: "MUSIC_USER_TOKEN")!
            ])
        },
        fetchUserProfile: { userID in
            return try await Firestore.firestore().collection("users").document("\(userID)").getDocument(as: UserProfile.self)
        }
    )
}

extension FirestoreClient {
    
}
