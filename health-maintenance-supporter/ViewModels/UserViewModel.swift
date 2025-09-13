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
}

@MainActor
final class UserViewModel: ObservableObject {
    @Published var currentUser : UserType?
    
    func fetchUser(email: String) {
        let db = Firestore.firestore()
        let usersRef = db.collection("Users")
        
        usersRef.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user: \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No user found with email \(email)")
                return
            }
            
            let data = document.data()
            
            if let email = data["email"] as? String,
               let isMale = data["isMale"] as? Bool,
               let age = data["age"] as? Int,
               let weight = data["weight"] as? Double,
               let height = data["height"] as? Double {
                
                DispatchQueue.main.async {
                    self.currentUser = UserType(email: email, isMale: isMale, age: age, weight: weight, height: height)
                }
            }
        }
    }
    
    func setUser(user: UserType) {
            let db = Firestore.firestore()
            let usersRef = db.collection("Users")
            
            usersRef.whereField("email", isEqualTo: user.email).getDocuments { snapshot, error in
                if let error = error {
                    print("Error querying user: \(error.localizedDescription)")
                    return
                }
                
                let data: [String: Any] = [
                    "email": user.email,
                    "isMale": user.isMale,
                    "age": user.age,
                    "weight": user.weight,
                    "height": user.height
                ]
                
                if let document = snapshot?.documents.first {

                    usersRef.document(document.documentID).updateData(data) { error in
                        if let error = error {
                            print("Error updating user: \(error.localizedDescription)")
                        } else {
                            print("User updated successfully")
                            DispatchQueue.main.async {
                                self.currentUser = user
                            }
                        }
                    }
                } else {
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
    
    
    func updateUser(email: String, newData: [String: Any]) {
            let db = Firestore.firestore()
            let usersRef = db.collection("Users")
            
            usersRef.whereField("email", isEqualTo: email).getDocuments { snapshot, error in
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
                            if var user = self.currentUser, user.email == email {
                                newData.forEach { key, value in
                                    switch key {
                                    case "isMale": user.isMale = value as? Bool ?? user.isMale
                                    case "age": user.age = value as? Int ?? user.age
                                    case "weight": user.weight = value as? Double ?? user.weight
                                    case "height": user.height = value as? Double ?? user.height
                                    default: break
                                    }
                                }
                                self.currentUser = user
                            }
                        }
                    }
                }
            }
        }
    
}
