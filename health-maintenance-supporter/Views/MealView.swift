///
//  MealView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI

struct Mealiew:View {
    @EnvironmentObject var meal: MealsViewModel
//    @EnvironmentObject var meal: MealsViewModelMock
        
        var totalCalories: Int {
            meal.totalCalories()
        }
        
        var body: some View {
            VStack(spacing: 20) {
                
                // MARK: - Meal Header
                HStack {
                    Text(meal.selectedMeal)
                        .font(.title2.bold())
         
                    
                    Spacer()
                    
                    Button {
                        // Add item action
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.orange)
                    }
                }
                .padding(.horizontal)
//                
                // MARK: - Calorie Summary
                HStack(spacing: 10) {
                    Text("Total: \(totalCalories) kcal")
                        .font(.headline)

                    
                    Spacer()
                    
                    Text(totalCalories > 1000 ? "High" : "Normal")
                        .font(.subheadline.bold())
                        .foregroundColor(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(totalCalories > 1000 ? Color.orange : Color.green)
                        .cornerRadius(12)
                }
                .padding(.horizontal)
                
            }
            .padding(.top)
            .background(Color.appSecondary.opacity(0.2))
            .edgesIgnoringSafeArea(.bottom)
        }
}

