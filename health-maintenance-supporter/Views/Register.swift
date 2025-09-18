////
////  Register.swift
////  health-maintenance-supporter
////
////  Created by Sridesh 001 on 2025-09-02.
////
//
//import SwiftUI
//import SwiftData
//
//struct SignUp: View {
//    @Environment(\.modelContext) private var context
//    @EnvironmentObject var viewModel: AuthenticationViewModel
//
//    @State private var email = ""
//    @State private var password = ""
//    @State private var showAlert = false
//    
//    var body: some View {
//            VStack{
//                VStack{
//                    HStack{
//                        Text("Fitzy")
//                            .font(.title)
//                            .bold()
//                            .foregroundColor(.appPrimary)
//                        
//                        Image("logo")
//                            .resizable()
//                            .aspectRatio(contentMode: .fit)
//                            .frame(width: 70, height: 50)
//                    }.padding()
//                        .frame(maxWidth: .infinity)
//                    
//                    Image("welcome")
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .frame(width: 200, height: 200)
//                }
//                .padding()
//                .frame(maxWidth: .infinity)
////                .background(
////                    LinearGradient(colors: [Color(hex: "ff724c"), Color(hex: "#fdbf50")], startPoint: .leading, endPoint: .trailing)
////                )
//                
//                //Form part
//                VStack{
//                    Text("Sign Up")
//                        .font(.title)
//                        .bold()
//                        .padding(.bottom, 20)
//                    
//
//                    
//                    TextField("Email", text: $email)
//                        .keyboardType(.emailAddress)
//                        .autocapitalization(.none)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                    
//                    SecureField("Password", text: $password)
//                        .keyboardType(.phonePad)
//                        .autocapitalization(.none)
//                        .padding()
//                        .background(Color(.systemGray6))
//                        .cornerRadius(10)
//                        .padding(.horizontal)
//                    
//
//                    
//                    
//                    Button(action: {
//                        if email.isEmpty || password.isEmpty {
//                                            showAlert = true
//                                        } else {
//                                            viewModel.register(email: email, password: password)
//                                        }
//                    }) {
//                        Text("Sign Up")
//                            .frame(maxWidth: .infinity)
//                            .padding()
//                            .background(Color(hex: "#ff724c"))
//                            .foregroundColor(.white)
//                            .cornerRadius(10)
//                            .padding(.horizontal)
//                    }
//                    .alert("Please fill in all fields", isPresented: $showAlert) {
//                        Button("OK", role: .cancel) {}
//                    }.padding(.vertical)
//                    
//                    HStack{
//                        Text("Already have an account?")
//                        NavigationLink(destination: DashboardView()){
//                            Text("Login")
//                                .foregroundColor(.blue)
//                                .font(.headline)
//                            
//                        }
//                    }
//                    
//                    
//                }.padding()
////                    .frame(maxHeight: .infinity)
//            }.frame(maxHeight: .infinity, alignment: .top)
//        }
//}
////
////#Preview {
////    SignUp().environmentObject(viewMo)
////}
