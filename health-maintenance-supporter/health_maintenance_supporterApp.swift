//
//  health_maintenance_supporterApp.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth

@main
struct health_maintenance_supporterApp: App {
    @StateObject private var authViewModel: AuthenticationViewModel
        @StateObject private var mealViewModel: MealsViewModel
        @StateObject private var foodItemViewModel: FoodItemViewModel
        @StateObject private var userViewModel: UserViewModel
    @StateObject private var goalViewModel: GoalsViewModel
        
        let container: ModelContainer

    init() {
        let modelContainer = try! ModelContainer(for: User.self, Meal.self, FoodItem.self)
        self.container = modelContainer
        
        _authViewModel = StateObject(wrappedValue: AuthenticationViewModel(context: modelContainer.mainContext))
        _mealViewModel = StateObject(wrappedValue: MealsViewModel(context: modelContainer.mainContext))
        _foodItemViewModel = StateObject(wrappedValue: FoodItemViewModel(context: modelContainer.mainContext))
        _userViewModel = StateObject(wrappedValue: UserViewModel())
        _goalViewModel = StateObject(wrappedValue: GoalsViewModel())
        
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            VStack{
                if authViewModel.userSessionLogged && userViewModel.userOnboarded {
                    if authViewModel.isAuthenticated  {
                        TabsView()
                            .environmentObject(goalViewModel)
                            .environmentObject(userViewModel)
                            .environmentObject(authViewModel)
                            .environmentObject(mealViewModel)
                            .environmentObject(foodItemViewModel)
                    } else {
                        FaceIDCollectionView()
                            .environmentObject(authViewModel)
                            .onAppear {
                                authViewModel.authenticateWithBiometrics()
                            }
                    }
                } else if authViewModel.userSessionLogged && !userViewModel.userOnboarded {
                    AdditionalDetails()
                        .environmentObject(userViewModel)
                        .environmentObject(authViewModel)
                }
                else {
                    SignInView()
                        .environmentObject(authViewModel)
                }
                
                    
            }.onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if let email = user?.email {
                        userViewModel.setMail(email: email)
                        userViewModel.fetchUser(email: email)
                        authViewModel.userSessionLogged = true // Use = true, not toggle()
                    }
                }            }
        }
    }
}
