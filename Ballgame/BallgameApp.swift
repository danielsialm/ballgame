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
            RootTabView()
        }
        .modelContainer(sharedModelContainer)
    }
}

private enum Tab: Hashable {
    case logbook
    case stadiums
    case add
    case friends
    case account
}

private struct RootTabView: View {
    @State private var selection: Tab = .logbook
    @State private var lastNonAddSelection: Tab = .logbook
    @State private var isAddSheetPresented = false

    var body: some View {
        TabView(selection: $selection) {
            LogbookView()
                .tabItem {
                    Label("Logbook", systemImage: "book.closed")
                }
                .tag(Tab.logbook)

            StadiumsView()
                .tabItem {
                    Label("Stadiums", systemImage: "building.columns")
                }
                .tag(Tab.stadiums)

            Color.clear
                .tabItem {
                    Label("Add", systemImage: "plus.circle.fill")
                }
                .tag(Tab.add)

            FriendsView()
                .tabItem {
                    Label("Friends", systemImage: "person.2.fill")
                }
                .tag(Tab.friends)

            AccountView()
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle")
                }
                .tag(Tab.account)
        }
        .onChange(of: selection) { _, newSelection in
            if newSelection == .add {
                isAddSheetPresented = true
                selection = lastNonAddSelection
            } else {
                lastNonAddSelection = newSelection
            }
        }
        .sheet(isPresented: $isAddSheetPresented) {
            AddVisitView()
        }
    }
}
