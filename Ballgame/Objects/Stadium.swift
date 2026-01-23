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
    let placeId: String?
    let latitude: Double?
    let longitude: Double?
    // TODO: This might be better to implement as "sports"
    let league: League?
    let capacity: Int?
}
