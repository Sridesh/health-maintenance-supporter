//
//  FoodItem.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI
import SwiftData

@Model
class FoodItem {
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Int
    var grams: Int

    init(name: String, calories: Int, grams: Int) {
        self.id = UUID()
        self.name = name
        self.calories = calories
        self.grams = grams
    }
}
