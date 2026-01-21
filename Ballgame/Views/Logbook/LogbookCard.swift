//
//  LogbookCard.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/16/26.
//

import SwiftUI

struct LogbookCard: View {
    let visit: Visit

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 6) {
                    Text(matchupText)
                        .font(.custom("AvenirNext-DemiBold", size: 17))

                    Text(stadiumText)
                        .font(.custom("AvenirNext-Regular", size: 14))
                        .foregroundStyle(.gray)
                    
                    Text(visit.date, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                        .font(.custom("AvenirNext-Regular", size: 13))
                        .foregroundStyle(Color(red: 0.46, green: 0.48, blue: 0.52))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    private var matchupText: String {
        let homeTeam = DataManager.shared.teams.first(where: { $0.id == visit.homeTeamId })
        let awayTeam = DataManager.shared.teams.first(where: { $0.id == visit.awayTeamId })
        
        return "\(homeTeam?.name ?? "Unknown Home Team") vs \(awayTeam?.name ?? "Unknown Away Team")"
    }

    private var stadiumText: String {
        let stadium = DataManager.shared.stadiums.first(where: { $0.id == visit.stadiumId })
        return "\(stadium?.name ?? "Unknown Stadium")"
    }
}

#Preview {
    LogbookCard(visit: Visit(date: Date(), league: .mlb, stadiumId: "mlb-fenway-park", homeTeamId: "mlb-bos", awayTeamId: "mlb-chc"))
}
