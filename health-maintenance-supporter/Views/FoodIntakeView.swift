//
//  FoodIntake.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-14.
//

import SwiftUI
import SwiftData

struct FoodIntakeView: View {

    @EnvironmentObject var mealViewModel: MealsViewModel
    @EnvironmentObject var foodItemViewModel: FoodItemViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var goalsViewModel: GoalsViewModel
    
    @State private var openSheet = false   

    var body: some View {
        VStack(spacing: 20){
            Text("Your Intakes Today")
                .font(.title3)
                .bold()
                .foregroundColor(.appPrimary)
                    
            ScrollView{
                VStack{
                    if let mealList = mealViewModel.todayMealList {
                        WaterIntake()
                            .environmentObject(userViewModel)
                            .environmentObject(goalsViewModel)

                        mealCards(meals: mealList.meals)
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private func mealCards(meals: [Meal]) -> some View {
        ForEach(meals, id: \.id) { meal in
            GlassCard {
                Accordion(title: meal.name, image: meal.name.lowercased()) {
                    if meal.foodItems.isEmpty {
                        Text("No foods added yet").foregroundColor(.appSecondary)
                    } else {
                        foodItemsView(items: meal.foodItems, meal: meal.name)
                    }
                }
                
                Button("Add a food item"){
                    foodItemViewModel.selectedMeal = meal.name
                    openSheet = true
                }
                .padding(7)
                .font(.headline)
                .foregroundColor(Color.appWhiteText)
                .background(Color.appSecondary)
                .cornerRadius(10)
            }
        }
        .sheet(isPresented: $openSheet) {
            AddMeal()
                .environmentObject(foodItemViewModel)
        }
    }
    
    @ViewBuilder
    private func foodItemsView(items: [Food], meal: String) -> some View {
        VStack(spacing: 10){
            ForEach(items, id: \.id) { foodItem in
                VStack{
                    HStack{
                        FoodIntake(
                            name: foodItem.name,
                            grams: foodItem.grams,
                            calories: foodItem.calories
                        )
                        Button("", systemImage: "minus.circle", role: .destructive) {
                            mealViewModel.removeFood(from: meal, food: foodItem)
                        }
                    }
                    Divider()
                }
            }
        }
    }
}



