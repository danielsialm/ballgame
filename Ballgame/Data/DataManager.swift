//
//  DataManager.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/21/26.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    var teams: [Team] = []
    var stadiums: [Stadium] = []
    
    private init() {
        loadTeams()
        loadStadiums()
    }
    
    private func loadTeams() {
        guard let url = Bundle.main.url(forResource: "Teams", withExtension: "json") else {
            assertionFailure("Missing Teams.json in app bundle.")
            teams = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            teams = try JSONDecoder().decode([Team].self, from: data)
        } catch {
            assertionFailure("Failed to load Teams.json: \(error)")
            teams = []
        }
    }
    
    private func loadStadiums() {
        guard let url = Bundle.main.url(forResource: "Stadiums", withExtension: "json") else {
            assertionFailure("Missing Stadiums.json in app bundle.")
            stadiums = []
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            stadiums = try JSONDecoder().decode([Stadium].self, from: data)
        } catch {
            assertionFailure("Failed to load Stadiums.json: \(error)")
            stadiums = []
        }
    }
}
