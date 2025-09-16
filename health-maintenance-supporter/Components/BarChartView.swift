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
                        colors: [Color.blue, Color.purple],
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

// MARK: - Preview
struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleData: [DailyValue] = [
            DailyValue(date: "09-10", value: 5000),
            DailyValue(date: "09-11", value: 7000),
            DailyValue(date: "09-12", value: 6500),
            DailyValue(date: "09-13", value: 8000),
            DailyValue(date: "09-14", value: 4000),
            DailyValue(date: "09-15", value: 9000),
            DailyValue(date: "09-16", value: 7500),
        ]
        
        BarChartView(data: sampleData, title: "Steps Last Week")
    }
}
