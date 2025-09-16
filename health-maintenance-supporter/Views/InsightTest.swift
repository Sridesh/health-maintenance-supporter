////
////  InsightTest.swift
////  health-maintenance-supporter
////
////  Created by Sridesh 001 on 2025-09-16.
////
//
//import SwiftUI
//import Charts
//
//// MARK: - Reusable Data Model for Charts
//struct ChartValue: Identifiable {
//    var id = UUID()
//    let date: String
//    let value: Double
//}
//
//// MARK: - Last Week Insights with Charts
//struct LastWeekInsightsTest: View {
//    @State private var insights: [DailyReport] = []   // fetched reports
//    
//    var body: some View {
//        ScrollView {
//            VStack(spacing: 24) {
//                
//                if insights.isEmpty {
//                    Text("No insights yet...")
//                        .foregroundColor(.gray)
//                        .padding()
//                } else {
//                    
//                    // 1️⃣ Water Bar Chart
//                    BarChartView(
//                        data: insights.map { ChartValue(date: $0.dateString, value: Double($0.waterTotal)) },
//                        title: "Water Intake (L)"
//                    )
//                    
//                    // 2️⃣ Calories Bar Chart
//                    BarChartView(
//                        data: insights.map { ChartValue(date: $0.dateString, value: Double($0.calorieTotal)) },
//                        title: "Calories"
//                    )
//                    
//                    // 3️⃣ Steps Line Chart
//                    LineChartView(
//                        data: insights.map { ChartValue(date: $0.dateString, value: Double($0.stepsTotal)) },
//                        title: "Steps"
//                    )
//                    
//                    // 4️⃣ Distance Line Chart
//                    LineChartView(
//                        data: insights.map { ChartValue(date: $0.dateString, value: $0.distanceTotal) },
//                        title: "Distance (km)"
//                    )
//                }
//            }
//            .padding()
//        }
//        .onAppear {
//            DailyReportManager.fetchDailyReportsLastWeek { reports in
//                insights = reports
//            }
//        }
//    }
//}
//
//
//
//// MARK: - Preview
//struct LastWeekInsights_Previews: PreviewProvider {
//    static var previews: some View {
//        let mockReports: [DailyReport] = [
//            DailyReport(dateString:"2025-09-10", calorieTotal: 2000, stepsTotal: 5000, waterTotal: 2, distanceTotal: 4, macrosTotal: Macro(carbs: 0, protein: 0, fats: 0), taskCompletion: 80),
//            DailyReport(dateString: "09-11", calorieTotal: 1800, stepsTotal: 6000, waterTotal: 1.8, distanceTotal: 5, macrosTotal: Macro(carbs: 0, protein: 0, fats: 0), taskCompletion: 70),
//            DailyReport(dateString: "09-12", calorieTotal: 2200, stepsTotal: 7000, waterTotal: 2.2, distanceTotal: 6, macrosTotal: Macro(carbs: 0, protein: 0, fats: 0), taskCompletion: 90)
//        ]
//        
//        LastWeekInsights(insights: mockReports)
//    }
//}
