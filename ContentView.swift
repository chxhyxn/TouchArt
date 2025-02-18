import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = ContentViewModel.shared
    
    var body: some View {
        Group {
            switch viewModel.appState {
            case .tutorial:
                TutorialView()
            case .artworkSelection:
                ArtworkSelectionView()
            case .artwork:
                ArtworkView()
            }
        }
    }
}
