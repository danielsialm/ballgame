//
//  AddVisitView.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/20/26.
//

import SwiftUI
import SwiftData

struct AddVisitView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var league: League = .mlb
    @State private var date = Date()
    @State private var stadiumId = ""
    @State private var homeTeamId = ""
    @State private var awayTeamId = ""
    @State private var notes = ""
    @State private var seat = ""

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            gameInfo
        }
        .padding(20)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .font(.custom("AvenirNext-Regular", size: 16))
            }
            ToolbarItem(placement: .principal) {
                Text("Add Visit").font(.custom("AvenirNext-Bold", size: 25))
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveVisit()
                    dismiss()
                }
                .font(.custom("AvenirNext-DemiBold", size: 16))
                .foregroundStyle(.blue)
            }
        }
    }
    
    // MARK: Header
    private var canSave: Bool {
        !stadiumId.isEmpty &&
        !homeTeamId.isEmpty &&
        !awayTeamId.isEmpty
    }

    private func saveVisit() {
        let visit = Visit(
            date: date,
            league: league,
            stadiumId: stadiumId,
            homeTeamId: homeTeamId,
            awayTeamId: awayTeamId,
            seat: seat.isEmpty ? nil : seat,
            notes: notes.isEmpty ? nil : notes
            
        )
        modelContext.insert(visit)
    }
    
    // MARK: Visit Info
    
    private var gameInfo: some View {
        let teams = DataManager.shared.teams.filter { $0.league == league }
        let stadiums = DataManager.shared.stadiums.filter { $0.league == league }

        return VStack(alignment: .leading, spacing: 2) {
            Text("Game")
                .font(.custom("AvenirNext-DemiBold", size: 20))
                .padding(.leading, 5)
            
            VStack(alignment: .leading, spacing: 10) {
                Picker("League", selection: $league) {
                    ForEach(League.allCases) { league in
                        Text(league.displayName).tag(league)
                    }
                }
                .font(.custom("AvenirNext-Regular", size: 16))
                .pickerStyle(.segmented)
                .frame(height: 30)
                
                Divider()
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .frame(height: 30)
                
                Divider()
                
                HStack {
                    Text("Stadium")
                        .font(.custom("AvenirNext-Regular", size: 16))
                    
                    Spacer()
                    
                    Picker("Stadium", selection: $stadiumId) {
                        Text("").tag("")
                        ForEach(stadiums) { stadium in
                            Text(stadium.name).tag(stadium.id)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                .frame(height: 30)
                
                Divider()
                
                HStack {
                    Text("Home Team")
                        .font(.custom("AvenirNext-Regular", size: 16))
                    
                    Spacer()
                    
                    Picker("Home Team", selection: $homeTeamId) {
                        Text("").tag("")
                        ForEach(teams) { team in
                            Text(team.name).tag(team.id)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                .frame(height: 30)
                
                Divider()
                
                HStack {
                    Text("Away Team")
                        .font(.custom("AvenirNext-Regular", size: 16))
                    
                    Spacer()
                    
                    Picker("Away Team", selection: $awayTeamId) {
                        Text("").tag("")
                        ForEach(teams) { team in
                            Text(team.name).tag(team.id)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                .frame(height: 30)
            }
            .padding(16)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
            
        }
    }
}

#Preview {
    NavigationStack {
        AddVisitView()
    }
}
