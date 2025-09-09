//
//  Food.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI
import SwiftData

@Model
class Meal{
    @Attribute(.unique) var id: UUID
    var name: String
    var date: Date
    @Relationship(deleteRule: .cascade) var foodItems: [FoodItem]
    
    init(name: String, date: Date, foodItems: [FoodItem] = []) {
            self.id = UUID()
            self.name = name
            self.date = date
            self.foodItems = foodItems
        }
    
}
