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
    
    @State private var selectedTab = 0
    var body: some View {
        
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.appPrimary.opacity(0.5), Color.appSecondary.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            TabView {
                DashboardView()
                    .environmentObject(mealViewModel)
                    .tabItem{Label("Home", systemImage:"house")}

                InsightsView()
                    .tabItem{Label("Insights", systemImage: "chart.bar.horizontal.page")}
                
                HealthView()
                    .tabItem{Label("Activity", systemImage: "figure.walk")}
                
//                SignupView()
                ProfileView()
                    .environmentObject(authentication)
                    .environmentObject(foodItemViewModel)
                    .tabItem {Label("Profile", systemImage: "person.circle")}
                
            }.background(Color.white)
        }
    }
}



