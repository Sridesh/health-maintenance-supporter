//
//  Food.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI
import SwiftData

@Model
class Macro{
    var carbs: Double
    var protein: Double
    var fats: Double
    
    init(carbs: Double, protein: Double, fats: Double) {
        self.carbs = carbs
        self.protein = protein
        self.fats = fats
    }
}

@Model
class Food {
    @Attribute(.unique) var id: UUID
    var name: String
    var calories: Int
    var grams: Int
    @Relationship(deleteRule: .cascade) var macros: Macro?
    
    init(name: String, calories: Int, grams: Int, macros: Macro? = nil) {
        self.id = UUID()
        self.name = name
        self.calories = calories
        self.grams = grams
        self.macros = macros
    }
}

@Model
class Meal {
    @Attribute(.unique) var id: UUID
    var name: String
    @Relationship(deleteRule: .cascade) var foodItems: [Food]
    
    init(name: String, foodItems: [Food] = []) {
        self.id = UUID()
        self.name = name
        self.foodItems = foodItems
    }
}

@Model
class MealList {
    @Attribute(.unique) var dateString: String  
    var meals: [Meal]
    

    var date: Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: dateString) ?? Date()
    }
    
    init(date: Date, meals: [Meal]) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        self.dateString = formatter.string(from: date)
        self.meals = meals
    }
}
