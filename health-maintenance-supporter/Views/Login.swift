////
////  Login.swift
////  health-maintenance-supporter
////
////  Created by Sridesh 001 on 2025-09-02.
////
//
//import SwiftUI
//import SwiftData
//
//struct LoginView: View {
//    @Environment(\.modelContext) private var context
//    @EnvironmentObject var viewModel: AuthenticationViewModel
//
//    @State private var email = ""
//    @State private var phone = ""
//    @State private var showAlert = false
//
//    var body: some View {
//        VStack {
//            VStack {
//                HStack {
//                    Text("Fitzy")
//                        .font(.title)
//                        .bold()
//                        .foregroundColor(.appPrimary)
//                    Image("logo")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 70, height: 50)
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
//
//                Image("welcome")
//                    .resizable()
//                    .aspectRatio(contentMode: .fit)
//                    .frame(width: 200, height: 200)
//            }
//            .padding()
//            .frame(maxWidth: .infinity)
//
//            VStack {
//                Text("Login")
//                    .font(.title)
//                    .bold()
//                    .padding(.bottom, 20)
////                 
//
//                TextField("Email", text: $email)
//                    .keyboardType(.emailAddress)
//                    .autocapitalization(.none)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//
//                TextField("Mobile Number", text: $phone)
//                    .keyboardType(.phonePad)
//                    .autocapitalization(.none)
//                    .padding()
//                    .background(Color(.systemGray6))
//                    .cornerRadius(10)
//                    .padding(.horizontal)
//
//                Button(action: {
//                    if email.isEmpty || phone.isEmpty {
//                        showAlert = true
//                    } else {
////                        viewModel.login(email: email, phone: phone)
//                    }
//                }) {
//                    Text("Login")
//                        .frame(maxWidth: .infinity)
//                        .padding()
//                        .background(Color(hex: "#ff724c"))
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                }
//                .alert("Please fill in all fields", isPresented: $showAlert) {
//                    Button("OK", role: .cancel) {}
//                }
//                .padding(.vertical)
//
//                HStack {
//                    Text("Don't have an account?")
//                    NavigationLink(destination: SignUp()) {
//                        Text("Sign Up")
//                            .foregroundColor(.blue)
//                            .font(.headline)
//                    }
//                }
//            }
//            .padding()
//        }
//        .frame(maxHeight: .infinity, alignment: .top)
//    }
//}
//
//#Preview {
//    LoginView()
//}
