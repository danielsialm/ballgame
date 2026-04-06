//
//  StadiumCard.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/27/26.
//

import SwiftUI

struct StadiumCard: View {
    let stadium: Stadium
    
    var body: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 8) {
                Text(stadium.name)
                    .font(.headline)
                    .foregroundStyle(.primary)
                
                Text(locationText)
                    .font(.body)
                    .foregroundStyle(.gray)
            }
            
            Spacer()
            
            if let league = stadium.league {
                Text(league.displayName)
                    .font(.subheadline.pointSize(12))
                    .padding(.vertical, 6)
                    .padding(.horizontal, 10)
                    .background(Color.primary.opacity(0.08))
                    .clipShape(Capsule())
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.secondarySystemBackground))
        .clipShape(.rect(cornerRadius: 10))
        .shadow(color: .black.opacity(0.1), radius: 10, x: 0, y: 5)
    }
    
    private var locationText: String {
        let city = stadium.city ?? "Unknown City"
        if let state = stadium.state {
            return "\(city), \(state)"
        }
        return city
    }
}


#Preview {
    StadiumCard(stadium: DataManager.shared.stadiums.first(where: { $0.id == "nfl-empower-field" })!)
}
