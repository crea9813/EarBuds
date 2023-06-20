//
//  EarBudsApp.swift
//  EarBuds
//
//  Created by 매기 on 2023/05/25.
//

import SwiftUI
import ComposableArchitecture

@main
struct EarBudsApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            PlaybackView(store: Store(
                initialState: Playback.State(),
                reducer: Playback()))
        }
    }
}
