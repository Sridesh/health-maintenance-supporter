//
//  MealsViewModel.swift
//  health-maintenance-supporter
//

import SwiftUI
import SwiftData

@MainActor
final class MealsViewModel: ObservableObject {
    private var context: ModelContext
    
    @Published var todayMealList: MealList?
    @Published var mealWindowOpen = false
    @Published var selectedMeal = ""
    
    private var dailyReport: DailyReport

    
    init(context: ModelContext) {
        self.context = context
        
        dailyReport = DailyReportManager.getTodayReport(context: context)
        
        //setup today's meal list
        setupTodayMealList()
    }

    // MARK: - Create or fetch today's meal list
    private func setupTodayMealList() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)
        
        print("INFO: Looking for meal list with dateString: \(todayString)")
        
        //fetch existing mealList for today
        let fetchDescriptor = FetchDescriptor<MealList>(
            predicate: #Predicate<MealList> { $0.dateString == todayString }
        )
        
        if let existing = try? context.fetch(fetchDescriptor).first {
            self.todayMealList = existing
            print("SUCCESS: Found existing meal list for today")
        } else {
            print("INFO: Creating new meal list for today")
            // Create default meals for today
            let defaultMeals = [
                Meal(name: "Breakfast"),
                Meal(name: "Lunch"),
                Meal(name: "Dinner"),
                Meal(name: "Snacks")
            ]
            
            let newMealList = MealList(date: today, meals: defaultMeals)
            context.insert(newMealList)
            
            do {
                try context.save()
                self.todayMealList = newMealList
                print("SUCCESS: Successfully created and saved new meal list")
            } catch {
                print("ERR: Failed to save MealList: \(error)")
            }
        }
    }
    
    // MARK: - Add food to a specific meal
    func addFood(to mealName: String, food: Food) {
        guard let mealList = todayMealList else { return }
        guard let meal = mealList.meals.first(where: { $0.name == mealName }) else { return }
        
        meal.foodItems.append(food)
        context.insert(food)
        
        dailyReport.calorieTotal += food.calories       //update adily report
            if let macros = food.macros {
                dailyReport.macrosTotal.carbs += macros.carbs
                dailyReport.macrosTotal.protein += macros.protein
                dailyReport.macrosTotal.fats += macros.fats
            }
        
        saveContext()
    }
    
    // MARK: - Remove food from a specific meal
    func removeFood(from mealName: String, food: Food) {
        guard let mealList = todayMealList else { return }
        guard let meal = mealList.meals.first(where: { $0.name == mealName }) else { return }
        
        meal.foodItems.removeAll { $0.id == food.id }
        context.delete(food)
        
        
        dailyReport.calorieTotal -= food.calories       //update daily report
            if let macros = food.macros {
                dailyReport.macrosTotal.carbs -= macros.carbs
                dailyReport.macrosTotal.protein -= macros.protein
                dailyReport.macrosTotal.fats -= macros.fats
            }
        
        saveContext()
    }
    
    // MARK: - Total calories for today
    func totalCalories() -> Int {
        guard let mealList = todayMealList else { return 0 }
        return mealList.meals.flatMap { $0.foodItems }.reduce(0) { $0 + $1.calories }
    }
    
    // MARK: - Total grams for today
    func totalGrams() -> Int {
        guard let mealList = todayMealList else { return 0 }
        return mealList.meals.flatMap { $0.foodItems }.reduce(0) { $0 + $1.grams }
    }
    
    // MARK: - Save context
    private func saveContext() {
        do {
            try context.save()
        } catch {
            print("ERR: Failed to save context: \(error)")
        }
    }
    
    // MARK: - Macro Totals
    func totalMacros() -> (carbs: Double, protein: Double, fats: Double) {
        guard let mealList = todayMealList else { return (0, 0, 0) }
        
        var totalCarbs: Double = 0
        var totalProtein: Double = 0
        var totalFats: Double = 0
        
        for food in mealList.meals.flatMap({ $0.foodItems }) {
            if let macros = food.macros {
                totalCarbs += macros.carbs
                totalProtein += macros.protein
                totalFats += macros.fats
            }
        }
        
        return (totalCarbs, totalProtein, totalFats)
    }
    
    // MARK: - Totals for a specific meal
    func totals(for mealName: String) -> (calories: Int, grams: Int) {
        guard let mealList = todayMealList else { return (0, 0) }
        guard let meal = mealList.meals.first(where: { $0.name == mealName }) else { return (0, 0) }
        
        let totalCalories = meal.foodItems.reduce(0) { $0 + $1.calories }
        let totalGrams = meal.foodItems.reduce(0) { $0 + $1.grams }
        
        return (totalCalories, totalGrams)
    }
        
        //MARK: - reset all data on logout
        func onLogout() {
            //fetch all MealList objects
            let fetchMealLists = FetchDescriptor<MealList>()
            do {
                let mealLists = try context.fetch(fetchMealLists)
                
                //aelete all MealLists
                for mealList in mealLists {
                    context.delete(mealList)
                }
                
                //delete Food objects
                let fetchFoods = FetchDescriptor<Food>()
                let foods = try context.fetch(fetchFoods)
                for food in foods {
                    context.delete(food)
                }
      
                try context.save()
                

                todayMealList = nil
                selectedMeal = ""
                mealWindowOpen = false
                dailyReport = DailyReport(
                    date: Date(),
                    calorieTotal: 0,
                    stepsTotal: 0,
                    waterTotal: 0,
                    distanceTotal: 0,
                    macrosTotal: Macro(carbs: 0, protein: 0, fats: 0),
                    taskCompletion: 0
                )
                
                print("SUCCESS: All meal data successfully deleted and ViewModel reset.")
                
            } catch {
                print("ERR: Failed to reset data: \(error)")
            }
        }

}
