//
//  Team.swift
//  Ballgame
//
//  Created by Daniel Sialm on 11/21/25.
//

import Foundation

struct Team: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let city: String?
    let league: String?
    let stadiumId: String?
}
