//
//  AuthenticatioViewModelMock.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-19.
//

import Foundation
import SwiftUI

final class AuthenticationViewModelMock: ObservableObject {
    @Published var loginError: Bool = false
    @Published var userSessionLogged: Bool = false
    @Published var isAuthenticated: Bool = false
    @Published var authenticateCalled = false
    
    func login(email: String, password: String) {
        loginError = true
        userSessionLogged = false
        isAuthenticated = false
    }
    
    func register(email: String, password: String) {
        userSessionLogged = true
        isAuthenticated = true
    }
    
    func authenticateWithBiometrics() {
           authenticateCalled = true
       }
}
