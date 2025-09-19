//
//  MealItem.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-19.
//

import SwiftUI

struct MealCard: View {
    let title: String
    let icon: String
    let grams: Int
    let calories: Int
    
    @EnvironmentObject var foodItemViewModel: FoodItemViewModel
    
    @State var openSheet = false
    
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
            
            VStack{
                Text(title)
                    .font(.caption)
                    .foregroundColor(.primary)
                Text("\(calories) cal")
                    .font(.caption)
                    .foregroundColor(.appSecondary)
                Text("\(grams)g")
                    .font(.caption)
                    .foregroundColor(.appSecondary)
            }
        }
        .sheet(isPresented: $openSheet) {
            AddMeal().environmentObject(foodItemViewModel)
        }
        .onTapGesture {
            openSheet = true
            foodItemViewModel.selectedMeal = title
        }
        .frame(width: 80)
    }
}
