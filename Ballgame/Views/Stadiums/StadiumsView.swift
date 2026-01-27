//
//  StadiumsView.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/20/26.
//

import SwiftUI

struct StadiumsView: View {
    private let stadiums = DataManager.shared.stadiums
    @State private var leagueFilter: League? = nil

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                header
                filter
                stadiumList
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .background(
            LinearGradient(
                colors: [Color(.systemGray6), Color(.systemBackground)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
    
    // MARK: Header
    
    private var header: some View {
        Text("Stadiums")
            .font(.custom("AvenirNext-Heavy", size: 36))
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Filter
    
    private var filter: some View {
        HStack(spacing: 10) {
            filterButton(nil)
            ForEach(League.allCases) { league in
                filterButton(league)
            }
        }
    }
    
    // a nil league indicates "All"
    private func filterButton(_ league: League?) -> some View {
        Button {
            leagueFilter = league
        } label: {
            Text(league?.displayName ?? "All")
                .font(.custom("AvenirNext-DemiBold", size: 14))
                .padding(.vertical, 8)
                .padding(.horizontal, 14)
                .background(league == leagueFilter ? Color.black : Color.white)
                .foregroundStyle(league == leagueFilter ? .white : .black)
                .clipShape(Capsule())
        }
    }
    
    // MARK: Search
    
    // MARK: Stadium List
    
    private var stadiumList: some View {
        VStack(spacing: 14) {
            ForEach(filteredStadiums) { stadium in
                NavigationLink {
                    StadiumDetailView(stadium: stadium)
                } label: {
                    StadiumCard(stadium: stadium)
                }
                .buttonStyle(.plain)
            }
        }
    }
    
    private var filteredStadiums: [Stadium] {
        guard let league = leagueFilter else {
            return stadiums.sorted { $0.name < $1.name }
        }
        return stadiums.filter { $0.league == league }.sorted { $0.name < $1.name }
    }
}

#Preview {
    NavigationStack {
        StadiumsView()
    }
}
