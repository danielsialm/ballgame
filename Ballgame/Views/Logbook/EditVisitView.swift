//
//  EditVisitView.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/22/26.
//

import SwiftUI
import SwiftData

struct EditVisitView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext

    @Bindable var visit: Visit

    // TODO: Get live results via API
    @State private var homePointsText: String
    @State private var awayPointsText: String
    @State private var seatText: String
    @State private var notesText: String
    @State private var companions: [String]
    @State private var newCompanionName: String

    init(visit: Visit) {
        self._visit = Bindable(wrappedValue: visit)
        self._homePointsText = State(initialValue: visit.homePoints.map(String.init) ?? "")
        self._awayPointsText = State(initialValue: visit.awayPoints.map(String.init) ?? "")
        self._seatText = State(initialValue: visit.seat ?? "")
        self._notesText = State(initialValue: visit.notes ?? "")
        self._companions = State(initialValue: visit.companions)
        self._newCompanionName = State(initialValue: "")
    }

    var body: some View {
        Form {
            Section("Score") {
                HStack {
                    TextField("Home points", text: $homePointsText)
                        .font(.custom("AvenirNext-Regular", size: 16))
                        .keyboardType(.numberPad)
                    Divider()
                    TextField("Away points", text: $awayPointsText)
                        .font(.custom("AvenirNext-Regular", size: 16))
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.trailing)
                }
                .padding(.horizontal, 10)
            }

            Section("Seat") {
                TextField("Seat", text: $seatText)
                    .font(.custom("AvenirNext-Regular", size: 16))
            }
            

            Section("Companions") {
                ForEach(companions, id: \.self) { companion in
                    Text(companion)
                }
                .onDelete(perform: deleteCompanions)

                HStack {
                    TextField("Add companion", text: $newCompanionName)
                        .font(.custom("AvenirNext-Regular", size: 16))
                        .textInputAutocapitalization(.words)
                        .autocorrectionDisabled()
                    Button("Add") {
                        addCompanion()
                    }
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .disabled(newCompanionName.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
            }

            Section("Notes") {
                TextEditor(text: $notesText)
                    .font(.custom("AvenirNext-Regular", size: 16))
                    .frame(minHeight: 120)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") {
                    dismiss()
                }
                .font(.custom("AvenirNext-Regular", size: 16))
            }
            ToolbarItem(placement: .principal) {
                Text("Edit Visit").font(.custom("AvenirNext-Bold", size: 25))
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    saveChanges()
                    dismiss()
                }
                .font(.custom("AvenirNext-DemiBold", size: 16))
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

        try? modelContext.save()
    }

    private func parsePoints(_ text: String) -> UInt8? {
        let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            return nil
        }
        return UInt8(trimmed)
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
                companions: ["Kat", "Trent", "Kyzer"]
            )
        )
    }
}
