//
//  AdditionalDetails.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-06.
//

import SwiftUI

struct AdditionalDetails: View {
    
        @EnvironmentObject var viewModel: AuthenticationViewModel
    
        @State private var step = 0
    
        @State private var gender: String = ""
        @State private var age: String = ""
        @State private var weight: String = ""
        @State private var height: String = ""
    
        @State private var showAlert = false
    
        let genders = ["Male", "Female", "Other"]


    var body: some View {
        
        VStack(spacing: 40) {
                    Text("Tell us about yourself")
                        .font(.title)
                        .bold()
                        .padding(.top, 40)
        
                    if step == 0 {
                        VStack(spacing: 20) {
                            Text("Select your gender")
                                .font(.headline)
                            Picker("Gender", selection: $gender) {
                                ForEach(genders, id: \.self) { g in
                                    Text(g)
                                }
                            }
                            .pickerStyle(.segmented)
                            Button("Next") {
                                if gender.isEmpty {
                                    showAlert = true
                                } else {
                                    step += 1
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if step == 1 {
                        VStack(spacing: 20) {
                            Text("Enter your age")
                                .font(.headline)
                            TextField("Age", text: $age)
                                .keyboardType(.numberPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .frame(width: 200)
                            Button("Next") {
                                if age.isEmpty || Int(age) == nil {
                                    showAlert = true
                                } else {
                                    step += 1
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if step == 2 {
                        VStack(spacing: 20) {
                            Text("Enter your weight (kg)")
                                .font(.headline)
                            TextField("Weight", text: $weight)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .frame(width: 200)
                            Button("Next") {
                                if weight.isEmpty || Double(weight) == nil {
                                    showAlert = true
                                } else {
                                    step += 1
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    } else if step == 3 {
                        VStack(spacing: 20) {
                            Text("Enter your height (cm)")
                                .font(.headline)
                            TextField("Height", text: $height)
                                .keyboardType(.decimalPad)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(10)
                                .frame(width: 200)
                            Button("Finish") {
                                if height.isEmpty || Double(height) == nil {
                                    showAlert = true
                                } else {
                                        viewModel.addUserData(gender: gender, age: Int(age) ?? 0 , weight: Int(weight) ?? 0, height: Int(height) ?? 0)
                                }
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                }
                .alert("Please enter a valid value", isPresented: $showAlert) {
                    Button("OK", role: .cancel) {}
                }
                .padding()
    }
}
