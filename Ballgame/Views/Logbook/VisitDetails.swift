//
//  VisitDetails.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/22/26.
//

import SwiftUI
import SwiftData

struct VisitDetails: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false

    let visit: Visit

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                header
                mapCard
                companionsCard
                photosCard
                detailsCard
                notesCard
                actions
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 28)
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("\(awayTeam.teamCode.uppercased()) @ \(homeTeam.teamCode.uppercased())")
    }

    // MARK: Header

    private var header: some View {
        VisitCard(visit: visit)
    }

    // MARK: Map

    private var mapCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color.green.opacity(0.35), Color.blue.opacity(0.35)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )

            VStack(spacing: 6) {
                Image(systemName: "map.fill")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.white)
                Text("Map placeholder")
                    .font(.custom("AvenirNext-DemiBold", size: 14))
                    .foregroundStyle(.white)
                Text(stadiumName)
                    .font(.custom("AvenirNext-Regular", size: 12))
                    .foregroundStyle(.white.opacity(0.9))
            }
        }
        .frame(height: 160)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    // MARK: Companions

    private var companionsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Went With")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(visit.companions, id: \.self) { friend in
                        Text(friend)
                            .font(.custom("AvenirNext-DemiBold", size: 12))
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(.white)
                            .cornerRadius(10)
                    }
                }
            }
        }
    }

    // MARK: Photos

    private var photosCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Photos")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(0..<3, id: \.self) { index in
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.white)

                            VStack(spacing: 8) {
                                Image(systemName: "photo")
                                    .font(.system(size: 22, weight: .semibold))
                                    .foregroundStyle(.gray)
                                Text(index == 0 ? "Add photos" : "Placeholder")
                                    .font(.custom("AvenirNext-DemiBold", size: 11))
                                    .foregroundStyle(.gray)
                            }
                        }
                        .frame(width: 120, height: 90)
                    }
                }
            }
        }
    }

    // MARK: Details

    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Visit Details")

            VStack(spacing: 12) {
                detailRow(label: "Stadium", value: stadiumName)
                detailRow(label: "League", value: visit.league.displayName)
                detailRow(label: "Seat", value: visit.seat ?? "-")
                detailRow(label: "Home Team", value: homeTeam.name)
                detailRow(label: "Away Team", value: awayTeam.name)
            }
            .padding(16)
            .background(.white)
            .cornerRadius(10)
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.custom("AvenirNext-DemiBold", size: 12))
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .font(.custom("AvenirNext-Regular", size: 14))
        }
    }

    // MARK: Notes

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Notes")

            Text(visit.notes ?? "")
                .font(.custom("AvenirNext-Regular", size: 14))
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(.white)
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }

    // MARK: Actions
    
    private var actions: some View {
        VStack {
            editButton
            deleteButton
        }
        .padding(.top, 25)
    }

    private var editButton: some View {
        Button {
            // TODO: Wire up edit flow.
        } label: {
            Text("Edit Visit")
                .font(.custom("AvenirNext-DemiBold", size: 12))
                .padding(5)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(.blue.opacity(0.5))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    private var deleteButton: some View {
        Button {
            showingDeleteAlert = true
        } label: {
            Text("Delete Visit")
                .font(.custom("AvenirNext-DemiBold", size: 12))
                .padding(5)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(.red.opacity(0.5))
                .cornerRadius(10)
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
        .alert("Delete this visit?", isPresented: $showingDeleteAlert) {
            Button("Delete", role: .destructive) {
                modelContext.delete(visit)
                dismiss()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This action cannot be undone.")
        }
    }

    // MARK: Helpers

    private func sectionTitle(_ title: String) -> some View {
        Text(title)
            .font(.custom("AvenirNext-Heavy", size: 16))
            .padding(.leading, 5)
    }

    private var stadiumName: String {
        DataManager.shared.stadiums.first(where: { $0.id == visit.stadiumId })?.name ?? "Unknown Stadium"
    }

    private var homeTeam: Team {
        DataManager.shared.teams.first(where: { $0.id == visit.homeTeamId })!
    }

    private var awayTeam: Team {
        DataManager.shared.teams.first(where: { $0.id == visit.awayTeamId })!
    }
}

#Preview {
    VisitDetails(
        visit: Visit(
            date: Date(),
            league: .mlb,
            stadiumId: "mlb-fenway-park",
            homeTeamId: "mlb-bos",
            awayTeamId: "mlb-chc",
            homePoints: 6,
            awayPoints: 3,
            seat: "Loge Box 105, Row A",
            notes: "Great weather, packed crowd, and an extra-inning finish.",
            companions: ["Kat", "Trent", "Kyzer"]
        )
    )
}

#Preview("Min") {
    VisitDetails(
        visit: Visit(
            date: Date(),
            league: .mlb,
            stadiumId: "mlb-fenway-park",
            homeTeamId: "mlb-bos",
            awayTeamId: "mlb-chc"
        )
    )
}
