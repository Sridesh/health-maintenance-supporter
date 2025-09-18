//
//  FruitMacro.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//

struct FruitMacro: Identifiable {
    let id: Int
    let name: String
    let carbs: Double    // in grams
    let protein: Double  // in grams
    let fat: Double      // in grams
    let calories: Double // kcal
    let description: String
}

let fruitMacros: [FruitMacro] = [
    FruitMacro(id: 1, name: "Apple", carbs: 14.0, protein: 0.3, fat: 0.2, calories: 52,
               description: "Rich in fiber and antioxidants. Supports heart health and aids digestion."),
    FruitMacro(id: 2, name: "Banana", carbs: 23.0, protein: 1.1, fat: 0.3, calories: 96,
               description: "High in potassium, great for muscle function and energy boost."),
    FruitMacro(id: 3, name: "Orange", carbs: 12.0, protein: 0.9, fat: 0.1, calories: 47,
               description: "Excellent source of vitamin C. Boosts immunity and supports skin health."),
    FruitMacro(id: 4, name: "Cherry", carbs: 8.0, protein: 0.7, fat: 0.3, calories: 32,
               description: "Loaded with antioxidants and vitamin C. Supports heart health and reduces inflammation."),
    FruitMacro(id: 5, name: "Papaya", carbs: 18.0, protein: 0.6, fat: 0.2, calories: 69,
               description: "Contains resveratrol, which may protect against heart disease and support brain health."),
    FruitMacro(id: 6, name: "Pineapple", carbs: 13.0, protein: 0.5, fat: 0.1, calories: 50,
               description: "Rich in bromelain enzyme. Helps digestion and reduces inflammation."),
    FruitMacro(id: 7, name: "Mango", carbs: 15.0, protein: 0.8, fat: 0.4, calories: 60,
               description: "High in vitamin A and C. Supports eye health and boosts immunity."),
    FruitMacro(id: 8, name: "Dragon Fruit", carbs: 11.0, protein: 1.1, fat:                         0.4,calories:50, description: "High in fiber and vitamin C. Supports digestive health and boosts immunity.")
]

func getFruitMacro(by name: String) -> FruitMacro? {
    return fruitMacros.first { $0.name.lowercased() == name.lowercased() }
}
