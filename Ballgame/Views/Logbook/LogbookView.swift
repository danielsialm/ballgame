//
//  LogbookView.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/16/26.
//

import SwiftUI
import SwiftData

struct LogbookView: View {
    @Query(sort: \Visit.date, order: .reverse) private var visits: [Visit]

    var body: some View {
        ScrollView {
            VStack(alignment: .center, spacing: 24) {
                header
                stats
                visitCards
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    // MARK: Header

    // TODO: Options to add Visits and Search
    private var header: some View {
        Text("Logbook")
            .font(.title)
    }
    
    // MARK: Lifetime Stats

    // TODO: Navigate towards more detailed stats view
    private var stats: some View {
        HStack(alignment: .center, spacing: 12) {
            statCard(title: "Visits", value: "\(visits.count)")
            statCard(title: "Stadiums", value: "\(uniqueStadiumCount)")
            statCard(title: "Teams", value: "\(uniqueTeamCount)")
        }
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .center) {
            Text(value)
                .font(.numberStat)
            
            Text(title.uppercased())
                .font(.subheadline.pointSize(13))
                .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
    }
    
    private var uniqueStadiumCount: Int {
        Set(visits.map(\.stadiumId)).count
    }
    
    private var uniqueTeamCount: Int {
        let homeTeams = visits.map(\.homeTeamId)
        let awayTeams = visits.map(\.awayTeamId)
        return Set(homeTeams + awayTeams).count
    }
    
    // MARK: Visits

    private var visitCards: some View {
        VStack(spacing: 14) {
            if visits.isEmpty {
                emptyState
            } else {
                ForEach(visits) { visit in
                    NavigationLink {
                        VisitDetails(visit: visit)
                    } label: {
                        VisitCard(visit: visit)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
    }

    private var emptyState: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No visits yet")
                .font(.headline)

            Text("Start by logging your first game!")
                .font(.body)
                .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

// MARK: Previews

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Visit.self, configurations: config)
    let context = container.mainContext

    context.insert(Visit(date: Date(), league: .mlb, stadiumId: "mlb-fenway-park", homeTeamId: "mlb-bos", awayTeamId: "mlb-chc", homePoints: 12, awayPoints: 7))
    context.insert(Visit(date: Calendar.current.date(byAdding: .day, value: -28, to: Date())!, league: .mlb, stadiumId: "mlb-fenway-park", homeTeamId: "mlb-bos", awayTeamId: "mlb-tex"))
    context.insert(Visit(date: Calendar.current.date(byAdding: .day, value: -14, to: Date())!, league: .nfl, stadiumId: "nfl-lambeau-field", homeTeamId: "nfl-gb", awayTeamId: "nfl-chi"))

    return LogbookView()
        .modelContainer(container)
}

#Preview("Empty") {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Visit.self, configurations: config)
    let context = container.mainContext
    
    return LogbookView()
        .modelContainer(container)
}
