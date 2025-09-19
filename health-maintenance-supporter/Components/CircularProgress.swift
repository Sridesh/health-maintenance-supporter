//
//  CircularProgress.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-09.
//

import SwiftUI

struct CircularProgress: View {
    public var color: Color
    public var fullAmount: Double
    public var amount: Double
    public var name: String

    var progress: Double {
        fullAmount == 0 ? 0 : amount / fullAmount
    }
    
    var body: some View {
        ZStack {
            //background circle
            Circle()
                .stroke(color.opacity(0.1), lineWidth: 7)
            
            //foreground circle
            Circle()
                .trim(from: 0, to: progress)
                .stroke(color, style: StrokeStyle(lineWidth: 7, lineCap: .round))
                .rotationEffect(.degrees(-90))
            
            //lbels
            VStack {
                Text("\(String(format: "%.1f", amount))g")
                    .font(.system(size: 12))
                    .foregroundColor(Color(hex: "#3e3e3e"))
                    .bold()
                
                Text(name)
                    .font(.system(size: 10))
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 70, height: 70)
        .padding(.trailing, 10)
    }
}
