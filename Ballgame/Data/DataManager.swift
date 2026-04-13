//
//  DataManager.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/21/26.
//

import Foundation

class DataManager {
    static let shared = DataManager()
    let teams: [Team]
    let stadiums: [Stadium]
    
    private init() {
        self.teams = Self.loadTeams()
        self.stadiums = Self.loadStadiums()
    }
    
    private static func loadTeams() -> [Team] {
        let teamURLs = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Teams") ?? []
        guard !teamURLs.isEmpty else {
            assertionFailure("Missing team JSON files in Data/Teams.")
            return []
        }
        
        var loadedTeams: [Team] = []
        
        for url in teamURLs {
            do {
                let data = try Data(contentsOf: url)
                loadedTeams += try JSONDecoder().decode([Team].self, from: data)
            } catch {
                assertionFailure("Failed to load \(url.lastPathComponent): \(error)")
            }
        }
        
        return loadedTeams
    }
    
    private static func loadStadiums() -> [Stadium] {
        let stadiumURLs = Bundle.main.urls(forResourcesWithExtension: "json", subdirectory: "Stadiums") ?? []
        
        guard !stadiumURLs.isEmpty else {
            assertionFailure("Missing stadium JSON files in Data/Stadiums.")
            return []
        }
        
        var loadedStadiums: [Stadium] = []
        
        for url in stadiumURLs {
            do {
                let data = try Data(contentsOf: url)
                loadedStadiums += try JSONDecoder().decode([Stadium].self, from: data)
            } catch {
                assertionFailure("Failed to load Stadiums.json: \(error)")
            }
        }
        
        return loadedStadiums
    }
}
