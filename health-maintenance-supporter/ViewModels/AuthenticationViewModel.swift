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
    
    @Published var error : String?
    @Published var user : User?
    @Published var flowState: AppFlowState = .onboarding
    
    @Published var userSessionLogged = false
    @Published var loginError = false
    @Published var isAuthenticated = false

    private let authService = AuthenticationSerice()
    private let firebaseService = FirebaseService()
    
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
    
//    //MARK: - face id checkå
//    func checkBiometricOnLaunch() {
//        //fetch user
//        let descriptor = FetchDescriptor<User>(predicate: #Predicate { $0.isBiometricsAllowed == true })
//        
//        if let user = try? context.fetch(descriptor).first {
//            self.authenticateWithBiometrics()
//        } else {
//            self.error = "ERR: No user with biometrics enabled"
//            self.isAuthenticated = false
//            self.updateFlowState()
//        }
//    }
//    
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
        authService.authenticateWithBiometrics { [weak self] success, error in      //faceID check
            guard let self = self else { return }
            
            if success {
                self.isAuthenticated = true     //successfully identified
            } else {
                self.error = error ?? "Authentication failed"
                self.isAuthenticated = false
                self.updateFlowState()
            }
        }
    }

    
    // MARK: - User profile creation on firebase
    func register(email: String, password: String) {
        firebaseService.FBRegister(email: email, password: password)
        print("SUCCESS: Resigtering in Firebase successful")
    }
    
    //MARK: - Logout from firebase
    func logout(email:String){
        firebaseService.FBLogout()
        self.userSessionLogged = false
    }
    
    //MARK: - Login to firebase
    @MainActor
    func login(email: String, password: String) async {
        do {
            let authResult = try await firebaseService.FBLogin(email: email, password: password)
            print("SUCCESS: Logged in: \(authResult.user.email ?? "unknown")")
            self.loginError = false
        } catch {
            print("ERR: Login failed: \(error.localizedDescription)")
            self.loginError = true
        }
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
    func addUserData(name: String, gender:String, age:Int, weight:Int, height:Int){
        if self.user != nil {
            self.user?.name = name
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
    
    
    //MARK: - reset on logout
    func onLogout() {
        firebaseService.FBLogout()
        

        if let currentUser = self.user {
            context.delete(currentUser)
            try? context.save()
            self.user = nil
        }

        self.isAuthenticated = false
        self.userSessionLogged = false
        self.loginError = false
        
        self.flowState = .onboarding
        
        print("AuthenticationViewModel: User logged out and state reset")
    }

}

    

