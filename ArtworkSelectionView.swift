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
        VStack(spacing: 20) {
            // 상단 타이틀 (가운데 정렬)
            Text("Select an Artwork")
                .font(.largeTitle)
                .bold()
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
                .padding(.top)
                .padding(.horizontal)
            
            // GeometryReader로 화면 크기에 따라 카드 크기를 동적으로 조정
            GeometryReader { geo in
                // 카드 크기를 화면 크기의 비율에 맞춰 계산
                let cardWidth = geo.size.width * 0.3
                let cardHeight = geo.size.height * 0.8
                
                ScrollView(.horizontal, showsIndicators: true) {
                    HStack(spacing: 20) {
                        ForEach(artworks) { artwork in
                            Button(action: {
                                viewModel.selectedArtwork = artwork
                                viewModel.appState = .artwork
                            }) {
                                VStack(spacing: 8) {
                                    // 작품 이미지
                                    Image(artwork.imageName)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: cardWidth, height: cardHeight * 0.7)
                                        .clipped()
                                        .cornerRadius(8)
                                    
                                    // 작품 제목과 작가 정보 (가운데 정렬)
                                    VStack(spacing: 4) {
                                        Text(artwork.title)
                                            .font(.system(size: cardWidth * 0.09, weight: .semibold))
                                            .multilineTextAlignment(.center)
                                        Text(artwork.artist)
                                            .font(.system(size: cardWidth * 0.07))
                                            .foregroundColor(.secondary)
                                            .multilineTextAlignment(.center)
                                    }
                                    .padding(.horizontal)
                                }
                                .frame(width: cardWidth, height: cardHeight)
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                            // 접근성 설정
                            .accessibilityElement(children: .combine)
                            .accessibilityLabel("\(artwork.title) by \(artwork.artist)")
                            .accessibilityHint("Double tap to select this artwork")
                        }
                    }
                    .padding(.horizontal)
                    // 카드가 화면 중앙에 위치하도록 frame 설정
                    .frame(minWidth: geo.size.width, alignment: .center)
                }
            }
        }
    }
}
