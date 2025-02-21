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
            title: "The Starry Night",
            year: "1889",
            artist: "Vincent van Gogh",
            keyColors: "Yellow and Blue",
            imageName: "StarryNight",
            areas: [
                ArtworkArea(
                    id: 1,
                    xRange: 14...28,
                    yRange: 7...100,
                    description: "The tall, dark green cypress tree traditionally symbolizes funerals or death. Its form stretches up into the night sky, blending with the swirling heavens and creating a striking vertical contrast."
                ),
                ArtworkArea(
                    id: 2,
                    xRange: 28...46,
                    yRange: 64...100,
                    description: "The tall, dark green cypress tree traditionally symbolizes funerals or death. Its form stretches up into the night sky, blending with the swirling heavens and creating a striking vertical contrast."
                ),
                ArtworkArea(
                    id: 3,
                    xRange: 50...60,
                    yRange: 65...89,
                    description: "Between the quiet houses, a building reminiscent of a Dutch church steeple—Van Gogh’s homeland—catches your eye."
                ),
                ArtworkArea(
                    id: 4,
                    xRange: 85...97,
                    yRange: 10...24,
                    description: "A bright crescent moon shines in the sky. Interestingly, the moon’s shape here differs from what it would have actually looked like when the painting was completed. This choice shows how Van Gogh combined reality with imagination."
                ),
                ArtworkArea(
                    id: 5,
                    xRange: 29...39,
                    yRange: 46...60,
                    description: "Next to the cypress tree, you can spot Venus shining brightest among the stars."
                ),
                ArtworkArea(
                    id: 6,
                    xRange: 0...65,
                    yRange: 12...53,
                    description: "The night sky appears to swirl with movement. Some interpret these swirling forms as visual expressions of Van Gogh’s inner anxiety or the motion of the cosmos."
                ),
                ArtworkArea(
                    id: 7,
                    xRange: 60...100,
                    yRange: 57...73,
                    description: "A gentle blue hill lies between the night sky and the village."
                ),
                ArtworkArea(
                    id: 8,
                    xRange: 0...100,
                    yRange: 82...100,
                    description: "A tranquil-colored village comes into view. A few building windows glow softly with yellow light from inside."
                ),
                ArtworkArea(
                    id: 9,
                    xRange: 0...100,
                    yRange: 0...82,
                    description: "The swirling night sky stands in contrast to the bright stars and moon. You can feel Van Gogh’s emotionally charged, dynamic brushwork."
                ),
            ]
        ),
        ArtworkItem(
            title: "The Poppy Field near Argenteuil",
            year: "1873",
            artist: "Claude Monet",
            keyColors: "Red and Green",
            imageName: "PoppyField",
            areas: [
                ArtworkArea(
                    id: 1,
                    xRange: 14...21,
                    yRange: 37...48,
                    description: "In the distance on the hill, a woman in dark clothing and a child in lighter clothing can be seen. It is interpreted that Monet repeated the depiction of his wife and son, as shown in the lower right of the painting."
                ),
                ArtworkArea(
                    id: 2,
                    xRange: 57...62,
                    yRange: 77...86,
                    description: "A child wearing a yellow hat with a red band is visible. In their right hand, they seem to be holding a freshly picked red poppy flower."
                ),
                ArtworkArea(
                    id: 3,
                    xRange: 65...78,
                    yRange: 68...93,
                    description: "A woman in a white hat with a wide brim and a black band appears. She’s wearing a black scarf and a sky-blue dress, and holding a light blue parasol in her right hand."
                ),
                ArtworkArea(
                    id: 4,
                    xRange: 55...60,
                    yRange: 45...51,
                    description: "A building with an orange roof can be spotted among the green trees."
                ),
                ArtworkArea(
                    id: 5,
                    xRange: 0...100,
                    yRange: 40...52,
                    description: "A horizontal line of green trees with soft gradations of light and shade separates the sky from the field above and below."
                ),
                ArtworkArea(
                    id: 6,
                    xRange: 0...69,
                    yRange: 47...100,
                    description: "The left half of the field is full of bright red poppies. The combination of highly saturated red poppies and vivid green fields evokes a sunlit, summery landscape, emphasizing the liveliness of nature."
                ),
                ArtworkArea(
                    id: 7,
                    xRange: 0...100,
                    yRange: 0...50,
                    description: "The soft-hued, cloud-filled sky creates a calm and comfortable atmosphere."
                ),
                ArtworkArea(
                    id: 8,
                    xRange: 0...100,
                    yRange: 50...100,
                    description: "It’s a peaceful field. The left side is dominated by the bright red of poppies, while the right side is covered in soothing green grass. In the central foreground, Monet’s wife Camille and their son Jean can be seen."
                ),
            ]
        ),
    ]
    
    private init() {}
}

struct ArtworkItem: Identifiable {
    let id = UUID()
    let title: String
    let year: String
    let artist: String
    let keyColors: String
    let imageName: String
    let areas: [ArtworkArea]
}

struct ArtworkArea {
    let id: Int
    let xRange: ClosedRange<CGFloat>
    let yRange: ClosedRange<CGFloat>
    let description: String
}
