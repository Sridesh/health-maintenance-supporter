//
//  GlassCard.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-12.
//

import SwiftUI

struct GlassCard<Content: View>: View {
    let content: Content
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            content
        }
        .padding(20)
        .background(
            BlurView(style: .systemUltraThinMaterial)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.glassBackground.opacity(0.5), Color.glassBackground.opacity(0.4)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .cornerRadius(28)
        .shadow(color: Color.black.opacity(0.06), radius: 16, x: 0, y: 8)
    }
}


struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        UIVisualEffectView(effect: UIBlurEffect(style: style))
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}
