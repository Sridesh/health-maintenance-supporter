import SwiftUI
import Charts



// MARK: - Reusable Line Chart
struct LineChartView: View {
    let data: [DailyValue]
    let title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.bottom, 4)
            
            Chart {
                ForEach(data) { item in
                    LineMark(
                        x: .value("Date", item.date),
                        y: .value("Value", item.value)
                    )
                    .interpolationMethod(.catmullRom) // smooth curve
                    .foregroundStyle(LinearGradient(
                        colors: [Color.appSecondary, Color.appPrimary],
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    
                    PointMark(
                        x: .value("Date", item.date),
                        y: .value("Value", item.value)
                    )
                    .foregroundStyle(Color.purple)
                    .symbolSize(60)
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


