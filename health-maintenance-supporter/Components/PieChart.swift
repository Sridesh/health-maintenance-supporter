//
//  PieChart.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import Charts

struct PieChart: View {
    
    let data : [
        NutritionCount
    ]
    
    @EnvironmentObject var mealViewModel: MealsViewModel
    
    var body: some View {
        Chart(data, id: \.category) { item in
            SectorMark(
                angle: .value("Count", item.count),
                innerRadius: .ratio(0.6),
                angularInset: 2
            )
            .foregroundStyle(by: .value("Category", item.category))
        }
        .scaledToFit()
    }
}
