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
    private let dataManager = DataManager.shared
    @State private var league: League = .mlb
    @State private var date = Date()
    @State private var stadiumId = ""
    @State private var homeTeamId = ""
    @State private var awayTeamId = ""
    @State private var notes = ""
    @State private var seat = ""

    var body: some View {
        VStack(alignment: .center, spacing: 24) {
            header
            gameInfo
            detailInfo
        }
        .padding(20)
    }
    
    // MARK: Header
    
    private var header: some View {
        ZStack {
            Text("Add Visit")
                .font(.custom("AvenirNext-Heavy", size: 36))

            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .font(.custom("AvenirNext-DemiBold", size: 20))

                Spacer()

                Button("Save") {
                    saveVisit()
                }
                .font(.custom("AvenirNext-DemiBold", size: 20))
                .disabled(!canSave)
            }
        }
    }
    
    private var canSave: Bool {
        !stadiumId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !homeTeamId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !awayTeamId.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    private func saveVisit() {
        let visit = Visit(
            date: date,
            stadiumId: stadiumId.trimmingCharacters(in: .whitespacesAndNewlines),
            homeTeamId: homeTeamId.trimmingCharacters(in: .whitespacesAndNewlines),
            awayTeamId: awayTeamId.trimmingCharacters(in: .whitespacesAndNewlines),
            notes: notes.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : notes,
            seat: seat.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? nil : seat
        )
        modelContext.insert(visit)
        dismiss()
    }
    
    // MARK: Visit Info
    
    private var gameInfo: some View {
        let teams = dataManager.teams.filter { $0.league == league }
        let stadiums = dataManager.stadiums.filter { $0.league == league }

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
                
                Divider()
                
                DatePicker("Date", selection: $date, displayedComponents: .date)
                    .font(.custom("AvenirNext-Regular", size: 16))
                
                Divider()
                
                HStack {
                    Text("Stadium")
                        .font(.custom("AvenirNext-Regular", size: 16))
                    
                    Spacer()
                    
                    Picker("Stadium", selection: $stadiumId) {
                        ForEach(stadiums) { stadium in
                            Text(stadium.name).tag(stadium.id)
                        }
                    }
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    Text("Home Team")
                        .font(.custom("AvenirNext-Regular", size: 16))
                    
                    Spacer()
                    
                    Picker("Home Team", selection: $homeTeamId) {
                        ForEach(teams) { team in
                            Text(team.name).tag(team.id)
                        }
                    }
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
                
                Divider()
                
                HStack {
                    Text("Away Team")
                        .font(.custom("AvenirNext-Regular", size: 16))
                    
                    Spacer()
                    
                    Picker("Away Team", selection: $awayTeamId) {
                        ForEach(teams) { team in
                            Text(team.name).tag(team.id)
                        }
                    }
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .pickerStyle(.menu)
                    .labelsHidden()
                }
            }
            .padding(16)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    private var detailInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text("Details")
                .font(.custom("AvenirNext-DemiBold", size: 20))
                .padding(.leading, 5)
            
            VStack(alignment: .leading) {
                TextField("Seat", text: $seat)
                    .font(.custom("AvenirNext-Regular", size: 16))
                
                Divider()
                
                TextField("Notes", text: $notes, axis: .vertical)
                    .lineLimit(3...3)
                    .font(.custom("AvenirNext-Regular", size: 16))
            }
            .padding(12)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
}

#Preview {
    AddVisitView()
}
