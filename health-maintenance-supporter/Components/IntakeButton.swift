//
//  IntakeButton.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-12.
//

import SwiftUI

struct IntakeButton: View {
    let title: String
    let color: Color
    let border: Color
    var body: some View {
        Text(title)
            .font(.caption.bold())
            .foregroundColor(border)
            .frame(width: 60, height: 32)
            .background(color)
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(border, lineWidth: 1.5)
            )
    }
}
