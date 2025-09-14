//
//  FoodIntake.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI


struct FoodIntake:View {
    
    let name: String
    let grams : Int
    let calories: Int
    
    var body: some View {
        HStack(alignment: .bottom){
            VStack{
                Text(name).font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                Text("\(Int(grams))g").font(.caption).foregroundColor(.appSecondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            
            Text("\(calories) cal").font(.caption).foregroundColor(.appSecondary)
        }.padding(.horizontal)
            .frame(maxWidth: .infinity)
    }
}
#Preview {
    FoodIntake(name: "Apple", grams: 200, calories: 100)
}
