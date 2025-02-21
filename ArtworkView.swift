//
//  ArtworkView.swift
//  TouchArt
//
//  Created by Sean Cho on 2/17/25.
//

import SwiftUI
import AVFoundation

struct ArtworkView: View {
    @StateObject var contentViewModel = ContentViewModel.shared
    @StateObject var artworkManager = ArtworkManager.shared
    
    @State private var overlayColor: Color = .clear
    @State private var lastDragLocation: CGPoint = .zero

    private let synthesizer = AVSpeechSynthesizer()
    
    var artworkImage: UIImage {
        if let artwork = artworkManager.selectedArtwork,
           let image = UIImage(named: artwork.imageName) {
            return image
        } else {
            return UIImage()
        }
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
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
                
                Button(action: {
                    contentViewModel.appState = .artworkSelection
                }) {
                    Image(systemName: "chevron.left")
                        .font(.title)
                        .padding()
                        .background(Color.black.opacity(0.5))
                        .foregroundColor(.white)
//                        .clipShape(Circle())
                }
                .padding(.top, 20)
                .padding(.leading, 20)
            }
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        lastDragLocation = value.location
                        
                        if let color = getPixelColor(
                            image: artworkImage,
                            point: value.location,
                            viewSize: geo.size
                        ) {
                            overlayColor = color
                        }
                    }
                    .onEnded { _ in }
            )
            .simultaneousGesture(
                TapGesture(count: 2)
                    .onEnded {
                        getArtworkDescription(image: artworkImage,
                                              point: lastDragLocation,
                                              viewSize: geo.size)
                    }
            )
        }
    }
    
    private func getPixelColor(image: UIImage, point: CGPoint, viewSize: CGSize) -> Color? {
        guard let cgImage = image.cgImage else { return nil }
        
        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)
        
        let imageAspect = imageWidth / imageHeight
        let viewAspect = viewSize.width / viewSize.height
        
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
        
        let adjustedX = point.x - offsetX
        let adjustedY = point.y - offsetY
        
        guard adjustedX >= 0, adjustedX <= displayWidth,
              adjustedY >= 0, adjustedY <= displayHeight else {
            return nil
        }
        
        let xScale = imageWidth / displayWidth
        let yScale = imageHeight / displayHeight
        
        let imgX = Int(adjustedX * xScale)
        let imgY = Int(adjustedY * yScale)
        
        guard imgX >= 0, imgX < Int(imageWidth),
              imgY >= 0, imgY < Int(imageHeight) else {
            return nil
        }
        
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
    
    private func getArtworkDescription(image: UIImage, point: CGPoint, viewSize: CGSize) {
        guard let cgImage = image.cgImage else { return }
        
        let imageWidth = CGFloat(cgImage.width)
        let imageHeight = CGFloat(cgImage.height)
        
        let imageAspect = imageWidth / imageHeight
        let viewAspect = viewSize.width / viewSize.height
        
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
        
        let adjustedX = point.x - offsetX
        let adjustedY = point.y - offsetY
        
        guard adjustedX >= 0, adjustedX <= displayWidth,
              adjustedY >= 0, adjustedY <= displayHeight else {
            if synthesizer.isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            }
            speak("You’re outside the image area., To return to the artwork selection, tap the top-left corner of the display.")
            return
        }
        
        let xPercent = (adjustedX / displayWidth) * 100
        let yPercent = (adjustedY / displayHeight) * 100
        
        print("이미지 내부입니다. x: \(String(format: "%.1f", xPercent))%, y: \(String(format: "%.1f", yPercent))%")
        
        guard let selectedArtwork = artworkManager.selectedArtwork else { return }
        
        for area in selectedArtwork.areas {
            if area.xRange.contains(xPercent) && area.yRange.contains(yPercent) {
                if synthesizer.isSpeaking {
                    synthesizer.stopSpeaking(at: .immediate)
                }
                speak(area.description)
                break
            }
        }
    }
    
    private func speak(_ text: String) {
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
