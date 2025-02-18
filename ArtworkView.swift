//
//  ArtworkView.swift
//  TouchArt
//
//  Created by Sean Cho on 2/17/25.
//

import SwiftUI

struct ArtworkView: View {
    // ContentViewModel을 관찰합니다.
    @StateObject var viewModel = ContentViewModel.shared
    @State private var overlayColor: Color = .clear
    
    // viewModel의 selectedArtwork 값을 활용하여 이미지 로딩
    var artworkImage: UIImage {
        if let artwork = viewModel.selectedArtwork,
           let image = UIImage(named: artwork.imageName) {
            return image
        } else {
            // 기본 이미지: selectedArtwork가 nil이면 기본값으로 "PoppyField"를 사용합니다.
            return UIImage(named: "PoppyField") ?? UIImage()
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                // 배경 이미지와 오버레이
                Image(uiImage: artworkImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: geo.size.width,
                           height: geo.size.height)
                    .clipped()
                
                Rectangle()
                    .fill(overlayColor)
                    .opacity(0.9)
                    .animation(.easeInOut(duration: 1.0), value: overlayColor)
                
                // 왼쪽 위에 selectionView로 돌아가는 버튼 추가
                Button(action: {
                    viewModel.appState = .artworkSelection
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
                        .clipShape(Circle())
                }
                .padding(.top, 20)
                .padding(.leading, 20)
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        let tapLocation = value.location
                        if let color = getPixelColor(
                            image: artworkImage,
                            point: tapLocation,
                            viewSize: geo.size
                        ) {
                            overlayColor = color
                        }
                    }
                    .onEnded { _ in }
            )
        }
    }
    
    private func getPixelColor(image: UIImage, point: CGPoint, viewSize: CGSize) -> Color? {
        guard let cgImage = image.cgImage else { return nil }
        
        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)
        
        // 이미지와 뷰의 종횡비 계산
        let imageAspect = imageWidth / imageHeight
        let viewAspect = viewSize.width / viewSize.height
        
        // 실제로 표시되는 이미지의 크기와 오프셋(여백) 계산
        var displayWidth: CGFloat = 0
        var displayHeight: CGFloat = 0
        var offsetX: CGFloat = 0
        var offsetY: CGFloat = 0
        
        if imageAspect > viewAspect {
            displayWidth = viewSize.width
            displayHeight = viewSize.width / imageAspect
            offsetY = (viewSize.height - displayHeight) / 2
        } else {
            displayHeight = viewSize.height
            displayWidth = viewSize.height * imageAspect
            offsetX = (viewSize.width - displayWidth) / 2
        }
        
        // 터치 위치가 실제 이미지 영역 내에 있는지 확인
        let adjustedX = point.x - offsetX
        let adjustedY = point.y - offsetY
        
        guard adjustedX >= 0, adjustedX <= displayWidth,
              adjustedY >= 0, adjustedY <= displayHeight else {
            return nil
        }
        
        // 뷰 상의 좌표를 실제 이미지의 픽셀 좌표로 변환
        let xScale = imageWidth / displayWidth
        let yScale = imageHeight / displayHeight
        
        let imgX = Int(adjustedX * xScale)
        let imgY = Int(adjustedY * yScale)
        
        guard imgX >= 0, imgX < Int(imageWidth),
              imgY >= 0, imgY < Int(imageHeight) else {
            return nil
        }
        
        // 픽셀 데이터 추출
        guard let pixelData = cgImage.dataProvider?.data else { return nil }
        let data = CFDataGetBytePtr(pixelData)
        let bytesPerPixel = 4
        let offset = (imgY * Int(imageWidth) + imgX) * bytesPerPixel
        
        let red   = CGFloat(data?[offset + 0] ?? 0) / 255.0
        let green = CGFloat(data?[offset + 1] ?? 0) / 255.0
        let blue  = CGFloat(data?[offset + 2] ?? 0) / 255.0
        let alpha = CGFloat(data?[offset + 3] ?? 0) / 255.0
        
        return Color(red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
    }
}
