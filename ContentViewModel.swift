//
//  ContentViewModel.swift
//  TouchArt
//
//  Created by Sean Cho on 2/17/25.
//

import SwiftUI


enum AppState {
    case tutorial
    case artworkSelection
    case artwork
}

@MainActor
class ContentViewModel: ObservableObject {
    static let shared = ContentViewModel()
    
    @Published var appState: AppState = .tutorial
    @Published var selectedArtwork: ArtworkItem? = nil
    
    private init() {}
}
