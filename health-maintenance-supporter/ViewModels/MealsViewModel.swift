//
//  MealsViewModel.swift
//  health-maintenance-supporter
//

import SwiftUI
import SwiftData


// MARK: - MealsViewModel
@MainActor
final class MealsViewModel: ObservableObject {
    private let context: ModelContext
    
    
    @Published var meals: [Meal] = []
    
    // UI properties
    @Published var selectedMeal: String = ""
    @Published var mealWindowOpen: Bool = false
    
    init(context: ModelContext) {
        self.context = context
        
        Task {
            await checkAndCreateDefaultMeals()
        }
    }
    
    // MARK: - Initialize Default Meals for Today
    private func checkAndCreateDefaultMeals() async {
        let calendar = Calendar.current
           let startOfDay = calendar.startOfDay(for: Date())
           let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        let request = FetchDescriptor<Meal>(
            predicate: #Predicate { meal in
                        meal.date >= startOfDay && meal.date < endOfDay
                    }
        )
        
        let existingMeals = (try? context.fetch(request)) ?? []
        
        if existingMeals.isEmpty {
            // No meals exist for today → create default meals
            initiateMeals()
        }
        
        // Update published property
        self.meals = (try? context.fetch(request)) ?? existingMeals
    }
    
    private func initiateMeals() {
        addMeal(name: "Breakfast")
        addMeal(name: "Lunch")
        addMeal(name: "Dinner")
        addMeal(name: "Snacks")
    }
    
    // MARK: - CRUD for Meals
    func addMeal(name: String, date: Date = Date(), foodItems: [FoodItem] = []) {
        let meal = Meal(name: name, date: date, foodItems: foodItems)
        context.insert(meal)
        saveContext()
        meals.append(meal) // update published array
    }
    
    func deleteMeal(_ meal: Meal) {
        context.delete(meal)
        saveContext()
        meals.removeAll { $0.id == meal.id }
    }
    
    // MARK: - CRUD for Food Items
    func addFood(to meal: Meal, name: String, calories: Int, grams: Int) {
        let food = FoodItem(name: name, calories: calories, grams: grams)
        meal.foodItems.append(food)
        saveContext()
        objectWillChange.send() // notify UI for changes inside meal
    }
    
    func deleteFood(from meal: Meal, food: FoodItem) {
        if let index = meal.foodItems.firstIndex(where: { $0.id == food.id }) {
            meal.foodItems.remove(at: index)
            saveContext()
            objectWillChange.send()
        }
    }
    
    // MARK: - Total Calories
    func totalCalories(for meal: Meal) -> Int {
        meal.foodItems.reduce(0) { $0 + $1.calories }
    }
    
    func totalCaloriesToday() -> Int {
        meals.flatMap { $0.foodItems }.reduce(0) { $0 + $1.calories }
    }
    
    // MARK: - Meal Selection (UI)
    func changeMeal( meal: String) {
        self.selectedMeal = meal
        
    }
    
    func getMealList(meal: String) {
       
    }
    
    // MARK: - Save Context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error)")
        }
    }
}
