//
//  Cricket_ScoreApp.swift
//  Cricket Score
//
//  Created by Vijith V G on 01/10/26.
//

import SwiftUI
import SwiftData

// MARK: - App Entry & Dependency Injection
@main
struct Cricket_ScoreApp: App {
    // Initialize the centralized container once
    @State private var container = DIContainer()
    
    var body: some Scene {
        WindowGroup {
            // Ask the container to build the ViewModel
            ScoringView(viewModel: container.makeScoringViewModel())
        }
        // Still expose the SwiftData container to the environment for views that need it
        .modelContainer(container.modelContainer)
    }
}

//@main
//struct Cricket_ScoreApp: App {
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
//
//    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
//        .modelContainer(sharedModelContainer)
//    }
//}
