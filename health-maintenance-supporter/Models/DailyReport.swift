//
//  DailyReport.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-16.
//


import SwiftUI
import SwiftData

@Model
class DailyReport {
    @Attribute(.unique) var dateString: String
    var calorieTotal: Int
    var stepsTotal: Int
    var waterTotal: Int
    var distanceTotal: Int
    var macrosTotal: Macro
    var taskCompletion: Double

    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
    
    init(date: Date, calorieTotal: Int, stepsTotal: Int, waterTotal: Int, distanceTotal: Int, macrosTotal: Macro, taskCompletion: Double
    ) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateString = formatter.string(from: date)
        self.calorieTotal = calorieTotal
        self.stepsTotal = stepsTotal
        self.waterTotal = waterTotal
        self.distanceTotal = distanceTotal
        self.macrosTotal = macrosTotal
        self.taskCompletion = taskCompletion
    }
}
