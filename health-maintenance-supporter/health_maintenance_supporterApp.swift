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
        
        let container: ModelContainer

    init() {
        let modelContainer = try! ModelContainer(for: User.self, Meal.self, FoodItem.self)
        self.container = modelContainer
        
        _authViewModel = StateObject(wrappedValue: AuthenticationViewModel(context: modelContainer.mainContext))
        _mealViewModel = StateObject(wrappedValue: MealsViewModel(context: modelContainer.mainContext))
        _foodItemViewModel = StateObject(wrappedValue: FoodItemViewModel(context: modelContainer.mainContext))
        _userViewModel = StateObject(wrappedValue: UserViewModel())  // <-- fixed
        
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            VStack{
                if authViewModel.userSessionLogged {
                    if authViewModel.isAuthenticated {
                        TabsView()
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
                } else {
                    SignInView()
                        .environmentObject(authViewModel)
                }
                
                    
            }.onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if user != nil {
                        userViewModel.fetchUser(email: user?.email ?? "")
                        authViewModel.userSessionLogged.toggle()
                    }
                }
            }
        }
        
        //            switch authViewModel.flowState {
        //                case .onboarding:
        //                    SignUp()
        //                        .environmentObject(authViewModel)
        //                case .login:
        //                    FaceIDCollectionView()
        //                        .environmentObject(authViewModel)
        //                        .onAppear {
        //                            authViewModel.authenticateWithBiometrics()
        //                        }
        //                case .userDataEntry:
        //                    AdditionalDetails()
        //                        .environmentObject(authViewModel)
        //                case .mainApp:
        //                    TabsView()
        //                        .environmentObject(authViewModel)
        //                        .environmentObject(mealViewModel)
        //                        .environmentObject(foodItemViewModel)
        //            }
    }
}
