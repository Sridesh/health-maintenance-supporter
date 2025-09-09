//
//  BioMetricsLogin.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-03.
//

import SwiftUI
import LocalAuthentication

struct BioMetricsLogin: View {
    
    @EnvironmentObject var authentication : AuthenticationViewModel
    
    @State private var unlocked = false
    @State private var text = "Locked"
    
    var body: some View{
        VStack{
            Text(authentication.user?.password ?? "no user")
        }
    }
    
    func authenticate(){
        let context = LAContext()
        var error : NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "This is for security reasons"){
                success, authenticationError in
                
                if success{
                    text="UNLOCKED"
                }else {
                    text="There was a problem "
                }
            }
        } else {
            text = "Phone does not have Biometrics"
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

#Preview {
    BioMetricsLogin()
}
