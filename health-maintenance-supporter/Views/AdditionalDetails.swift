//
//  AdditionalDetails.swift
//  health-maintenance-supporter
//

import SwiftUI

struct AdditionalDetails: View {
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @EnvironmentObject var userModel: UserViewModel

    @State private var step = 0
    @State private var gender: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var height: String = ""
    @State private var goalId: String = ""
    @State private var showAlert = false

    let genders = ["Male", "Female", "Other"]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.appPrimary.opacity(0.5), Color.appSecondary.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    // App Logo
                    Image("fitzy")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 120)
                        .padding(.top, 40)

                    VStack(spacing: 25) {
                        Text("Tell us about yourself")
                            .font(.title2.bold())
                            .foregroundColor(Color.appPrimary)
                            .padding(.bottom, 10)

                        // Step Views
                        stepView()
                    }
                    .padding(30)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.white.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 30, y: 10)

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .alert("Please enter a valid value", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    @ViewBuilder
    private func stepView() -> some View {
        switch step {
        case 0:
            VStack(spacing: 20) {
                Text("Select your gender")
                    .font(.headline)
                    .foregroundColor(.white)

                Picker("Gender", selection: $gender) {
                    ForEach(genders, id: \.self) { g in
                        Text(g).tag(g)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                nextButton()
            }

        case 1:
            VStack(spacing: 20) {
                Text("Enter your age")
                    .font(.headline)
                    .foregroundColor(.white)

                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                    .foregroundColor(.white)

                nextButton()
            }

        case 2:
            VStack(spacing: 20) {
                Text("Enter your weight (kg)")
                    .font(.headline)
                    .foregroundColor(.white)

                TextField("Weight", text: $weight)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                    .foregroundColor(.white)

                nextButton()
            }

        case 3:
            VStack(spacing: 20) {
                Text("Enter your height (cm)")
                    .font(.headline)
                    .foregroundColor(.white)

                TextField("Height", text: $height)
                    .keyboardType(.decimalPad)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                    .foregroundColor(.white)
                
                nextButton()


            }
            
        case 4:
            VStack{
                if userModel.currentUser.goalId != nil {
                    Button(action: finishButtonTapped) {
                        Text("Finish")
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(LinearGradient(colors: [Color.appPrimary, Color.appPrimary], startPoint: .leading, endPoint: .trailing))
                            .foregroundColor(.white)
                            .cornerRadius(14)
                            .shadow(radius: 8, y: 4)
                    }
                } else {
                    FitnessListView(isInside:false)
                        .environmentObject(userModel)
                }
            }
            .frame(height: 500)
            .background(Color.clear)
            


        default:
            EmptyView()
        }
    }

    private func nextButton() -> some View {
        Button(action: {
            if step == 0 && gender.isEmpty ||
                step == 1 && (age.isEmpty || Int(age) == nil) ||
                step == 2 && (weight.isEmpty || Double(weight) == nil) {
                showAlert = true
            } else {
                step += 1
            }
        }) {
            Text("Next")
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(LinearGradient(colors: [Color.appPrimary, Color.appPrimary], startPoint: .leading, endPoint: .trailing))
                .foregroundColor(.white)
                .cornerRadius(14)
                .shadow(radius: 8, y: 4)
        }
    }

    private func finishButtonTapped() {
        guard !height.isEmpty, let h = Double(height),
              let w = Double(weight), let a = Int(age) else {
            showAlert = true
            return
        }

        viewModel.addUserData(gender: gender, age: a, weight: Int(w), height: Int(h))
        userModel.setUser(user: UserType(email: userModel.currentUser.email, isMale: gender == "Male", age: a, weight: w, height: h))
    }
}
