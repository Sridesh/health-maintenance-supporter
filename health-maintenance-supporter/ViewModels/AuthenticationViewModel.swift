//
//  AuthenticationViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-03.
//

import SwiftUI
import SwiftData

enum AppFlowState {
    case onboarding
    case login
    case userDataEntry
    case mainApp
}

@MainActor
final class AuthenticationViewModel: ObservableObject {
    @Published var isAuthenticated = false
    @Published var error : String?
    @Published var user : User?
    @Published var flowState: AppFlowState = .onboarding

    private let authService = AuthenticationSerice()
    
    private var context: ModelContext
    
    init(context: ModelContext){
        self.context = context
        fetchUser()
    }
    
    //MARK: - control app;s flow state
    func updateFlowState() {
        if user == nil {
            flowState = .onboarding
        } else if !self.isAuthenticated {
            flowState = .login
        } else if self.isAuthenticated && user?.gender == "" {
            flowState = .userDataEntry
        } else {
            flowState = .mainApp
        }
    }
    
    //MARK: - face id checkå
    func checkBiometricOnLaunch() {
        // Fetch user with biometrics enabled
        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.isBiometricsAllowed == true })
        
        if let user = try? context.fetch(descriptor).first {
            self.authenticateWithBiometrics()
        } else {
            self.error = "No user with biometrics enabled"
            self.isAuthenticated = false
            self.updateFlowState()
        }
    }
    
    //MARK: - Fetched logged user
    func fetchUser(){
        let descriptor = FetchDescriptor<User>()
        
        if let activeUser = try? context.fetch(descriptor).first {
            user = activeUser
        }
        
        updateFlowState()
    }
    
    // MARK: - Login Biometric
    
    func authenticateWithBiometrics() {
        authService.authenticateWithBiometrics { [weak self] success, error in
            guard let self = self else { return }
            
            if success {
                // If user already exists in memory, trust it
                if self.user != nil {
                    self.isAuthenticated = true
                    self.updateFlowState()
                } else {
                    // Only fetch from context if user is nil
                    if let existingUser = try? self.context.fetch(
                        FetchDescriptor<User>(predicate: #Predicate { $0.isBiometricsAllowed == true })
                    ).first {
                        self.user = existingUser
                        self.isAuthenticated = true
                        self.updateFlowState()
                    } else {
                        self.error = "No user found with biometrics enabled"
                        self.isAuthenticated = false
                        self.updateFlowState()
                    }
                }
            } else {
                self.error = error ?? "Authentication failed"
                self.isAuthenticated = false
                self.updateFlowState()
            }
        }
    }

    
    // MARK: - User profile creation
    
    func register(email: String, password: String) {
            let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
            
        if let _ = try? context.fetch(descriptor).first {
                error = "User with this email already exists."
                return
            }
        
        let newUser = User(
                email: email,
                password: password,
                gender: "",
                height: 0,
                weight: 0,
                age: 0,
                isBiometricsAllowed: false
            )
        
        context.insert(newUser)
        try? context.save()

//        isAuthenticated = true
        user = newUser
        self.updateFlowState()
        
    }
    
    //MARK: - Logout
    
    func logout(email:String){
        isAuthenticated = false
        updateFlowState()
        
//        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.email == email })
//        
//        let user = try? context.fetch(descriptor).first
//        user?.isActive = false
//        
//        try? context.save()
        
        
    }
    
    //MARK: - delete current user profile
    func deleteProfile(){
        if self.user != nil {
            guard let currentUser = self.user else { return }
            context.delete(currentUser)
            try? context.save()
            self.user = nil
            self.isAuthenticated = false
        }
    }
    
    //MARK: - add user data
    func addUserData(gender:String, age:Int, weight:Int, height:Int){
        if self.user != nil {
            self.user?.gender = gender
            self.user?.age = age
            self.user?.weight = weight
            self.user?.height = height
            
            
            do {
                try context.save()
            } catch {
                self.error = "Failed to save user data: \(error.localizedDescription)"
            }
        }
        
        self.updateFlowState()
    }
    
    func saveUser(){
        try? context.save()
    }

}

    

