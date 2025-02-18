//
//  ArtworkSelectionView.swift
//  TouchArt
//
//  Created by Sean Cho on 2/18/25.
//

import SwiftUI

// Artwork 정보를 담는 모델
struct ArtworkItem: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let imageName: String
}

struct ArtworkSelectionView: View {
    @StateObject var viewModel = ContentViewModel.shared
    
    // 예시 데이터 (이미지 에셋 이름이 일치해야 합니다)
    let artworks: [ArtworkItem] = [
        ArtworkItem(title: "Starry Night", artist: "Vincent van Gogh", imageName: "StarryNight"),
        ArtworkItem(title: "PoppyField", artist: "Monet", imageName: "PoppyField"),
        ArtworkItem(title: "The Scream", artist: "Edvard Munch", imageName: "StarryNight")
    ]
    
    var body: some View {
        VStack(alignment: .leading) {
            // 상단 타이틀
            Text("Select an Artwork")
                .font(.largeTitle)
                .bold()
                .padding([.top, .horizontal])
            
            // GeometryReader를 사용하여 화면 크기에 따라 카드 크기를 동적으로 조정합니다.
            GeometryReader { geo in
                let cardWidth = geo.size.width * 0.3
                let cardHeight = geo.size.height * 0.8
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 16) {
                        ForEach(artworks) { artwork in
                            Button(action: {
                                viewModel.selectedArtwork = artwork
                                viewModel.appState = .artwork
                            }) {
                                VStack(spacing: 0) {
                                    Image(artwork.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: cardWidth, height: cardHeight * 0.7)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(artwork.title)
                                            .font(.headline)
                                        Text(artwork.artist)
                                            .font(.subheadline)
                                            .foregroundColor(.secondary)
                                    }
                                    .padding()
                                }
                                .frame(width: cardWidth, height: cardHeight)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                            // 보이스오버 접근성 설정
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(artwork.title) by \(artwork.artist)")
                            .accessibilityHint("Double tap to select this artwork")
                        }
                    }
                    .padding()
                }
            }
        }
    }
}
