//
//  BioMetricAuthenticationService.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-03.
//

import SwiftUI
import LocalAuthentication

final class AuthenticationSerice{
    func authenticateWithBiometrics(completion: @escaping(Bool,String?) -> Void){
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            
            var reason = "Authenticate to access your account"

                    context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                           localizedReason: reason) { success, authenticationError in
                        DispatchQueue.main.async {
                            if success {
                                completion(true, nil)
                            } else {
                                completion(false, authenticationError?.localizedDescription)
                            }
                        }
                    }
                } else {
                    completion(false, "Biometric authentication not available")
                }
        
        //        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
        //            context.evaluatePolicy(.deviceOwnerAuthentication,
        //                                   localizedReason: "Authenticate to continue") { success, authenticationError in
        //                DispatchQueue.main.async {
        //                    text = success ? "UNLOCKED" : "Authentication failed"
        //                }
        //            }
        //        } else {
        //            DispatchQueue.main.async {
        //                text = "Biometrics/Passcode not available"
        //            }
        //        }
    }
}
