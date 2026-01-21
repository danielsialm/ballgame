//
//  Stadium.swift
//  Ballgame
//
//  Created by Daniel Sialm on 11/21/25.
//

import Foundation

struct Stadium: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let city: String?
    let state: String?
    let league: String?
    let capacity: Int?
}
