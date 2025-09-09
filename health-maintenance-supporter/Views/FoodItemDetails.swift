//
//  FoodItemDetails.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-09.
//

import SwiftUI




struct FoodItemDetails: View {
    public var portionSize : Double
    @EnvironmentObject var foodItemModelView : FoodItemViewModel
    
    @State private var quantity: Int = 0
    
    
    var body: some View {
        NavigationView{
            VStack{
                Text(foodItemModelView.selectedFood)
                    .font(.headline)
                    .padding(.bottom)
                
                Image("Apple")
                    .padding(.vertical)
                
                
                HStack{
                    Text("Total Calories")
                    Spacer()
                    Text("43 Cal")
                        .bold()
                }
                .padding(.bottom)
                
                HStack{
                    Text("Portionn Size")
                    Spacer()
                    TextField("Enter a number", value: $quantity, format: .number)
                        .keyboardType(.numberPad) // shows numeric keyboard on iOS
                        .padding()
                        .frame(width: 100)
                        .background(Color.white)
                        .cornerRadius(8)
                }
                .padding(.bottom)
                
                
                VStack{
                    Text("Macronutrients")
                        .font(.headline)
                        .padding(.bottom)
                    
                    HStack{
                        Spacer()
                        CircularProgress(color: Color.blue, fullAmount: 100.0, amount: 50.0, name: "Carbs")
                        Spacer()
                        CircularProgress(color: Color.green, fullAmount: 100.0, amount: 10.0, name: "Carbs")
                        Spacer()
                        CircularProgress(color: Color.red, fullAmount: 100.0, amount: 80.0, name: "Carbs")
                        Spacer()
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.white.opacity(0.4))
                .cornerRadius(10)
                
                
                VStack{}
                padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.white.opacity(0.4))
                    .cornerRadius(10)
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 30)
                .background(Color(hex: "#fff1ed"))
        }
    }
}

#Preview {
    FoodItemDetails(portionSize: 100)
}
