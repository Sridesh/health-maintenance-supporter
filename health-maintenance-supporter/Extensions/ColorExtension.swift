//
//  ColorExtension.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI

extension Color {
    static let appPrimary = Color(hex:"#303256")
    static let appSecondary = Color(hex: "#71759e")
    static let appText = Color(hex: "#080424")
    static let appYellow = Color(hex: "#ccb999")
    static let appBlue = Color(hex: "#a1d0e3")
    static let appGreen = Color(hex: "#9eb852")
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}
