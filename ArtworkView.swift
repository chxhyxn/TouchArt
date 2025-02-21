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
    
    @State private var displayedSubtitle: String?

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
                    .accessibilityLabel("\(artworkManager.selectedArtwork?.title ?? "")")
                    .accessibilityHint("Please turn off VoiceOver temporarily to use TouchArt’s features.")

                Rectangle()
                    .fill(overlayColor)
                    .opacity(0.9)
                    .animation(.easeInOut(duration: 1.0), value: overlayColor)
                
                Button(action: {
                    speak("You pressed the back button. Returning to the artwork selection.")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                        contentViewModel.appState = .artworkSelection
                    }
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
                .accessibilityLabel("Return to the artwork selection")
                
                if let subtitle = displayedSubtitle {
                    Text(subtitle)
                        .font(.title3)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.7))
                        .cornerRadius(10)
                        .zIndex(1)
                        .position(x: geo.size.width / 2, y: geo.size.height * 0.1 + 30)
                        .transition(.opacity)
                }
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
            return .clear
        }
        
        let xScale = imageWidth / displayWidth
        let yScale = imageHeight / displayHeight
        
        let imgX = Int(adjustedX * xScale)
        let imgY = Int(adjustedY * yScale)
        
        guard imgX >= 0, imgX < Int(imageWidth),
              imgY >= 0, imgY < Int(imageHeight) else {
            return .clear
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
            speak("You’re outside the image area.")
            return
        }
        
        let xPercent = (adjustedX / displayWidth) * 100
        let yPercent = (adjustedY / displayHeight) * 100
        
        guard let selectedArtwork = artworkManager.selectedArtwork else { return }
        
        for area in selectedArtwork.areas {
            if area.xRange.contains(xPercent) && area.yRange.contains(yPercent) {
                speak(area.description)
                return
            }
        }
    }
    
    private func speak(_ text: String) {
        displayedSubtitle = text
        
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            if displayedSubtitle == text {
                withAnimation {
                    displayedSubtitle = nil
                }
            }
        }
    }
}
