//
//  EditVisitView.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/22/26.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditVisitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var visit: Visit

    // TODO: Get live results via API
    @State private var homePointsText: String
    @State private var awayPointsText: String
    @State private var companions: [String]
    @State private var newCompanionName: String
    @State private var photoPickerItems: [PhotosPickerItem]
    @State private var isLoadingPhotos = false
    @State private var seatText: String
    @State private var notesText: String

    init(visit: Visit) {
        self._visit = Bindable(wrappedValue: visit)
        self._homePointsText = State(initialValue: visit.homePoints.map(String.init) ?? "")
        self._awayPointsText = State(initialValue: visit.awayPoints.map(String.init) ?? "")
        self._seatText = State(initialValue: visit.seat ?? "")
        self._notesText = State(initialValue: visit.notes ?? "")
        self._companions = State(initialValue: visit.companions)
        self._newCompanionName = State(initialValue: "")
        self._photoPickerItems = State(initialValue: [])
    }

    var body: some View {
        Form {
            scoreCard
            companionCard
            photoCard
            seatCard
            notesCard
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .font(.body.pointSize(16))
            }
            ToolbarItem(placement: .principal) {
                Text("Edit Visit").font(.smallTitle)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveChanges()
                    dismiss()
                }
                .font(.subheadline.pointSize(16))
                .foregroundStyle(.blue)
            }
        }
    }
    
    private func saveChanges() {
        visit.homePoints = parsePoints(homePointsText)
        visit.awayPoints = parsePoints(awayPointsText)

        let trimmedSeat = seatText.trimmingCharacters(in: .whitespacesAndNewlines)
        visit.seat = trimmedSeat.isEmpty ? nil : trimmedSeat

        let trimmedNotes = notesText.trimmingCharacters(in: .whitespacesAndNewlines)
        visit.notes = trimmedNotes.isEmpty ? nil : trimmedNotes

        visit.companions = companions

        if visit.hasChanges {
            try? modelContext.save()
        }
    }
    
    // MARK: Score
    
    private var scoreCard: some View {
        Section("Score") {
            HStack {
                TextField("Home points", text: $homePointsText)
                Divider()
                TextField("Away points", text: $awayPointsText)
                    .multilineTextAlignment(.trailing)
            }
            .font(.body)
            .keyboardType(.numberPad)
            .padding(.horizontal, 10)
        }
        .font(.subheadline)
    }
    
    private func parsePoints(_ text: String) -> UInt8? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return nil
        }
        return UInt8(trimmed)
    }
    
    // MARK: Companions
    
    private var companionCard: some View {
        Section("Companions") {
            ForEach(companions, id: \.self) { companion in
                Text(companion)
                    .font(.body)
            }
            .onDelete(perform: deleteCompanions)

            HStack {
                TextField("Add Companion", text: $newCompanionName)
                    .font(.body)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                Button("Add") {
                    addCompanion()
                }
                .font(.body)
                .disabled(newCompanionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
        }
        .font(.subheadline)
    }
    
    private func addCompanion() {
        let trimmed = newCompanionName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }
        companions.append(trimmed)
        newCompanionName = ""
    }

    private func deleteCompanions(at offsets: IndexSet) {
        companions.remove(atOffsets: offsets)
    }
    
    // MARK: Photos
    
    private var photoCard: some View {
        Section("Photos") {
            if !visit.photos.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(visit.photos.enumerated(), id: \.offset) { index, data in
                            photoThumbnail(data: data) {
                                removePhoto(at: index)
                            }
                        }
                    }
                }
            }

            PhotosPicker(
                selection: $photoPickerItems,
                matching: .images,
                photoLibrary: .shared()
            ) {
                HStack(spacing: 8) {
                    Image(systemName: "photo.badge.plus")
                    Text(isLoadingPhotos ? "Adding..." : "Add Photos")
                }
                .font(.body)
            }
            .disabled(isLoadingPhotos)
        }
        .font(.subheadline)
        .onChange(of: photoPickerItems) {
            loadPickedPhotos()
        }
    }
    
    private func photoThumbnail(data: Data, onDelete: @escaping () -> Void) -> some View {
        ZStack(alignment: .topTrailing) {
            Group {
                if let image = UIImage(data: data) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFill()
                        .clipped()
                } else {
                    Image(systemName: "photo.trianglebadge.exclamationmark")
                        .font(.system(size: 30, weight: .semibold))
                        .foregroundStyle(.gray)
                }
            }
            .frame(width: 110, height: 80)
            .cornerRadius(10)

            Button {
                onDelete()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .foregroundStyle(.white)
                    .shadow(radius: 4)
            }
            .padding(6)
        }
    }

    private func loadPickedPhotos() {
        guard !photoPickerItems.isEmpty else { return }
        isLoadingPhotos = true

        Task {
            var newPhotos: [Data] = []
            for item in photoPickerItems {
                if let data = try? await item.loadTransferable(type: Data.self) {
                    newPhotos.append(data)
                }
            }

            await MainActor.run {
                visit.photos.append(contentsOf: newPhotos)
                photoPickerItems = []
                isLoadingPhotos = false
            }
        }
    }

    private func removePhoto(at index: Int) {
        guard visit.photos.indices.contains(index) else { return }
        visit.photos.remove(at: index)
    }
    
    // MARK: Seat
    
    private var seatCard: some View {
        Section("Seat") {
            TextField("Seat", text: $seatText)
                .font(.body)
        }
        .font(.subheadline)
    }
    
    // MARK: Notes
    
    private var notesCard: some View {
        Section("Notes") {
            TextEditor(text: $notesText)
                .font(.body)
                .frame(minHeight: 120)
        }
        .font(.subheadline)
    }
}

#Preview {
    NavigationStack {
        EditVisitView(
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
                companions: ["Kat", "Trent", "Kyzer"],
                photos: [
                    previewImageData(color: .orange),
                    previewImageData(color: .purple)
                ]
            )
        )
    }
}
