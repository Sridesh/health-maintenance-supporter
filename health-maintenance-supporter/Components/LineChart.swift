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
                        colors: [Color.blue, Color.purple],
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

// MARK: - Preview
struct LineChartView_Previews: PreviewProvider {
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
        
        LineChartView(data: sampleData, title: "Steps Last Week")
    }
}
