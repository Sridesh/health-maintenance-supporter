//
//  Dashboard.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import SwiftData


struct MealType : Identifiable{
    let id : Int
    let title : String
    let image : String
}

let mealsList: [MealType] = [
    MealType(id:1, title: "Breakfast", image:"breakfast"),
    MealType(id:2, title: "Lunch", image:"lunch"),
    MealType(id:3, title: "Dinner", image:"dinner"),
    MealType(id:4, title: "Snacks", image:"snack"),
]

struct DashboardView: View {
    @EnvironmentObject var mealViewModel: MealsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var goalViewModel: GoalsViewModel
    @EnvironmentObject var activityViewModel: ActivityViewModel
    @EnvironmentObject var foodItemViewModel: FoodItemViewModel
    
    @State private var animateRings = false

    @StateObject private var healthStore = HealthStore()
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.appBackgound, Color.appSecondary.opacity(0.20)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    
                    //MARK: -  Greeting & Date
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome,")
                                .font(.title2)
                                .foregroundColor(Color.appSecondary)
                            Text(userViewModel.currentUser.name.capitalized)
                                .font(.largeTitle.bold())
                                .foregroundColor(Color.appPrimary)
                            Text(Date(), style: .date)
                                .font(.subheadline)
                                .foregroundColor(Color.appSecondary)
                        }
                        Spacer()
                        Image("fitzy-pic")
                            .resizable()
                            .frame(width: 70, height: 70)
                        
                    }
                    .padding(.horizontal, 4)
                    
                    
                    //MARK: - semmary data
                    DailyRings(animateRings: animateRings)
                        .environmentObject(goalViewModel)
                        .environmentObject(userViewModel)
                        .environmentObject(mealViewModel)
                        .environmentObject(activityViewModel)
                

                     //MARK: -  Macros Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Macros Overview")
                                .font(.headline)
                                .foregroundColor(Color.appPrimary)
                            HStack(spacing: 18) {
                                MacroStat(name: "Protein", value: mealViewModel.totalMacros().protein, goal: Double(userViewModel.goal?.dailyTargets.macros.protein ?? 1), color: .green)
                                MacroStat(name: "Carbs", value: mealViewModel.totalMacros().carbs, goal: Double(userViewModel.goal?.dailyTargets.macros.carbs ?? 1), color: .orange)
                                MacroStat(name: "Fat", value: mealViewModel.totalMacros().fats, goal: Double(userViewModel.goal?.dailyTargets.macros.fats ?? 1), color: .red)
                            }
                        }.frame(maxWidth: .infinity)
                    }
                    
                    //MARK: -  Meals Section
                    GlassCard {
                        HStack {
                            Text("Today's Meals")
                                .font(.headline)
                                .foregroundColor(Color.appPrimary)
                            Spacer()
                          
                        }
                        .padding(.bottom, 8)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(mealsList) { meal in
                                    
                                    MealCard(
                                        title: meal.title,
                                        icon: meal.image,
                                        grams: mealViewModel.totals(for: meal.title).grams,
                                        calories: mealViewModel.totals(for: meal.title).calories
//                                        openSheet: $openSheet
                                    ).environmentObject(foodItemViewModel)
                                }
                            }
                        }
                    }
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 18)
            }.frame(height: 700)
        }
        .sheet(isPresented: $mealViewModel.mealWindowOpen) {
            VStack {
                Mealiew().environmentObject(mealViewModel)
            }
        }
        .onAppear{
            Task { @MainActor in
                            activityViewModel.updateTodayActivity(
                                steps: Int(healthStore.steps),
                                distance: healthStore.distance,
                                burn: Int(healthStore.activeCalories + healthStore.basalCalories)
                            )
                        }
        }
    }
}

