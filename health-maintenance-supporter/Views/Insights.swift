//
//  Insights.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import Charts

struct NutritionCount {
    var category: String
    var count: Int
}



struct InsightsView: View {
    @EnvironmentObject var goalViewModel: GoalsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var mealViewModel: MealsViewModel
    
    @State var isAddIntakeOpen = false
    @State var customValue = ""
    @State private var animateProgress = false
    
    private var byCategory: [NutritionCount] {
        let macros = mealViewModel.totalMacros()
        return [
            .init(category: "Fat", count: Int(macros.fats)),
            .init(category: "Protein", count: Int(macros.protein)),
            .init(category: "Carbs", count: Int(macros.carbs))
            // .init(category: "Fiber", count: 15),
        ]
    }
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [Color.appBackgound, Color.appSecondary.opacity(0.20)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            // MARK: - View content
                VStack(spacing: 20) {
                    HStack{
                        
                        VStack{
                            Text("Insight Tracker")
                                .font(.title2)
                                .foregroundColor(Color.appSecondary)
                                .bold()
                                .padding(.top)
                                .padding(.horizontal, 30)
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    ScrollView{
                    
                    VStack{
                        HStack{
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [Color.appPrimary, Color.appSecondary], startPoint: .top, endPoint: .bottomTrailing))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                
                            }
                            VStack{
                                Text("Nutritions - Today")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.headline)
                                Text("Today’s macros")
                                    .bold()
                                    .font(.caption)
                                    .foregroundStyle(Color.appSecondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        GlassCard {
                            VStack{
                                PieChart(data: byCategory)
                            }.frame(width: 250)
                        }
                    }
                        
                        Divider().padding(.vertical)
                        
                    VStack{
                        HStack{
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [Color.appPrimary, Color.appSecondary], startPoint: .top, endPoint: .bottomTrailing))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                
                            }
                            VStack{
                                Text("Past Week")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.headline)
                                Text("Your Progress in the past week")
                                    .bold()
                                    .font(.caption)
                                    .foregroundStyle(Color.appSecondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        LastWeekInsights()
                            .environmentObject(userViewModel)
                    }
                }
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
            }
        }
    }
}
