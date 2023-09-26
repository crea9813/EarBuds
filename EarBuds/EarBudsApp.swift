//
//  EarBudsApp.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/25.
//

import SwiftUI
import StoreKit
import ComposableArchitecture

@main
struct EarBudsApp: App {
    var body: some Scene {
        WindowGroup {
            AppView(
                store: Store(initialState: AppFeature.State()) {
                    AppFeature()
                        ._printChanges()
                }
            )
        }
    }
}
