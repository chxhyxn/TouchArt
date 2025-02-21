//
//  ArtworkSelectionView.swift
//  TouchArt
//
//  Created by Sean Cho on 2/18/25.
//

import SwiftUI

struct ArtworkSelectionView: View {
    @StateObject var contentViewModel = ContentViewModel.shared
    @StateObject var artworkManager = ArtworkManager.shared
    
    var body: some View {
        GeometryReader { geo in
            let cardWidth = geo.size.width * 0.4
            let cardHeight = geo.size.width * 0.4
            
            VStack(spacing: 20) {
                Text("Select an Artwork")
                    .font(.largeTitle)
                    .bold()
                    .frame(maxWidth: .infinity)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack(spacing: 20) {
                    ForEach(artworkManager.artworks) { artwork in
                        Button(action: {
                            artworkManager.selectedArtwork = artwork
                            contentViewModel.appState = .artwork
                        }) {
                            VStack(spacing: 8) {
                                Image(artwork.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: cardWidth, height: cardHeight * 0.6)
                                    .clipped()
                                    .cornerRadius(8)
                                
                                Spacer()
                                
                                VStack(spacing: 4) {
                                    Text(artwork.title)
                                        .font(.system(size: cardWidth * 0.06, weight: .semibold))
                                        .multilineTextAlignment(.center)
                                    
                                    Text(artwork.artist)
                                        .font(.system(size: cardWidth * 0.05))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Year: \(artwork.year)")
                                        .font(.system(size: cardWidth * 0.05))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                    
                                    Text("Key Colors: \(artwork.keyColors)")
                                        .font(.system(size: cardWidth * 0.05))
                                        .foregroundColor(.secondary)
                                        .multilineTextAlignment(.center)
                                }
                                .padding(.horizontal)
                                .padding(.bottom, 40)
                            }
                            .frame(width: cardWidth, height: cardHeight)
                            .background(Color(.systemGray6))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityLabel("Select \(artwork.title) by \(artwork.artist), \(artwork.year) year, key colors are \(artwork.keyColors)")
                        .accessibilityHint("Double tap to select this artwork.")
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}
