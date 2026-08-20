//
//  StadiumDetail.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/27/26.
//

import SwiftData
import SwiftUI

struct StadiumDetailView: View {
    let stadium: Stadium
    
    @Query private var visits: [Visit]
    
    init(stadium: Stadium) {
        self.stadium = stadium
        _visits = Query(filter: #Predicate { $0.stadiumId == stadium.id })
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                header
                stats
                map
                teams
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
    }
    
    // MARK: Header
    
    private var header: some View {
        StadiumCard(stadium: stadium)
    }
    
    // MARK: Stats
    
    private var stats: some View {
        HStack(alignment: .center, spacing: 12) {
            statCard(title: "League", value: stadium.league?.displayName ?? "—")
            statCard(title: "Capacity", value: stadium.capacity.map { $0.formatted(.number) } ?? "—")
            statCard(title: "Visits", value: "\(visits.count)")
        }
    }
    
    private func statCard(title: String, value: String) -> some View {
        VStack(alignment: .center) {
            Text(value)
                .font(.headline.pointSize(18))
            
            Text(title.uppercased())
                .font(.subheadline.pointSize(13))
                .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 20))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: Map
    
    private var map: some View {
        MapCard(placeId: stadium.placeId)
            .clipShape(.rect(cornerRadius: 10))
            .frame(height: 300)
    }
    
    // MARK: Teams
    
    private var teams: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Home Teams")
                .font(.headline)
                .padding(.leading, 5)
            
            if stadiumTeams.isEmpty {
                Text("No teams available")
                    .font(.body)
                    .foregroundStyle(.gray)
            } else {
                ScrollView(.horizontal) {
                    HStack(spacing: 14) {
                        ForEach(stadiumTeams) { team in
                            VStack(spacing: 6) {
                                Image(team.logoName)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(
                                        .rect(cornerRadius: 10)
                                    )
                                    .padding(15)
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 5)
                                
                                Text(team.teamName)
                                    .font(.subheadline.pointSize(12))
                                    .foregroundStyle(.primary)
                            }
                            .padding(.horizontal, 5)
                        }
                    }
                }
            }
        }
    }
    
    private var stadiumTeams: [Team] {
        DataManager.shared.teams.filter { $0.stadiumId == stadium.id }
    }
}

#Preview {
    StadiumDetailView(stadium: DataManager.shared.stadiums.first(where: { $0.id == "nfl-sofi" })!)
}
