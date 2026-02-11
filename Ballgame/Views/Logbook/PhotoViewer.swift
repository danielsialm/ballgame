//
//  PhotoViewer.swift
//  Ballgame
//
//  Created by Daniel Sialm on 1/26/26.
//

import SwiftUI

struct PhotoViewer: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedIndex: Int

    private let photos: [Data]

    init(photos: [Data], startIndex: Int) {
        self.photos = photos
        self._selectedIndex = State(initialValue: min(max(0, startIndex), max(photos.count - 1, 0)))
    }

    var body: some View {
        ZStack(alignment: .topTrailing) {
            Color.black.ignoresSafeArea()

            TabView(selection: $selectedIndex) {
                ForEach(Array(photos.enumerated()), id: \.offset) { index, data in
                    if let image = UIImage(data: data) {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                    } else {
                        VStack(spacing: 12) {
                            Image(systemName: "photo.trianglebadge.exclamationmark")
                                .font(.system(size: 50, weight: .semibold))
                            Text("Unable to load photo")
                                .font(.subheadline)
                        }
                        .foregroundStyle(.white.opacity(0.8))
                    }
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .automatic))

            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 26, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(16)
            }
        }
    }
}

#Preview() {
    PhotoViewer(
        photos: [
            previewImageData(color: .red, size: CGSize(width: 4032, height: 3024)),
            previewImageData(color: .blue, size: CGSize(width: 3024, height: 4032)),
            previewImageData(color: .yellow),
            previewImageData(color: .cyan),
            previewImageData(color: .indigo),
            Data()
        ],
        startIndex: 1
    )
}
