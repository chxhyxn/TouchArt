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
            keyColors: ["Yellow", "Blue"],
            imageName: "StarryNight",
            background: "'별이 빛나는 밤'은 반 고흐가 생레미 드 프로방스에 위치한 생폴 드 모솔 정신 요양원에 머물던 시기에 완성되었습니다. 창문 밖으로 보이는 풍경을 바탕으로 했지만, 실제 풍경에 작가의 상상력이 더해져 독특한 분위기를 자아냅니다. 고흐 특유의 과감한 붓질과 강렬한 색감이 만들어 내는 움직임과 에너지가 작품 전체를 관통합니다.",
            areas: [
                ArtworkArea(id: 1, xRange: 14...28, yRange: 7...100,
                            description: "우뚝 솟아 있는 검푸른 사이프러스 나무는 전통적으로 장례나 죽음과 연관된 상징성을 지닙니다. 밤하늘로 뻗어 나가는 이 나무의 형태는 하늘의 소용돌이와 어우러지며 강렬한 수직선 대비를 이룹니다."),
                ArtworkArea(id: 2, xRange: 28...46, yRange: 64...100,
                            description: "우뚝 솟아 있는 검푸른 사이프러스 나무는 전통적으로 장례나 죽음과 연관된 상징성을 지닙니다. 밤하늘로 뻗어나가는 이 나무의 형태는 하늘의 소용돌이와 어우러지며 강렬한 수직선 대비를 이룹니다."),
                ArtworkArea(id: 3, xRange: 50...60, yRange: 65...89,
                            description: "조용한 마을 사이에, 고흐의 고향 네덜란드식 교회 첨탑을 떠올리게 하는 건물이 보입니다."),
                ArtworkArea(id: 4, xRange: 85...97, yRange: 10...24,
                            description: "초승달 형태의 밝게 빛나는 달이 보입니다. 실제로 그림이 완성된 시기의 달 모양과는 다릅니다. 이는 작가가 현실과 상상을 결합했음을 보여줍니다."),
                ArtworkArea(id: 5, xRange: 29...39, yRange: 46...60,
                            description: "사이프러스 나무 옆으로 가장 밝게 빛나는 금성이 보입니다."),
                ArtworkArea(id: 6, xRange: 0...65, yRange: 12...53,
                            description: "소용돌이치듯 흐르는 밤하늘이 보입니다. 이 소용돌이 형태는 반 고흐가 느낀 내면의 불안, 혹은 우주의 움직임을 시각화한 것이라는 해석도 있습니다."),
                ArtworkArea(id: 7, xRange: 60...100, yRange: 57...73,
                            description: "밤하늘과 마을 사이에 온화한 푸른 언덕이 보입니다."),
                ArtworkArea(id: 8, xRange: 0...100, yRange: 82...100,
                            description: "차분한 색감의 마을이 보입니다. 몇몇 건물의 창문으로 집안의 노란 불빛이 보입니다."),
                ArtworkArea(id: 9, xRange: 0...100, yRange: 0...82,
                            description: "밝은 별과 달에 대비되는 밤하늘이 소용돌이치고 있습니다. 고흐 특유의 감정적이고 역동적인 붓 터치를 느낄 수 있습니다."),
            ]
        ),
        ArtworkItem(
            title: "The Poppy Field near Argenteuil",
            year: "1873",
            artist: "Claude Monet",
            keyColors: ["Red", "Green"],
            imageName: "PoppyField",
            background: "1873년 이 그림을 완성했을 당시 33세였던 클로드 모네는 아르장퇴유에 살고 있었습니다. 모네가 아내 카미유와 아들 장을 모델로 했다고 전해집니다. 작품을 통해 햇살 아래 빛나는 한적한 들판, 그리고 느긋하게 산책하는 인물들을 감상하며 19세기 말 프랑스 시골의 정취를 느낄 수 있습니다.",
            areas: [
                ArtworkArea(id: 1, xRange: 14...21, yRange: 37...48,
                            description: "멀리 보이는 언덕 위 검은 옷의 여자와 밝은 옷의 어린아이가 보입니다. 그림 우측 하단의 아내와 아들이 반복 묘사된 것으로 해석됩니다."),
                ArtworkArea(id: 2, xRange: 57...62, yRange: 77...86,
                            description: "빨간 띠의 노란 모자를 쓴 어린아이가 보입니다. 오른 손엔 붉은 양귀비꽃을 꺾어 들고 있는 것처럼 보입니다."),
                ArtworkArea(id: 3, xRange: 67...78, yRange: 68...93,
                            description: "검은 띠의 챙이 넓은 하얀 모자를 쓴 여자가 보입니다. 검은 스카프와 하늘색 원피스를 입고 있으며, 오른손엔 하늘색 양산을 들고 있습니다."),
                ArtworkArea(id: 4, xRange: 55...60, yRange: 45...51,
                            description: "녹색 나무 사이로 주황색 지붕의 건물이 보입니다."),
                ArtworkArea(id: 5, xRange: 0...100, yRange: 29...52, description: "부드러운 명암의 녹색 나무들이 수평으로 늘어서 하늘과 들판을 위아래로 구분짓고 있습니다."),
                ArtworkArea(id: 6, xRange: 0...69, yRange: 47...100, description: "들판의 왼쪽 절반에 붉은빛 양귀비가 가득 피어 있습니다. 채도가 높은 붉은 양귀비와 밝은 녹색 들판의 조합은 햇살이 비치는 화사한 여름 풍경을 연상시키며, 자연의 생동감을 강조합니다."),
                ArtworkArea(id: 7, xRange: 0...100, yRange: 0...50, description: "옅은 톤의 구름 많은 하늘이 편안한 분위기를 자아내고 있습니다."),
                ArtworkArea(id: 8, xRange: 0...100, yRange: 50...100, description: "평화로운 들판입니다. 왼쪽 절반은 양귀비 꽃의 붉은 색이 지배적이고, 오른쪽 절반은 편안한 풀빛이 지배적입니다. 중앙 전경에는 모네의 아내 카미유와 아들 장이 보입니다."),
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
    let keyColors: [String]
    let imageName: String
    let background: String
    let areas: [ArtworkArea] // Precedent description takes precedence
}

struct ArtworkArea {
    let id: Int
    let xRange: ClosedRange<CGFloat>
    let yRange: ClosedRange<CGFloat>
    let description: String
}
