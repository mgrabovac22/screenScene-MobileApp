//
//  screenSceneApp.swift
//  screenScene
//
//  Created by RAMPU on 17.11.2024..
//

import SwiftUI
import SwiftData

@main
struct screenSceneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Movie.self)
    }
}
