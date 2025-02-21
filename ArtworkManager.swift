//
//  ArtworkManager.swift
//  TouchArt
//
//  Created by Sean Cho on 2/21/25.
//

import SwiftUI

@MainActor
class ArtworkManager: ObservableObject {
    static let shared = ArtworkManager()
    
    @Published var selectedArtwork: ArtworkItem? = nil
    
    let artworks: [ArtworkItem] = [
        ArtworkItem(
            title: "Starry Night",
            artist: "Vincent van Gogh",
            imageName: "StarryNight",
            areas: [
                ArtworkArea(id: 1, xRange: 10...20, yRange: 10...20, description: "이 영역은 별 영역"),
                ArtworkArea(id: 2, xRange: 30...40, yRange: 50...60, description: "이 영역은 달 영역")
            ]
        ),
        ArtworkItem(
            title: "PoppyField",
            artist: "Monet",
            imageName: "PoppyField",
            areas: [
                ArtworkArea(id: 1, xRange: 10...20, yRange: 10...20, description: "이 영역은 별 영역"),
                ArtworkArea(id: 2, xRange: 30...40, yRange: 50...60, description: "이 영역은 달 영역")
            ]
        ),
    ]
    
    private init() {}
    
}

struct ArtworkItem: Identifiable {
    let id = UUID()
    let title: String
    let artist: String
    let imageName: String
    let areas: [ArtworkArea]
}

struct ArtworkArea {
    let id: Int
    let xRange: ClosedRange<CGFloat>
    let yRange: ClosedRange<CGFloat>
    let description: String
}
