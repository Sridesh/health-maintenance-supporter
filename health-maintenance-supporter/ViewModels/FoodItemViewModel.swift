//
//  FoodItemViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-09.
//
import SwiftUI
import SwiftData

struct Nutrition {
    let calories: Double   // kcal
    let carbs: Double      // g
    let sugar: Double      // g
    let fiber: Double      // g
    let protein: Double    // g
    let fat: Double        // g
}

@MainActor
final class FoodItemViewModel: ObservableObject {
    @Published var searching = false
    @Published var selectedFood : String = "none"
    @Published var selectedMeal : String = "none"
    
    private let context: ModelContext
    
    init(context: ModelContext) {
        self.context = context
    }
    
    // MARK: - Initialize Default Meals for Today
    func changeSelectedFood(food: String) {
        self.selectedFood = food
    }
}
