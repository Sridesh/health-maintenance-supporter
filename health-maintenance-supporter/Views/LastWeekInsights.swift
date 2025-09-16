//
//  LastWeekInsights.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-16.
//

import SwiftUI

struct LastWeekInsights: View {
    @State private var insights: [DailyReport] = []   // stores fetched reports
    
    var body: some View {
        VStack {
            if insights.isEmpty {
                Text("No insights yet...")
                    .foregroundColor(.gray)
            } else {
                List(insights, id: \.dateString) { report in
                    VStack(alignment: .leading) {
                        Text("📅 \(report.dateString)")
                            .font(.headline)
                        Text("Calories: \(report.calorieTotal)")
                        Text("Steps: \(report.stepsTotal)")
                        Text("Water: \(report.waterTotal)L")
                        Text("Completion: \(report.taskCompletion)%")
                    }
                }
            }
        }
        .onAppear {
            DailyReportManager.fetchDailyReportsLastWeek { reports in
                insights = reports
            }
        }
    }
}
