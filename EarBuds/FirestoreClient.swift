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
    var fetchUserProfile: @Sendable (String) async throws -> UserProfile
    var fetchFriends: @Sendable () async throws -> [UserProfile]
    var addUser: @Sendable (User) async throws -> Void
    var sendFriendRequest: @Sendable (UserProfile) async throws -> Void
}

extension FirestoreClient: TestDependencyKey {
    
    static let testValue = Self(
        fetchUserProfile: unimplemented("\(Self.self).fetchUserProfile"),
        fetchFriends: unimplemented("\(Self.self).fetchFriends"),
        addUser: unimplemented("\(Self.self).addUser"),
        sendFriendRequest: unimplemented("\(Self.self).sendFriendRequest")
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
        fetchUserProfile: { userID in
            return try await Firestore.firestore().collection("users").document("\(userID)").getDocument(as: UserProfile.self)
        },
        fetchFriends: {
            let userID = UserDefaults.standard.string(forKey: "UserId")!
            return try await Firestore.firestore().collection("friends").document("\(userID)").getDocument(as: [UserProfile].self)
        },
        addUser: { user in
            return try await Firestore.firestore().collection("users").document(user.uid).setData([
                "name" : "바나바나바나나",
                "uid" : user.uid,
                "userToken" : UserDefaults.standard.string(forKey: "MUSIC_USER_TOKEN")!
            ])
        },
        sendFriendRequest: { user in
            
            let myProfile = try await Firestore.firestore().collection("users").document("\(user.uid)").getDocument(as: UserProfile.self)
            
            try await Firestore.firestore().collection("friends").document(user.uid).setData([
                "\(UserDefaults.standard.string(forKey: "UserId")!)" : [ "nickname" : myProfile.name, "status" : "sent" ]
            ])
            
            try await Firestore.firestore().collection("friends").document("\(UserDefaults.standard.string(forKey: "UserId")!)").setData([
                "\(user.uid)" : [ "nickname" : user.name, "status" : "requested" ]
            ])
            
            return
        }
    )
}

extension FirestoreClient {
    
}
