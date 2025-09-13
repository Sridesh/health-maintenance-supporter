//
//  UserViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI
import Firebase

struct UserType {
    var email: String
    var isMale: Bool
    var age: Int
    var weight: Double
    var height: Double
    var goalId: Int?
}

@MainActor
final class UserViewModel: ObservableObject {
    @Published var currentUser = UserType(email: "", isMale: false, age: 0, weight: 0, height: 0, goalId: nil)
    @Published var userOnboarded = false
    @Published var openModal = false
    @Published var goal : FitnessPlan?
    
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
                email: data["email"] as? String ?? "",
                isMale: data["isMale"] as? Bool ?? false,
                age: data["age"] as? Int ?? 0,
                weight: data["weight"] as? Double ?? 0.0,
                height: data["height"] as? Double ?? 0.0,
                goalId: data["goalId"] as? Int
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
                "email": user.email,
                "isMale": user.isMale,
                "age": user.age,
                "weight": user.weight,
                "height": user.height,
                "goalId": user.goalId ?? NSNull()
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
                            self.userOnboarded = true
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
                            self.userOnboarded = true
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
}

