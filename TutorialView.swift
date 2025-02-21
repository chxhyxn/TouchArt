//
//  TutorialView.swift
//  TouchArt
//
//  Created by Sean Cho on 2/15/25.
//

import SwiftUI

struct TutorialView: View {
    private let messages = [
        "Welcome!",
        "TouchArt is a masterpiece viewing app designed for visually impaired users.",
        "When you touch a painting, the vibrant colors of the artwork will fill your screen.",
        "Gently move your finger to experience the subtle shifts in color.",
        "If you need further explanation, double-tap on that area to receive a voice guide.",
        "Now, select the masterpiece you wish to enjoy and immerse yourself in the world of art."
    ]
    
    @State private var currentIndex: Int = 0
    @State private var opacity: Double = 0.0
    @State private var timer: Timer? = nil
    
    var body: some View {
        ZStack {
            Color.black
                .ignoresSafeArea()
            
            Text(messages[currentIndex])
                .foregroundColor(.white)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                .padding()
                .opacity(opacity)
                .onAppear {
                    fadeInText()
                    startTimer()
                }
        }
    }
    
    private func fadeInText() {
        withAnimation(.easeIn(duration: 1.5)) {
            opacity = 1.0
        }
    }
    
    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            DispatchQueue.main.async {
                if currentIndex < messages.count - 1 {
                    withAnimation(.easeOut(duration: 0.5)) {
                        opacity = 0
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        currentIndex += 1
                        fadeInText()
                    }
                } else {
                    timer?.invalidate()
                    ContentViewModel.shared.appState = .artworkSelection
                }
            }
        }
    }
}
