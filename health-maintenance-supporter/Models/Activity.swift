//
//  Activity.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-14.
//

import SwiftUI
import SwiftData

@Model
class Activity {
    @Attribute(.unique) var date: Date
    var steps: Int
    var distance: Double
    var burn: Int
    
    init(date: Date, steps: Int, distance: Double, burn: Int) {
        self.date = date
        self.steps = steps
        self.distance = distance
        self.burn = burn
    }
}

