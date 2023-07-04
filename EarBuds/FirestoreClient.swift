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

// MARK: API client interface

struct FirestoreClient {
    var addUser: @Sendable (User) async throws -> Void
}

extension FirestoreClient: TestDependencyKey {
    
    static let testValue = Self(
        addUser: unimplemented("\(Self.self).addUser")
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
            let db = Firestore.firestore()
            
            db.collection("users").document(user.uid).setData([
                "name" : "재머리",
                "userToken" : UserDefaults.standard.string(forKey: "MUSIC_USER_TOKEN")!
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                    return
                }
            }
        }
    )
}
