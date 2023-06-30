//
//  EarBudsApp.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/25.
//

import SwiftUI
import ComposableArchitecture
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth
import StoreKit

@main
struct EarBudsApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingView(store: Store(
                initialState: Onboarding.State(),
                reducer: Onboarding()))
        }
    }
}
