//
//  Water.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-15.
//

import SwiftUI
import SwiftData

@Model
class Water {
    @Attribute(.unique) var dateString: String
    var intake: Double
    

    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
    
    init(date: Date, intake:Double) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateString = formatter.string(from: date)
        self.intake = intake
    }
}
