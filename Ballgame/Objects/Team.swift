//
//  Team.swift
//  Ballgame
//
//  Created by Daniel Sialm on 11/21/25.
//

import Foundation

enum League: String, Codable, CaseIterable, Identifiable {
    case mlb = "MLB"
    case nfl = "NFL"

    var id: String { rawValue }
    var displayName: String { rawValue }
}

struct Team: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let teamCode: String?
    let teamName: String?
    let city: String?
    let league: League
    let stadiumId: String?
}
