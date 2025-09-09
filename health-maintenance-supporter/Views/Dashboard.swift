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

struct DashboardView:View {
    @EnvironmentObject var mealViewModel: MealsViewModel
    
    @State private var isShowingSheet = true
    @State private var location = "Colombo"
    
    var body: some View {
        VStack{
            
            
            //top buttons
            HStack{
                Button("", systemImage: "chevron.left"){
                    var n = 0
                }
                
                Text("Today")
                
                Button("", systemImage: "chevron.right"){
                    
                }
            }.frame(maxWidth:.infinity, alignment: .center)
            
            //intake tracker
            VStack{
                HStack{
                    //Food intake indicator
                    VStack{
                        Text("Food Intake").foregroundColor(.gray).font(.system(size: 15))
                        Text("0").font(.system(size: 25)).bold()
                    }
                    .padding(.trailing,10)
                    
                    
                    //Daily progress indiator
                    ZStack {
                        Circle()
                            .stroke(Color(hex: "#fe724c").opacity(0.1), lineWidth: 10)
                        Circle()
                            .trim(from: 0, to: 0.2)
                            .stroke(Color(hex: "#fe724c"), style: StrokeStyle(lineWidth: 10, lineCap: .round))
                            .rotationEffect(.degrees(-90))
                        VStack {
                            Text("Cal. count")
                                .font(.caption)
                                .bold()
                            Text("1214")
                                .font(.system(size: 15))
                                .foregroundColor(Color(hex:"#3e3e3e"))
                                .bold()
                            Text("\(Int(0.2 * 100))%")
                                .font(.system(size: 10))
                                .foregroundColor(.gray)
                        }
                    }
                    .frame(width: 100, height: 100)
                    .padding(.trailing,10)
                    
                    //Caleroy burn indicator
                    VStack{
                        Text("Activity Burn").foregroundColor(.gray).font(.system(size: 15))
                        Text("0").font(.system(size: 25)).bold()
                    }
                }
                
                HStack{
                    VStack{
                        IntakeIndicator(name: "Fat", intake: 12, fullAmount: 200, color:Color.red).padding(.bottom)
                        IntakeIndicator(name: "Protein", intake: 12, fullAmount: 200, color:Color.green).padding(.bottom)
                        IntakeIndicator(name: "Sodium", intake: 12, fullAmount: 200, color:Color.yellow)
                    }.padding(.trailing)
                    
                    VStack{
                        IntakeIndicator(name: "Net Carbs", intake: 12, fullAmount: 200, color:Color.orange).padding(.bottom)
                        IntakeIndicator(name: "Fiber", intake: 12, fullAmount: 200, color:Color.cyan).padding(.bottom)
                        IntakeIndicator(name: "Sugar", intake: 12, fullAmount: 200,color:Color.accentColor)
                    }.padding(.leading)
                }.padding(.top, 30)
            }.padding(30).background(Color.white).cornerRadius(20).shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
            
            //meals
            VStack{
                Text("Food Intake").frame(maxWidth: .infinity, alignment: .leading).font(.title2)
                ScrollView{
                    VStack{
                        ForEach(mealsList) { meal in
                            FoodIntake(title: meal.title, icon: meal.image).environmentObject(mealViewModel)
                        }
                    }.padding(.leading, 10).padding(.trailing, 10)
                }
            }.padding()
            
            
        }.background(Color(hex: "#fff1ed")).frame(maxWidth:.infinity, alignment:.center).frame(maxHeight: .infinity, alignment: .top)
            .sheet(isPresented: $mealViewModel.mealWindowOpen) {
                VStack {
                    Mealiew().environmentObject(mealViewModel)
                }
            }
    }
}



#Preview {
    let container = try! ModelContainer(for: Meal.self, FoodItem.self)
    let context = container.mainContext
    let mealVM = MealsViewModel(context: context)
    
    DashboardView()
        .environmentObject(mealVM)
}
