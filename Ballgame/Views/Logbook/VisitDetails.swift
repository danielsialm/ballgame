//
//  VisitDetails.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/22/26.
//

import SwiftData
import SwiftUI

struct VisitDetails: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var showingDeleteAlert = false
    @State private var showingEditSheet = false
    @State private var showingPhotoViewer = false
    @State private var selectedPhotoIndex = 0

    let visit: Visit

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 50) {
                header
                mapCard
                if !visit.companions.isEmpty {
                    companionsCard
                }
                if !visit.photos.isEmpty {
                    photosCard
                }
                detailsCard
                if visit.notes != nil {
                    notesCard
                }
                actions
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
        }
        .sheet(isPresented: $showingEditSheet) {
            NavigationStack {
                EditVisitView(visit: visit)
            }
        }
        .sheet(isPresented: $showingPhotoViewer) {
            PhotoViewer(photos: visit.photos, startIndex: selectedPhotoIndex)
        }
        .navigationTitle("\(awayTeam?.teamCode.uppercased() ?? "-") @ \(homeTeam?.teamCode.uppercased() ?? "-")")
    }

    // MARK: Header

    private var header: some View {
        VisitCard(visit: visit)
    }

    // MARK: Map
    
    private var mapCard: some View {
        MapCard(placeId: VisitDetails.getPlaceId(id: visit.stadiumId))
            .clipShape(.rect(cornerRadius: 10))
            .frame(height: 250)
    }
    
    private static func getPlaceId(id: String) -> String? {
        guard let stadium = DataManager.shared.stadiums.first(where: { $0.id == id }),
              let placeId = stadium.placeId else {
            return nil
        }
        return placeId
    }

    // MARK: Companions

    private var companionsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Went With")

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(visit.companions, id: \.self) { friend in
                        Text(friend)
                            .font(.subheadline)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(.white)
                            .clipShape(.rect(cornerRadius: 10))
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
                HStack(spacing: 8) {
                    ForEach(Array(visit.photos.enumerated()), id: \.offset) { index, data in
                        Button {
                            selectedPhotoIndex = index
                            showingPhotoViewer = true
                        } label: {
                            if let image = UIImage(data: data) {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .clipped()
                            } else {
                                missingPhoto
                            }
                        }
                    }
                    .frame(width: 120, height: 90)
                    .clipShape(.rect(cornerRadius: 10))
                }
            }
        }
    }
    
    private var missingPhoto: some View {
        ZStack {
            Color.white
            
            VStack(spacing: 8) {
                Image(systemName: "photo.trianglebadge.exclamationmark")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(.gray)
                
                Text("Error Loading Photo")
                    .font(.body)
                    .foregroundStyle(.gray)
            }

        }
    }

    // MARK: Details

    private var detailsCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Visit Details")

            VStack(spacing: 12) {
                detailRow(label: "Stadium", value: stadiumName)
                Divider()
                detailRow(label: "League", value: visit.league.displayName)
                Divider()
                detailRow(label: "Seat", value: visit.seat ?? "-")
                Divider()
                detailRow(label: "Home Team", value: homeTeam?.name ?? "-")
                Divider()
                detailRow(label: "Away Team", value: awayTeam?.name ?? "-")
            }
            .padding(16)
            .background(.white)
            .clipShape(.rect(cornerRadius: 10))
            .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }

    private func detailRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.subheadline.pointSize(16))
                .foregroundStyle(.gray)
            Spacer()
            Text(value)
                .font(.body)
        }
    }

    // MARK: Notes

    private var notesCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            sectionTitle("Notes")
            ScrollView {
                Text(visit.notes ?? "")
                    .font(.body)
                    .padding(16)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.white)
            .clipShape(.rect(cornerRadius: 10))
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
            showingEditSheet = true
        } label: {
            Text("Edit Visit")
                .font(.subheadline.pointSize(13))
                .padding(.vertical, 15)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(.blue.opacity(0.6))
                .clipShape(.rect(cornerRadius: 10))
                .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
        }
    }
    
    private var deleteButton: some View {
        Button {
            showingDeleteAlert = true
        } label: {
            Text("Delete Visit")
                .font(.subheadline.pointSize(13))
                .padding(.vertical, 15)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .background(.red.opacity(0.6))
                .clipShape(.rect(cornerRadius: 10))
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
            .font(.headline)
            .padding(.leading, 5)
    }

    private var stadiumName: String {
        DataManager.shared.stadiums.first(where: { $0.id == visit.stadiumId })?.name ?? "Unknown Stadium"
    }

    private var homeTeam: Team? {
        DataManager.shared.teams.first(where: { $0.id == visit.homeTeamId })
    }

    private var awayTeam: Team? {
        DataManager.shared.teams.first(where: { $0.id == visit.awayTeamId })
    }
}

// MARK: Previews

func previewImageData(color: Color, size: CGSize = CGSize(width: 600, height: 450)) -> Data {
    let view = Rectangle()
        .fill(color)
        .border(.gray, width: 20)
        .frame(width: size.width, height: size.height)

    let renderer = ImageRenderer(content: view)

    if let uiImage = renderer.uiImage {
        return uiImage.jpegData(compressionQuality: 0.9) ?? Data()
    }

    return Data()
}

#Preview("Visit_NFL") {
    VisitDetails(
        visit: Visit(
            date: Date(timeIntervalSince1970: 1762084800),
            league: .nfl,
            stadiumId: "nfl-highmark-stadium",
            homeTeamId: "nfl-buf",
            awayTeamId: "nfl-kc",
            homePoints: 28,
            awayPoints: 21,
            seat: "Section 133, Row 20, Seat 4",
            notes: "Go Bills!",
            companions: ["Kat"],
            photos: [
                previewImageData(color: .red, size: CGSize(width: 4032, height: 3024)),
                previewImageData(color: .blue, size: CGSize(width: 3024, height: 4032)),
                previewImageData(color: .yellow),
                previewImageData(color: .cyan),
                previewImageData(color: .indigo)
            ]
        )
    )
}

#Preview("Visit_MLB") {
    VisitDetails(
        visit: Visit(
            date: Date(timeIntervalSince1970: 1755691200),
            league: .mlb,
            stadiumId: "mlb-coors-field",
            homeTeamId: "mlb-col",
            awayTeamId: "mlb-lad",
            homePoints: 8,
            awayPoints: 3,
            seat: "Section 125, Row 3, Seat 7",
            notes: "This is a really long note because I want to test what happens when you write a really long note. This is a really long note because I want to test what happens when you write a really long note. This is a really long note because I want to test what happens when you write a really long note. This is a really long note because I want to test what happens when you write a really long note. This is a really long note because I want to test what happens when you write a really long note. This is a really long note because I want to test what happens when you write a really long note. This is a really long note because I want to test what happens when you write a really long note. ",
            companions: ["Kat", "Trent", "Kyzer"],
            photos: [
                previewImageData(color: .green),
                previewImageData(color: .orange),
                previewImageData(color: .purple)
            ]
        )
    )
}

#Preview("Visit_Empty") {
    VisitDetails(
        visit: Visit(
            date: Date(),
            league: .mlb,
            stadiumId: "mlb-no-park",
            homeTeamId: "mlb-home",
            awayTeamId: "mlb-away",
            photos: [
                Data()
            ]
        )
    )
}
