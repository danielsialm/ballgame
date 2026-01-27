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
    @State private var searchText = ""

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
    }
    
    // MARK: Header
    
    private var header: some View {
        Text("Stadiums")
            .font(.custom("AvenirNext-Heavy", size: 36))
            .frame(maxWidth: .infinity, alignment: .center)
    }
    
    // MARK: Filter
    
    private var filter: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 10) {
                filterButton(nil)
                ForEach(League.allCases) { league in
                    filterButton(league)
                }
            }

            search
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
    
    private var search: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.gray)
            
            TextField("Search", text: $searchText)
                .font(.custom("AvenirNext-Regular", size: 16))
                .textInputAutocapitalization(.words)
                .autocorrectionDisabled(true)
                .frame(height: 25)
            
            if !searchText.isEmpty {
                Button {
                    searchText = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.gray)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 14)
        .background(.white)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    // MARK: Stadium List
    
    private var stadiumList: some View {
        VStack(spacing: 14) {
            if filteredStadiums.isEmpty {
                emptyList
            } else {
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
    }
    
    private var filteredStadiums: [Stadium] {
        let leagueFiltered: [Stadium]
        if let league = leagueFilter {
            leagueFiltered = stadiums.filter { $0.league == league }
        } else {
            leagueFiltered = stadiums
        }
        
        let trimmedSearch = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedSearch.isEmpty else {
            return leagueFiltered.sorted { $0.name < $1.name }
        }
        
        return leagueFiltered.filter { stadium in
            let matchesStadium = stadium.name.localizedCaseInsensitiveContains(trimmedSearch)
            let matchesTeam = stadiumTeams(for: stadium).contains { team in
                team.name.localizedCaseInsensitiveContains(trimmedSearch)
            }
            let matchesCity = stadium.city?.localizedCaseInsensitiveContains(trimmedSearch) ?? false
            let matchesState = stadium.state?.localizedCaseInsensitiveContains(trimmedSearch) ?? false
            return matchesStadium || matchesTeam || matchesCity || matchesState
        }
        .sorted { $0.name < $1.name }
    }
    
    private func stadiumTeams(for stadium: Stadium) -> [Team] {
        DataManager.shared.teams.filter { $0.stadiumId == stadium.id }
    }
    
    private var emptyList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("No matches")
                .font(.custom("AvenirNext-DemiBold", size: 18))
            
            Text("Try another stadium, team name, or city.")
                .font(.custom("AvenirNext-Regular", size: 14))
                .foregroundStyle(.gray)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
}

#Preview {
    StadiumsView()
}
