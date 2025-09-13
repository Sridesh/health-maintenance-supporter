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
}

let fruitMacros: [FruitMacro] = [
    FruitMacro(id: 1, name: "Apple", carbs: 14.0, protein: 0.3, fat: 0.2, calories: 52),
    FruitMacro(id: 2, name: "Banana", carbs: 23.0, protein: 1.1, fat: 0.3, calories: 96),
    FruitMacro(id: 3, name: "Orange", carbs: 12.0, protein: 0.9, fat: 0.1, calories: 47),
    FruitMacro(id: 4, name: "Strawberry", carbs: 8.0, protein: 0.7, fat: 0.3, calories: 32),
    FruitMacro(id: 5, name: "Grapes", carbs: 18.0, protein: 0.6, fat: 0.2, calories: 69),
    FruitMacro(id: 6, name: "Pineapple", carbs: 13.0, protein: 0.5, fat: 0.1, calories: 50),
    FruitMacro(id: 7, name: "Mango", carbs: 15.0, protein: 0.8, fat: 0.4, calories: 60),
    FruitMacro(id: 8, name: "Kiwi", carbs: 15.0, protein: 1.1, fat: 0.5, calories: 61),
    FruitMacro(id: 9, name: "Blueberry", carbs: 14.5, protein: 0.7, fat: 0.3, calories: 57),
    FruitMacro(id: 10, name: "Watermelon", carbs: 8.0, protein: 0.6, fat: 0.2, calories: 30),
    FruitMacro(
        id: 11,
        name: "Dragon Fruit",
        carbs: 11.0,
        protein: 1.1,
        fat: 0.4,
        calories: 50
    )
]
