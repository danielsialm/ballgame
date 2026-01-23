//
//  VisitCard.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/16/26.
//

import SwiftUI

struct VisitCard: View {
    let visit: Visit

    var body: some View {
        VStack(spacing: 2) {
            HStack {
                Text(visit.date, format: Date.FormatStyle(date: .abbreviated, time: .omitted))
                    .font(.custom("AvenirNext-Regular", size: 13))
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Text(stadiumText)
                    .font(.custom("AvenirNext-Regular", size: 14))
                    .foregroundStyle(.gray)
            }
            
            Divider()
                .padding(.bottom, 20)
            
            HStack(spacing: 0) {
                teamCard(teamId: visit.homeTeamId, points: visit.homePoints)
                teamCard(teamId: visit.awayTeamId, points: visit.awayPoints, isAway: true)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white)
        .cornerRadius(10)
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }

    private func teamCard(teamId: String, points: UInt8?, isAway: Bool = false) -> some View {
        let team = DataManager.shared.teams.first(where: { $0.id == teamId })
        
        return ZStack(alignment: .center) {
            if let logoName = team?.logoName {
                HStack {
                    Image(logoName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .padding(.leading, 15)
                        .padding(.trailing, 15)
                        .scaleEffect(x: isAway ? -1 : 1, y: 1)
                    Spacer()
                }
            }
            VStack {
                Text(points.map(String.init) ?? "-")
                    .font(.custom("AvenirNext-Heavy", size: 28))
                    .foregroundStyle(.black)
                    .scaleEffect(x: isAway ? -1 : 1, y: 1)
                Text(team?.teamName ?? "---")
                    .font(.custom("AvenirNext-Regular", size: 12))
                    .foregroundStyle(.black)
                    .scaleEffect(x: isAway ? -1 : 1, y: 1)
            }
            .padding(.leading, 70)
            
        }
        .frame(maxWidth: .infinity)
        .scaleEffect(x: isAway ? -1 : 1, y: 1)
        
    }

    private var stadiumText: String {
        let stadium = DataManager.shared.stadiums.first(where: { $0.id == visit.stadiumId })
        return "\(stadium?.name ?? "Unknown Stadium")"
    }
}

#Preview {
    VisitCard(visit: Visit(date: Date(), league: .mlb, stadiumId: "mlb-fenway-park", homeTeamId: "mlb-bos", awayTeamId: "mlb-chc", homePoints: 12, awayPoints: 7))
}
