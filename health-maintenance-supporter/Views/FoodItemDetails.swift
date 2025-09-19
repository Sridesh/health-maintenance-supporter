//
//  FoodItemDetails.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-09.
//

import SwiftUI




struct FoodItemDetails: View {
    public var portionSize : Double
    @EnvironmentObject var foodItemViewModel : FoodItemViewModel
    @EnvironmentObject var mealViewModel : MealsViewModel
    
    @State private var quantity: Int = 100
    @State private var isAdded : Bool = false

    private var food: FruitMacro {
            getFruitMacro(by: foodItemViewModel.selectedFood) ?? fruitMacros[0]
        }

    private var adjustedCalories: Double {
        Double(food.calories) / 100.0 * Double(quantity)
    }

    
    var body: some View {
        NavigationView{
            VStack{
                Text(foodItemViewModel.selectedFood)
                    .font(.headline)
                    .padding(.bottom)
                
                Image(foodItemViewModel.selectedFood ?? "Meal")
                    .padding(.vertical)
                
                GlassCard{
                    HStack{
                        Text("Total Calories")
                        Spacer()
                        Text("\(Int(adjustedCalories))")
                            .bold()
                    }
                    .padding(.bottom)
                    
                    
                    HStack{
                        Text("Portionn Size (grams)")
                        Spacer()
                        TextField("Enter a number", value: $quantity, format: .number)
                            .keyboardType(.numberPad) // shows numeric keyboard on iOS
                            .padding()
                            .frame(width: 100)
                            .background(Color.white)
                            .cornerRadius(8)
                    }
                    .padding(.bottom)
                }
                
                
                GlassCard{
                    Text("Macronutrients")
                        .font(.headline)
                        .padding(.bottom)
                    
                    HStack{
                        Spacer()
                        CircularProgress(color: Color.blue, fullAmount: 100.0, amount: food.carbs, name: "Carbs")
                        Spacer()
                        CircularProgress(color: Color.green, fullAmount: 100.0, amount: food.fat, name: "Fats")
                        Spacer()
                        CircularProgress(color: Color.red, fullAmount: 100.0, amount: food.protein, name: "Protein")
                        Spacer()
                    }
                }
                
                GlassCard{
                
                        Text("Macronutrients")
                            .font(.headline)
                            .padding(.bottom)
                    
                    Text(food.description).foregroundColor(.appPrimary).frame(maxWidth: .infinity)
                        
                }
                
                Button("Add to meal") {
                    let scaledMacros = Macro(
                        carbs: food.carbs * Double(quantity) / 100.0,
                        protein: food.protein * Double(quantity) / 100.0,
                        fats: food.fat * Double(quantity) / 100.0
                    )

                    let newFood = Food(
                        name: food.name,
                        calories: Int(adjustedCalories),
                        grams: quantity,
                        macros: scaledMacros
                    )
                    
                    isAdded = true

                    mealViewModel.addFood(to: foodItemViewModel.selectedMeal, food: newFood)
                }
                .alert(isPresented: $isAdded) {
                    Alert(
                        title: Text("Success"),
                        message: Text("Item added successfully"),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.appPrimary)
                    .foregroundColor(.white)
                    .cornerRadius(20)
                    .padding()
                
                
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .padding(.horizontal, 30)
                .background(Color.appSecondary.opacity(0.2))
        }
    }
}

struct TotalCalories : View {
    let food: FruitMacro
    let quantity: Int
    var body: some View {
        HStack{
            Text("Total Calories")
            Spacer()
            Text("\(Int(Int(food.calories) * quantity))")
                .bold()
        }
        .padding(.bottom)
    }
}
