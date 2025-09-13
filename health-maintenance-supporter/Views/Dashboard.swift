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
    
    @State private var animateRings = false
    @State private var location = "Colombo"
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.appPrimary.opacity(0.33), Color.appSecondary.opacity(0.20)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView(showsIndicators: false) {
                VStack(spacing: 8) {
                    
                    // Greeting & Date
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Welcome,")
                                .font(.title2)
                                .foregroundColor(Color.appSecondary)
                            Text("Sridesh")
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
                    
                    // Daily Summary Rings
                    GlassCard {
                        Text(userViewModel.goal?.goal ?? "")
                            .padding(.bottom)
                            .font(.title3)
                            .bold()
                            .foregroundColor(Color.appText)
                        
                        HStack(spacing: 28) {
                            RingStat(
                                title: "Calories",
                                value: 1214,
                                goal: Double(userViewModel.goal?.dailyTargets.calories ?? 0),
                                color: .orange,
                                icon: "flame.fill",
                                progress: animateRings ? 0.61 : 0
                            )
                            RingStat(
                                title: "Steps",
                                value: 8900,
                                goal: Double(userViewModel.goal?.dailyTargets.steps ?? 0),
                                color: .green,
                                icon: "figure.walk",
                                progress: animateRings ? 0.74 : 0
                            )
                            RingStat(
                                title: "Water",
                                value: goalViewModel.waterIntake,
                                goal: Double(userViewModel.goal?.dailyTargets.water ?? 0),
                                color: .blue,
                                icon: "drop.fill",
                                progress: animateRings ? CGFloat(goalViewModel.waterIntake / (Double(userViewModel.goal?.dailyTargets.water ?? 1))) : 0
                            )
                        }
                        .onAppear { animateRings = true }
                    }.padding(.top)

                     // Macros Section
                    GlassCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Macros Overview")
                                .font(.headline)
                                .foregroundColor(Color.appPrimary)
                            HStack(spacing: 18) {
                                MacroStat(name: "Protein", value: 73, goal: Double(userViewModel.goal?.dailyTargets.macros.protein ?? 0), color: .green)
                                MacroStat(name: "Carbs", value: 58, goal: Double(userViewModel.goal?.dailyTargets.macros.carbs ?? 0), color: .orange)
                                MacroStat(name: "Fat", value: 79, goal: Double(userViewModel.goal?.dailyTargets.macros.fats ?? 0), color: .red)
                                MacroStat(name: "Fiber", value: 15, goal: 30, color: .purple)
                            }
                        }
                    }
                    
                    // Meals Section
                    GlassCard {
                        HStack {
                            Text("Today's Meals")
                                .font(.headline)
                                .foregroundColor(Color.appPrimary)
                            Spacer()
                            Button {
                                mealViewModel.mealWindowOpen = true
                            } label: {
                                Image(systemName: "plus.circle.fill")
                                    .font(.title2)
                                    .foregroundColor(Color.appBlue)
                            }
                        }
                        .padding(.bottom, 8)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 18) {
                                ForEach(mealsList) { meal in
                                    MealCard(title: meal.title, icon: meal.image)
                                }
                            }
                        }
                    }
                    
                   
                    
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 18)
            }
        }
        .sheet(isPresented: $mealViewModel.mealWindowOpen) {
            VStack {
                Mealiew().environmentObject(mealViewModel)
            }
        }
    }
}


// MARK: - RingStat
struct RingStat: View {
    let title: String
    let value: Double
    let goal: Double
    let color: Color
    let icon: String
    let progress: CGFloat
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .stroke(Color.appBlue.opacity(0.12), lineWidth: 10)
                Circle()
                    .trim(from: 0, to: progress)
                    .stroke(
                        LinearGradient(colors: [Color.appSecondary, Color.appPrimary], startPoint: .top, endPoint: .bottomTrailing),
                        style: StrokeStyle(lineWidth: 10, lineCap: .round)
                    )
                    .rotationEffect(.degrees(-90))
                    .animation(.easeOut(duration: 1.2), value: progress)
                Image(systemName: icon)
                    .foregroundColor(Color.appPrimary)
                    .font(.title2)
            }
            .frame(width: 70, height: 70)
            
            Text(title)
                .font(.caption)
                .foregroundColor(Color.appSecondary)
            Text(title == "Water" ? String(format: "%.1fL", value) : "\(Int(value))")
                .foregroundColor(Color.appText)
                .font(.headline)
                .bold()
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .foregroundColor(Color.appSecondary)
        }
        .frame(width: 90)
    }
}

// MARK: - MealCard
struct MealCard: View {
    let title: String
    let icon: String
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 16)
                    .fill(LinearGradient(colors: [Color.appSecondary.opacity(0.12), Color.appBlue.opacity(0.10)], startPoint: .top, endPoint: .bottomTrailing))
                    .frame(width: 70, height: 70)
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 38, height: 38)
            }
            
            Text(title)
                .font(.caption)
                .foregroundColor(.primary)
        }
        .frame(width: 80)
    }
}



#Preview {
    let mockContainer = try! ModelContainer(for: Meal.self) // only Meal needed for this view
    let mockViewModel = MealsViewModel(context: mockContainer.mainContext)
    
    return DashboardView()
        .environmentObject(mockViewModel)
}

