//
//  Visit.swift
//  Ballgame
//
//  Created by Daniel Sialm on 11/21/25.
//

import Foundation
import SwiftData

@Model
class Visit {
    var date: Date
    var stadiumId: String
    var homeTeamId: String
    var awayTeamId: String
    var notes: String?
    var seat: String?

    init(date: Date, stadiumId: String, homeTeamId: String, awayTeamId: String, notes: String? = nil, seat: String? = nil) {
        self.date = date
        self.stadiumId = stadiumId
        self.homeTeamId = homeTeamId
        self.awayTeamId = awayTeamId
        self.notes = notes
        self.seat = seat
    }
}
