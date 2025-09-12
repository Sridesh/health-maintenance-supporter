//
//  FoodIntake.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI


struct FoodIntake:View {
    
    @EnvironmentObject var mealViewModel: MealsViewModel
    
    var title: String
    var icon: String
    
    var body: some View {
        
        
        
        var itemList = mealViewModel.getMealList(meal: title)
        
        var totalCalories = "0";
//        Int {
//            itemList.reduce(0) { $0 + $1.ckal }
//        }
        
        VStack{
            HStack{
                Image(icon).resizable().frame(width: 50, height: 50)
                VStack{
                    Text(title).bold().frame(maxWidth: .infinity, alignment: .leading)
                    Text("0 items taken").frame(maxWidth: .infinity, alignment: .leading).font(.caption)
                    Text("\(totalCalories)kcal").frame(maxWidth: .infinity, alignment: .leading).font(.caption)
                }.frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Button("View"){
                    mealViewModel.changeMeal(meal: title)
                    mealViewModel.mealWindowOpen = true
                }.padding(10).foregroundColor(Color(hex: "#ff724c")).cornerRadius(50).bold()
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(20)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
    }
}
//#Preview {
//    FoodIntake(title: "Breakfast", icon: "breakfast")
//}
