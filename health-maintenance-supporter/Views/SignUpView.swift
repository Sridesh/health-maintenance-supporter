//
//  SignUpView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//

//
//  LoginView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//


import SwiftUI

struct SignupView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showAlert = false
    @State private var agreed = false
    
    @EnvironmentObject var authViewModel : AuthenticationViewModel
//    @EnvironmentObject var authViewModel: AuthenticationViewModelMock

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.appBackgound, Color.appSecondary.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 10) {
                    
                    // App Logo
                    Image( "fitzy")
                        .resizable()
                        .scaledToFit()
                        .frame(width:150, height: 150)
                    
                    // Glassmorphism Card
                    VStack(spacing: 20) {
                        Text("Welcome")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color.appPrimary)
                        
                        Text("Your journey to a better healthier & a happier life begins here")
                            .bold()
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                            .foregroundColor(Color.appSecondary)
                        
                        // Email Field
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                            .foregroundColor(.white)
                            .accessibilityLabel("emailTF")
                        
                        // Password Field
                        HStack {
                            if isSecure {
                                SecureField("Password", text: $password)
                                    .accessibilityLabel("passwordTF")
                            } else {
                                TextField("Password", text: $password)
                            }
                            Button(action: { isSecure.toggle() }) {
                                Image(systemName: isSecure ? "eye.slash" : "eye")
                                    .foregroundColor(.white.opacity(0.7))
                            }
                        }
                        .padding()
                        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                        .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                        .foregroundColor(.white)
                        
                        VStack(alignment: .leading, spacing: 10) {
                            
                            Toggle(isOn: $agreed) {
                                Text("I agree to the Terms & Conditions")
                                    .font(.subheadline)
                                    .foregroundColor(Color.appSecondary)
                            }
                            .toggleStyle(CheckboxToggleStyle())
                            .accessibilityLabel("toggleBTN")
                            
                        }
                        .padding()
                        
                        // Login Button
                        Button(action: {
                            authViewModel.register(email: email, password: password)
                            showAlert = true
                        }) {
                            Text("Sign Up")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [Color.appPrimary, Color.appPrimary], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(radius: 8, y: 4)
                        }
                        .alert(isPresented: $showAlert) {
                            Alert(title: Text("Login"), message: Text("Login tapped!"), dismissButton: .default(Text("OK")))
                        }
                        .accessibilityLabel("signupBTN")
                        
                        
                        
                    }
                    .padding(30)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 30, y: 10)
                    
                    
                    
                    
                    
                    Spacer()
                    // Sign Up Link
                    HStack {
                        Text("Already have an account?")
                            .foregroundColor(Color.appText.opacity(0.7))
                        NavigationLink(destination: SignInView().environmentObject(authViewModel)) {
                            Text("Sign In")
                                .fontWeight(.bold)
                        }
                        .foregroundColor(Color.appText.opacity(0.7))
                    }
                    .font(.footnote)
                    .padding(.bottom, 24)
                }
                .padding(.horizontal, 24)
            }
        }
    }
}

struct CheckboxToggleStyle: ToggleStyle {
    func makeBody(configuration: Configuration) -> some View {
        Button(action: { configuration.isOn.toggle() }) {
            HStack {
                Image(systemName: configuration.isOn ? "checkmark.square.fill" : "square")
                    .foregroundColor(configuration.isOn ? .blue : .gray)
                configuration.label
            }
        }
        .buttonStyle(.plain)
    }
}



