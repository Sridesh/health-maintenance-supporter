//
//  EditUserView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-15.
//

import SwiftUI

struct EditUserView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var isMale: Bool = true
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.appPrimary.opacity(0.33), Color.appSecondary.opacity(0.20)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack{
                        GlassCard{
                            VStack{
                                Text("Gender Assigned at birth")
                                Picker("Gender", selection: $isMale) {
                                    Text("Male").tag(true)
                                    Text("Female").tag(false)
                                }
                                .pickerStyle(.segmented)
                            }
                            Divider().padding(.vertical)
                            HStack{
                                Text("Age")
                                Spacer()
                                TextField("Age", text: $age)
                                    .keyboardType(.numberPad)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }.frame(maxWidth: .infinity)
                            Divider().padding(.vertical)
                            HStack{
                                Text("Wight")
                                Spacer()
                                TextField("Weight (kg)", text: $weight)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }.frame(maxWidth: .infinity)
                            Divider().padding(.vertical)
                            HStack{
                                Text("Weight")
                                Spacer()
                                TextField("Height (cm)", text: $height)
                                    .keyboardType(.decimalPad)
                                    .padding()
                                    .frame(width: 200)
                                    .background(Color.white)
                                    .cornerRadius(10)
                            }.frame(maxWidth: .infinity)
                               
                        }.frame(maxWidth: .infinity)
                        .padding()
                        
                        Section {
                            Button(action: saveUser) {
                                Text("Save Changes")
                                    .frame(maxWidth: .infinity, alignment: .center)
                            }
                            
                            .padding()
                            .frame(maxWidth:.infinity)
                            .background(Color.appPrimary)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .listRowBackground(Color.appPrimary)
                        }.padding()
                    }
                
                .frame(maxHeight: .infinity, alignment: .top)
                    .navigationTitle("Edit Profile")
                    .onAppear {
                        // preload existing user data
                        let user = userViewModel.currentUser
                        self.age = "\(user.age)"
                        self.weight = "\(user.weight)"
                        self.height = "\(user.height)"
                        self.isMale = user.isMale
                    }
                    .toolbar {
                        ToolbarItem(placement: .cancellationAction) {
                            Button("Cancel") { dismiss() }
                        }
                    }
            }
        }
    }
    
    private func saveUser() {
        guard let ageInt = Int(age),
              let weightDouble = Double(weight),
              let heightDouble = Double(height) else {
            print("Invalid input")
            return
        }
        
        let updatedData: [String: Any] = [
            "age": ageInt,
            "weight": weightDouble,
            "height": heightDouble,
            "isMale": isMale
        ]
        
        userViewModel.updateUser(
            email: userViewModel.currentUser.email,
            newData: updatedData
        )
        
        dismiss()
    }
}
