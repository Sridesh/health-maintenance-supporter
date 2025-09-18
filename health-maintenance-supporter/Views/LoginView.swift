//
//  LoginView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//


import SwiftUI

struct SignInView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isSecure = true
    @State private var showAlert = false
    
    @EnvironmentObject var authViewModel : AuthenticationViewModel

    var body: some View {
        NavigationView{
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
                    
           
                    VStack(spacing: 20) {
                        Text("Welcome Back")
                            .font(.largeTitle.bold())
                            .foregroundColor(Color.appPrimary)
             
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .padding()
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                            .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                            .foregroundColor(.white)
                   
                        HStack {
                            if isSecure {
                                SecureField("Password", text: $password)
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
                        
                        // Login Button
                        Button(action: {
                            Task {
                               await authViewModel.login(email: email, password: password)
                            }
                        }) {
                            Text("Sign In")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [Color.appPrimary, Color.appPrimary], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(radius: 8, y: 4)
                        }
                        .alert(isPresented: $authViewModel.loginError) {
                            Alert(title: Text("Login"), message: Text("Invalid email or password"), dismissButton: .default(Text("Try Again")))
                        }
                        
                        Button("Forgot Password?") {}
                            .font(.footnote)
                            .padding(.top, 4)
                        
                        Divider()
                        //                        .padding(.vertical)
                        
                        Button(action: {
                            showAlert = true
                        }) {
                            HStack {
                                Image(systemName: "faceid")
                                    .font(.title)
                                    .padding(.trailing)
                                Text("Face ID")
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(Color.appSecondary, lineWidth: 4)
                            )
                            .foregroundColor(Color.appSecondary)
                        }
                        .cornerRadius(14) // Optional: for tap area rounding
                        .shadow(radius: 8, y: 4)
                      
                        
                    }
                    .padding(30)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 30, y: 10)
                    
                    
                    
                    
                    
                    Spacer()
                    HStack {
                        Text("Don't have an account?")
                            .foregroundColor(Color.appText.opacity(0.7))
                        NavigationLink(destination: SignupView().environmentObject(authViewModel)) {
                            Text("Sign Up")
                                .foregroundColor(Color.appText)
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
