//
//  Tabs.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import SwiftData

struct TabsView: View {
    @EnvironmentObject var authentication : AuthenticationViewModel
    @EnvironmentObject var mealViewModel: MealsViewModel
    @EnvironmentObject var foodItemViewModel: FoodItemViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var goalViewModel: GoalsViewModel
    @EnvironmentObject var activityViewModel: ActivityViewModel
    
    @State private var selectedTab = 0
    var body: some View {
        
        
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.appBackgound, Color.appSecondary.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            TabView {
                DashboardView()
                    .environmentObject(goalViewModel)
                    .environmentObject(userViewModel)
                    .environmentObject(mealViewModel)
                    .environmentObject(activityViewModel)
                    .environmentObject(foodItemViewModel)
                    .tabItem{Label("Home", systemImage:"house")}
                
                AdditionsView()
                    .environmentObject(userViewModel)
                    .environmentObject(mealViewModel)
                    .tabItem{Label("Inputs", systemImage: "figure.walk")}

                InsightsView()
                    .environmentObject(goalViewModel)
                    .environmentObject(userViewModel)
                    .environmentObject(mealViewModel)
                    .environmentObject(goalViewModel)
                    .tabItem{Label("Insights", systemImage: "chart.bar.horizontal.page")}

                ProfileView()
                    .environmentObject(authentication)
                    .environmentObject(goalViewModel)
                    .environmentObject(userViewModel)
                    .environmentObject(mealViewModel)
                    .environmentObject(activityViewModel)
                    .environmentObject(foodItemViewModel)
                    .tabItem {Label("Profile", systemImage: "person.circle")}
                
            }.background(Color.white)
        }
    }
}



