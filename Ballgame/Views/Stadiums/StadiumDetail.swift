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
                .font(.custom("AvenirNext-Bold", size: 18))
            
            Text(title.uppercased())
                .font(.custom("AvenirNext-DemiBold", size: 10))
                .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .center)
        .background(.white)
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
                .font(.custom("AvenirNext-DemiBold", size: 18))
            
            if stadiumTeams.isEmpty {
                Text("No teams available")
                    .font(.custom("AvenirNext-Regular", size: 14))
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
                                    .padding(15)
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black.opacity(0.1), radius: 3, x: 0, y: 5)
                                
                                Text(team.teamName)
                                    .font(.custom("AvenirNext-DemiBold", size: 12))
                                    .foregroundStyle(.black)
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
    StadiumDetailView(stadium: DataManager.shared.stadiums.first!)
}
