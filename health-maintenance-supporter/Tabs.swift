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
//            Color.red.ignoresSafeArea()
            
            TabView {
                
                DashboardView().environmentObject(mealViewModel).tabItem{Label("Home", systemImage:"house")}
//                
//                AddMeal().environmentObject(foodItemViewModel).tabItem{
//                    Label("Add Meal", systemImage: "camera")
//                }
                InsightsView().tabItem{
                    Label("Insights", systemImage: "chart.bar.horizontal.page")
                }
                
                HealthView()
                    .tabItem{
                        Label("Activity", systemImage: "figure.walk")
                    }
                
                
//                ClassificationWithVisionView()
                ProfileView()
//                    .environmentObject(authentication)
                    .environmentObject(foodItemViewModel)
                    .tabItem {
                        Label("Profile", systemImage: "person.circle")
                    }
                
                
              
            }.background(Color.white)
        }
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let r, g, b: UInt64
        switch hex.count {
        case 6: // RGB (24-bit)
            (r, g, b) = ((int >> 16) & 0xFF, (int >> 8) & 0xFF, int & 0xFF)
        default:
            (r, g, b) = (1, 1, 1)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: 1
        )
    }
}

//#Preview {
//    TabsView()
//}
//
