//
//  BallgameApp.swift
//  Ballgame
//
//  Created by Daniel Sialm on 11/21/25.
//

import SwiftUI
import SwiftData

@main
struct BallgameApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Visit.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TabView {
                LogbookView()
                    .tabItem {
                        Label("Logbook", systemImage: "book.closed")
                    }

                StadiumsView()
                    .tabItem {
                        Label("Stadiums", systemImage: "building.columns")
                    }

                AddVisitView()
                    .tabItem {
                        Label("Add", systemImage: "plus.circle.fill")
                    }

                FriendsView()
                    .tabItem {
                        Label("Friends", systemImage: "person.2.fill")
                    }

                AccountView()
                    .tabItem {
                        Label("Account", systemImage: "person.crop.circle")
                    }
            }
        }
        .modelContainer(sharedModelContainer)
    }
}
