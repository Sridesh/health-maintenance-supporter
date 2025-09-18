//
//  MacroPieChart.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-18.
//

import SwiftUI
import Charts

struct MacroValue: Identifiable {
    var id = UUID()
    let type: String
    let value: Double
}


struct PieChartView: View {
    let data: [MacroValue]
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            
            Chart {
                ForEach(data) { item in
                    SectorMark(
                        angle: .value("Value", item.value),
                        innerRadius: .ratio(0.5),
                        angularInset: 1.5
                    )
                    .foregroundStyle(by: .value("Macro", item.type))
                }
            }
            .frame(height: 250)
            .padding()
            
            //Legends
//            HStack {
//                ForEach(data) { item in
//                    HStack {
//                        Circle()
//                            .fill(Color.accentColor)
//                            .frame(width: 10, height: 10)
//                        Text("\(item.type): \(String(format: "%.1f", item.value))%")
//                            .font(.caption)
//                    }
//                }
//            }
//            .padding(.horizontal)
        }
    }
}

