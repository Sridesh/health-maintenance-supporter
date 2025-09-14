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

let fruitNutrition: [String: Nutrition] = [
    "Apple": Nutrition(
        calories: 52,
        carbs: 14,
        sugar: 10,
        fiber: 2.4,
        protein: 0.3,
        fat: 0.2
    ),
    "Banana": Nutrition(
        calories: 89,
        carbs: 23,
        sugar: 12,
        fiber: 2.6,
        protein: 1.1,
        fat: 0.3
    ),
    "Mango": Nutrition(
        calories: 60,
        carbs: 15,
        sugar: 14,
        fiber: 1.6,
        protein: 0.8,
        fat: 0.4
    ),
    "Pineapple": Nutrition(
        calories: 50,
        carbs: 13,
        sugar: 10,
        fiber: 1.4,
        protein: 0.5,
        fat: 0.1
    )
]

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
    
    // MARK: - Get nutrition for a food
    func getNutrition(food: String) -> Nutrition? {
        return fruitNutrition[food]
    }
}
