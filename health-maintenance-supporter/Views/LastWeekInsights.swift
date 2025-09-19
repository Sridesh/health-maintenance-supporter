//
//  LastWeekInsights.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-16.
//

import SwiftUI

struct LastWeekInsights: View {
    @EnvironmentObject var userViewModel:UserViewModel
    
    @State private var insights: [DailyReport] = []
    
    // MARK: - Fetched Historical Chart Data
    private var waterData: [DailyValue] {
        insights.map { DailyValue(date: $0.dateString.monthDayOnly(), value: $0.waterTotal) }
    }
    
    private var calorieDataWeek: [DailyValue] {
        insights.map { DailyValue(date: $0.dateString.monthDayOnly(), value: $0.calorieTotal) }
    }
    
    private var stepsDataWeek: [DailyValue] {
        insights.map { DailyValue(date: $0.dateString.monthDayOnly(), value: $0.stepsTotal) }
    }
    
    private var distanceDataWeek: [DailyValue] {
        insights.map { DailyValue(date: $0.dateString.monthDayOnly(), value: $0.distanceTotal) }
    }
    
    private var macroDataWeek: [MacroValue] {
        let totalProtein = insights.reduce(0) { $0 + $1.macrosTotal.protein }
        let totalCarbs   = insights.reduce(0) { $0 + $1.macrosTotal.carbs }
        let totalFat     = insights.reduce(0) { $0 + $1.macrosTotal.fats }
        
        let sum = Double(totalProtein + totalCarbs + totalFat)
        guard sum > 0 else { return [] }
        
        return [
            MacroValue(type: "Protein", value: (Double(totalProtein) / sum) * 100),
            MacroValue(type: "Carbs",   value: (Double(totalCarbs) / sum) * 100),
            MacroValue(type: "Fat",     value: (Double(totalFat) / sum) * 100)
        ]
    }

    
    var body: some View {
            VStack(alignment: .leading, spacing: 24) {
                if insights.isEmpty {
                    Text("No insights yet")
                        .foregroundColor(.gray)
                        .padding()
                } else {
                    //water
                    GlassCard{
                        BarChartView(data: waterData, title: "Water Intake (L)")
                    }
                    
                    //calories
                    GlassCard{
                        BarChartView(data: calorieDataWeek, title: "Calories Burned")
                    }
                    
                    //steps
                    GlassCard{
                        LineChartView(data: stepsDataWeek, title: "Steps")
                    }
                    
                    //distance
                    GlassCard{
                        LineChartView(data: distanceDataWeek, title: "Distance (km)")
                    }
                    
                    //macros
                    GlassCard{
                        PieChartView(data: macroDataWeek, title: "Macros intake Last Week")
                    }
                }
            }
            .padding()
            .onAppear {
                DailyReportManager.fetchDailyReportsLastWeek(email: userViewModel.currentUser.email){ reports in
                insights = reports
            }
        }
    }
}
