//
//  MacroStatCircle.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-12.
//

import SwiftUI

struct MacroStat: View {
    let name: String
    let value: Double
    let goal: Double
    let color: Color
    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
//                Circle()
//                    .fill(color)
//                    .frame(width: 10, height: 10)
                Text(name)
                    .foregroundColor(.secondary)
            }
            ZStack(alignment: .leading) {
                Capsule()
                    .fill(Color.blue.opacity(0.12))
                    .frame(height: 8)
                Capsule()
                    .fill(LinearGradient(colors: [Color.purple, Color.blue], startPoint: .leading, endPoint: .trailing))
                    .frame(width: CGFloat(min(value/goal, 1)) * 60, height: 8)
            }
            .frame(width: 60)
            Text("\(Int(value))/\(Int(goal))")
                .font(.system(size: 16))
                .foregroundColor(.primary)
        }
        .frame(width: 70)
    }
}


#Preview {
    MacroStat(name: "sdad", value: 1.1, goal: 1.1, color: Color.red)
}
