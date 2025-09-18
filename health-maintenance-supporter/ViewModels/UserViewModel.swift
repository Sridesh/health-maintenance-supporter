//
//  UserViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI
import Firebase

struct UserType {
    var name: String
    var email: String
    var isMale: Bool
    var age: Int
    var weight: Double
    var height: Double
    var goalId: Int?
    var onboarded: Bool
}

@MainActor
final class UserViewModel: ObservableObject {
    @Published var currentUser = UserType(name:"", email: "", isMale: false, age: 0, weight: 0, height: 0, goalId: nil, onboarded: false)
    @Published var userOnboarded = false
    @Published var openModal = false
    @Published var goal : FitnessPlan?
    @Published var userName = ""
    
    private let db = Firestore.firestore()
    
    // MARK: - Fetch user by email
    func fetchUser(email: String) {
        db.collection("Users").whereField("email", isEqualTo: email).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No user found with email \(email)")
                DispatchQueue.main.async { self.userOnboarded = false }
                return
            }
            
            let data = document.data()
            print("DEBUG: Firestore data = \(data)")
            
            let user = UserType(
                name: data["name"] as? String ?? "",
                email: data["email"] as? String ?? "",
                isMale: data["isMale"] as? Bool ?? false,
                age: data["age"] as? Int ?? 0,
                weight: data["weight"] as? Double ?? 0.0,
                height: data["height"] as? Double ?? 0.0,
                goalId: data["goalId"] as? Int,
                onboarded: data["onboarded"] as? Bool ?? true
            )
            
            print("DEBUG: Final user.goalId = \(user.goalId ?? -1)")
            
            DispatchQueue.main.async {
                self.currentUser = user
                self.userOnboarded = true
                
                // Set the goal after updating currentUser
                if let goalId = user.goalId {
                    if let selectedPlan = fitnessPlans.first(where: { $0.id == goalId }) {
                        print("Selected Plan: \(selectedPlan.goal)")
                        self.goal = selectedPlan
                    }
                }
            }
        }
    }
    
    // MARK: - Set email
    func setMail(email: String) {
        self.currentUser.email = email
    }
    
    // MARK: - get BMI
    func getBMI() -> Double {
        let heightInMeters = Double(currentUser.height) / 100.0
        return currentUser.weight / (heightInMeters * heightInMeters)
    }

    
    // MARK: - Create or update user
    func setUser(user: UserType) {
        let usersRef = db.collection("Users")
        
        usersRef.whereField("email", isEqualTo: user.email).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error querying user: \(error.localizedDescription)")
                return
            }
            
            print("DEBUG: setMail -> \(self.currentUser)")
            
            let data: [String: Any] = [
                "name": user.name,
                "email": user.email,
                "isMale": user.isMale,
                "age": user.age,
                "weight": user.weight,
                "height": user.height,
                "goalId": currentUser.goalId ?? 1,
                "onboarded" : false
                ]
            
            if let document = snapshot?.documents.first {
                // Update existing user
                usersRef.document(document.documentID).setData(data, merge: true) { error in
                    if let error = error {
                        print("Error updating user: \(error.localizedDescription)")
                    } else {
                        print("User updated successfully")
                        DispatchQueue.main.async {
                            self.currentUser = user
                            self.userOnboarded = false
                        }
                    }
                }
            } else {
                // Create new user
                usersRef.addDocument(data: data) { error in
                    if let error = error {
                        print("Error creating user: \(error.localizedDescription)")
                    } else {
                        print("User created successfully")
                        DispatchQueue.main.async {
                            self.currentUser = user
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Update only certain fields
    func updateUser(email: String, newData: [String: Any]) {
        let usersRef = db.collection("Users")
        
        usersRef.whereField("email", isEqualTo: email).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error finding user: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No user found with email \(email)")
                return
            }
            
            usersRef.document(document.documentID).updateData(newData) { error in
                if let error = error {
                    print("Error updating user: \(error.localizedDescription)")
                } else {
                    print("User updated successfully")
                    
                    DispatchQueue.main.async {
                        if self.currentUser.email == email {
                            var updated = self.currentUser
                            
                            if let isMale = newData["isMale"] as? Bool { updated.isMale = isMale }
                            if let age = newData["age"] as? Int { updated.age = age }
                            if let weight = newData["weight"] as? Double { updated.weight = weight }
                            if let height = newData["height"] as? Double { updated.height = height }
                            if let goalIdString = newData["goalId"] as? String { updated.goalId = Int(goalIdString) }
                            
                            self.currentUser = updated
                        }
                    }
                }
            }
        }
    }
    
//    func updateUserGoal(goalId: Int) {
//        let email = self.currentUser.email
//        let userRef = self.db.collection("Users").document(email)
//
//        userRef.updateData([
//            "goalId": goalId
//        ]) { error in
//            if let error = error {
//                print("Error updating goalId: \(error)")
//            } else {
//                DispatchQueue.main.async {
//                    self.currentUser.goalId = goalId
//                    print("goalId updated successfully in Firestor")
//                }
//            }
//        }
//    }
    
    func updateUserGoal(goalId: Int) {
        let email = self.currentUser.email
        let usersRef = db.collection("Users")
        
        // Query to find the document with the matching email (same pattern as your other methods)
        usersRef.whereField("email", isEqualTo: email).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error finding user: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No user found with email \(email)")
                return
            }
            
            // Update the found document using its document ID
            usersRef.document(document.documentID).updateData([
                "goalId": goalId
            ]) { error in
                if let error = error {
                    print("Error updating goalId: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.currentUser.goalId = goalId
                        
                        // Also update the goal object to keep UI in sync
                        if let selectedPlan = fitnessPlans.first(where: { $0.id == goalId }) {
                            self.goal = selectedPlan
                        } else {
                            self.goal = fitnessPlans[2]
                        }
                        
                        print("goalId updated successfully in Firestore")
                    }
                }
            }
        }
    }
    
    func updateUserOnboarding() {
        let email = self.currentUser.email
        let usersRef = db.collection("Users")
        
        // Query to find the document with the matching email (same pattern as your other methods)
        usersRef.whereField("email", isEqualTo: email).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error finding user: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No user found with email \(email)")
                return
            }
            
            usersRef.document(document.documentID).updateData([
                "onboarded": true
            ]) { error in
                if let error = error {
                    print("Error updating goalId: \(error.localizedDescription)")
                } else {
                    DispatchQueue.main.async {
                        self.currentUser.onboarded = true
                        
                        print("onboarding updated successfully in Firestore")
                        self.userOnboarded = true
                    }
                }
            }
        }
    }
    
    //MARK: - Reset on ogout
    func onLogout() {
        // Reset all published properties
        currentUser = UserType(
            name: "",
            email: "",
            isMale: false,
            age: 0,
            weight: 0,
            height: 0,
            goalId: nil,
            onboarded: false
        )
        
        userOnboarded = false
        openModal = false
        goal = nil
        userName = ""
        
        print("UserViewModel: All user data reset.")
    }
    
}

