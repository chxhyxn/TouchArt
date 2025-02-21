//
//  ContentViewModel.swift
//  TouchArt
//
//  Created by Sean Cho on 2/17/25.
//

import SwiftUI

@MainActor
class ContentViewModel: ObservableObject {
    static let shared = ContentViewModel()
    
    @Published var appState: AppState = .tutorial
    
    private init() {}
}

enum AppState {
    case tutorial
    case artworkSelection
    case artwork
}
