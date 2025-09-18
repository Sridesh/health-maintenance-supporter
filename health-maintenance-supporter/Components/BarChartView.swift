//
//  BarChartView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-16.
//

import SwiftUI
import Charts

// MARK: - Data Model
struct DailyValue: Identifiable {
    var id = UUID()
    let date: String   // e.g., "2025-09-16"
    let value: Int
}

// MARK: - Reusable Bar Chart
struct BarChartView: View {
    let data: [DailyValue]
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            
            Chart {
                ForEach(data) { item in
                    BarMark(
                        x: .value("Date", item.date),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(LinearGradient(
                        colors: [Color.appSecondary, Color.appPrimary],
                        startPoint: .bottom,
                        endPoint: .top
                    ))
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic(desiredCount: data.count)) { _ in
                    AxisGridLine()
                    AxisTick()
                    AxisValueLabel(centered: true)
                }
            }
            .frame(height: 200)
        }
        .padding()
    }
}

