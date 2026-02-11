//
//  MapCard.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/27/26.
//

import MapKit
import SwiftUI

struct MapCard: View {
    let placeId: String?
    
    @State private var mapItem: MKMapItem?
    
    var body: some View {
        Group {
            if let mapItem {
                Map(initialPosition: .region(
                    MKCoordinateRegion(
                        center: mapItem.location.coordinate,
                        span: MKCoordinateSpan(latitudeDelta: 0.0035, longitudeDelta: 0.0035))
                )) {
                    Marker(item: mapItem)
                }
                .mapStyle(.standard(elevation: .realistic))
                
            } else {
                emptyMap
            }
        }
        .task {
            guard let placeId = placeId,
                  let identifier = MKMapItem.Identifier(rawValue: placeId) else {
                return
            }
            let request = MKMapItemRequest(mapItemIdentifier: identifier)
            mapItem = try? await request.mapItem
        }
    }

}

private var emptyMap: some View {
    ZStack {
        LinearGradient(
            colors: [Color.green.opacity(0.35), Color.blue.opacity(0.35)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )

        VStack(spacing: 6) {
            Image(systemName: "map.fill")
                .font(.system(size: 28, weight: .bold))
                .foregroundStyle(.white)
            Text("Map unavailable")
                .font(.subheadline)
                .foregroundStyle(.white)
        }
    }
}

#Preview {
    MapCard(placeId: "I388C2F0BC15DA3E6")
}

#Preview("Empty") {
    MapCard(placeId: nil)
}
