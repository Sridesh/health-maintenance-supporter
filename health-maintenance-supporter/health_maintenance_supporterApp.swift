//
//  health_maintenance_supporterApp.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import SwiftData

@main
struct health_maintenance_supporterApp: App {
    @StateObject private var authViewModel: AuthenticationViewModel
    @StateObject private var mealViewModel: MealsViewModel
    @StateObject private var foodItemViewModel: FoodItemViewModel
    
    let container: ModelContainer

    init() {
        let modelContainer = try! ModelContainer(for: User.self, Meal.self, FoodItem.self)
        self.container = modelContainer

        _authViewModel = StateObject(wrappedValue: AuthenticationViewModel(context: modelContainer.mainContext))
        _mealViewModel = StateObject(wrappedValue: MealsViewModel(context: modelContainer.mainContext))
        _foodItemViewModel = StateObject(wrappedValue: FoodItemViewModel(context: modelContainer.mainContext))
    }
    
    var body: some Scene {
        WindowGroup {
            switch authViewModel.flowState {
                case .onboarding:
                    SignUp()
                        .environmentObject(authViewModel)
                case .login:
                    FaceIDCollectionView()
                        .environmentObject(authViewModel)
                        .onAppear {
                            authViewModel.authenticateWithBiometrics()
                        }
                case .userDataEntry:
                    AdditionalDetails()
                        .environmentObject(authViewModel)
                case .mainApp:
                    TabsView()
                        .environmentObject(authViewModel)
                        .environmentObject(mealViewModel)
                        .environmentObject(foodItemViewModel)
            }
        }
    }
}
