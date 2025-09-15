//
//  IntakeView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-14.
//

import SwiftUI
import SwiftData

struct AdditionsView: View {
    enum Tab: String, CaseIterable {
        case nutrition = "Food Intake"
        case activity = "Activity"
        case tasks = "Other Tasks"
    }
    
    @EnvironmentObject var userViewModel : UserViewModel
    @EnvironmentObject var mealViewModel : MealsViewModel
    @EnvironmentObject var goalViewModel : GoalsViewModel
    
    @State private var selectedTab: Tab = .nutrition
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.appPrimary.opacity(0.33), Color.appSecondary.opacity(0.20)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            VStack {
                // MARK: - Tab Picker
                Picker("Select Tab", selection: $selectedTab) {
                    ForEach(Tab.allCases, id: \.self) { tab in
                        Text(tab.rawValue).foregroundColor(.appPrimary).tag(tab)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                // MARK: - Content for selected tab
                Group {
                    switch selectedTab {
                    case .nutrition:
                        FoodIntakeView()
                    case .tasks:
                        DailyGoals()
                            .environmentObject(goalViewModel)
                            .environmentObject(userViewModel)
                    case .activity:
                        HealthView()
                            .environmentObject(userViewModel)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.appSecondary.opacity(0.10), Color.appBlue.opacity(0.20)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(16)
            }
            .padding()
        }
    }
}




