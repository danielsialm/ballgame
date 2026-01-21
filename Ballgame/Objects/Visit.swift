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
    var league: League
    var stadiumId: String
    var homeTeamId: String
    var awayTeamId: String
    var seat: String?
    var notes: String?

    init(date: Date, league: League, stadiumId: String, homeTeamId: String, awayTeamId: String, seat: String? = nil, notes: String? = nil) {
        self.date = date
        self.league = league
        self.stadiumId = stadiumId
        self.homeTeamId = homeTeamId
        self.awayTeamId = awayTeamId
        self.notes = notes
        self.seat = seat
    }
}
