//
//  DailyRings.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-19.
//

import SwiftUI

struct DailyRings: View {
    @EnvironmentObject var mealViewModel: MealsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var goalViewModel: GoalsViewModel
    @EnvironmentObject var activityViewModel: ActivityViewModel
    
    @State var animateRings = false
    
    @StateObject private var healthStore = HealthStore()
    
    private var burn: Double {
        (healthStore.basalCalories + healthStore.activeCalories)
    }
    
    var body: some View {
        GlassCard {
            Text(userViewModel.goal?.goal ?? "")
                .padding(.bottom)
                .font(.title3)
                .bold()
           
            
            HStack(spacing: 28) {
                RingStat(
                    title: "Calories", //total calories for today
                    value: Double(max(Int(Double(mealViewModel.totalCalories()) - burn),0)),
                    goal: Double(userViewModel.goal?.dailyTargets.calories ?? 0),
                    color: .orange,
                    icon: "flame.fill",
                    progress: animateRings ? CGFloat(Double(mealViewModel.totalCalories())  /  (Double(userViewModel.goal?.dailyTargets.calories ?? 1))) : 0
                )
                .accessibilityLabel("Calorie intake")
                RingStat(
                    title: "Steps", // steps walked today
                    value: Double(healthStore.steps ?? 0),
                    goal: Double(userViewModel.goal?.dailyTargets.steps ?? 0),
                    color: .green,
                    icon: "figure.walk",
                    progress: animateRings ? CGFloat(Double(activityViewModel.todayActivity?.steps ?? 0)  /  (Double(userViewModel.goal?.dailyTargets.steps ?? 1))) : 0
                )
                .accessibilityLabel("Steps today")
                RingStat(
                    title: "Water", //water intake todayt
                    value: goalViewModel.waterIntake?.intake ?? 0,
                    goal: Double(userViewModel.goal?.dailyTargets.water ?? 0),
                    color: .blue,
                    icon: "drop.fill",
                    progress: animateRings ? CGFloat((goalViewModel.waterIntake?.intake ?? 0) / (Double(userViewModel.goal?.dailyTargets.water ?? 1))) : 0
                )
                .accessibilityLabel("Water intake")
            }
            .onAppear { animateRings = true
                
            }
        }
        .padding(.top)
    }
}


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
                .font(.headline)
                .bold()
            Text("\(Int(progress * 100))%")
                .font(.caption2)
                .foregroundColor(Color.appSecondary)
        }
        .frame(width: 90)
    }
}
