//
//  FirebaseService.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//

import FirebaseAuth

final class FirebaseService {
    
    func FBRegister(email:String, password:String) {
        Auth.auth().createUser(withEmail: email, password: password) { results, error in
            if error  != nil {
                print(error?.localizedDescription)
            }
        }
    }
    
    
    func FBLogin(email: String, password: String) async throws -> AuthDataResult {
        return try await Auth.auth().signIn(withEmail: email, password: password)
    }
    
    
    func FBLogout() {
        do {
            try Auth.auth().signOut()
            print("User signed out successfully.")
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError.localizedDescription)
        }
    }
}
