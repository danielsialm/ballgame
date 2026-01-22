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
    
    var homePoints: UInt8?
    var awayPoints: UInt8?
    var seat: String?
    var notes: String?
    
    var companions: [String]

    init(date: Date,
         league: League,
         stadiumId: String,
         homeTeamId: String,
         awayTeamId: String,
         homePoints: UInt8? = nil,
         awayPoints: UInt8? = nil,
         seat: String? = nil,
         notes: String? = nil,
         companions: [String] = []
    ) {
        self.date = date
        self.league = league
        self.stadiumId = stadiumId
        self.homeTeamId = homeTeamId
        self.awayTeamId = awayTeamId
        self.homePoints = homePoints
        self.awayPoints = awayPoints
        self.notes = notes
        self.seat = seat
        self.companions = companions
    }
}
