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
    @State private var name: String = ""
    @State private var showAlert = false
    
    @State var navigateToCarousel = false

    let genders = ["Male", "Female", "Other"]

    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.appBackgound, Color.appSecondary.opacity(0.5)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()

                VStack(spacing: 20) {
                    //---------------app Logo--------------------//
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

                       
                        stepView()
                    }
                    .padding(30)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 30))
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color.appWhiteText.opacity(0.15), lineWidth: 1)
                    )
                    .shadow(color: .black.opacity(0.2), radius: 30, y: 10)

                    Spacer()
                }
                .padding(.horizontal, 24)
            }
            .alert("Please enter valid value", isPresented: $showAlert) {
                Button("OK", role: .cancel) {}
            }
        }
    }

    @ViewBuilder
    private func stepView() -> some View {
        switch step {
            
        case 0:     //name collection
            VStack(spacing: 20) {
                Text("What name should we call you?")
                    .font(.headline)
                    .foregroundColor(.appWhiteText)

                TextField("Name", text: $name)
                    .keyboardType(.default)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appWhiteText.opacity(0.2)))
                    .foregroundColor(.appWhiteText)

                nextButton()
            }
        
        case 1:     //gender
            VStack(spacing: 20) {
                Text("Nice to know you \(name).")
                    .font(.headline)
                    .foregroundColor(.appWhiteText)
                
                Text("What waas the gender assigned to you at birth?")
                    .font(.headline)
                    .foregroundColor(.appWhiteText)

                Picker("Gender", selection: $gender) {
                    ForEach(genders, id: \.self) { g in
                        Text(g).tag(g)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal)

                nextButton()
            }

        case 2:     //age collection
            VStack(spacing: 20) {
                Text("How old are you \(name)?")
                    .font(.headline)
                    .foregroundColor(.appWhiteText)

                TextField("Age", text: $age)
                    .keyboardType(.numberPad)
                    .padding()
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.appWhiteText.opacity(0.2)))
                    .foregroundColor(.white)

                nextButton()
            }

        case 3:     //weight collection
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

        case 4:     //height collection
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
            
        case 5:     //detail confirmation
            VStack{
                
                if userModel.currentUser.goalId != nil {
                    ScrollView{
                        VStack{
                            Text("Thank you very much for you input, \(name)").frame(maxWidth: .infinity).foregroundColor(.appPrimary)
                            Text("Please verify the below data, and click confirm to proceed.")
                                .frame(maxWidth: .infinity).foregroundColor(.appPrimary)
                            
                            Divider().padding(.vertical)
                            
                            HStack{
                                Text("Name")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                TextField("Name", text: $name)
                                    .keyboardType(.default)
                                    .frame(width:100)
                                    .padding()
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                                    .foregroundColor(.white)
                            }
                            
                            HStack{
                                Text("Gender assigned to you at birth?")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                Picker("Gender", selection: $gender) {
                                    ForEach(genders, id: \.self) { g in
                                        Text(g).tag(g)
                                    }
                                }
                            }
                            
                            
                            
                            HStack{
                                Text("Age")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                TextField("Age", text: $age)
                                    .keyboardType(.numberPad)
                                    .frame(width:50)
                                    .padding()
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                                    .foregroundColor(.white)
                                
                            }
                            
                            HStack{
                                Text("Weight (kg)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                TextField("Weight", text: $weight)
                                    .keyboardType(.decimalPad)
                                    .frame(width:50)
                                    .padding()
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                                    .foregroundColor(.white)
                            }
                            
                            HStack{
                                Text("Height (cm)")
                                    .font(.headline)
                                    .foregroundColor(.white)
                                Spacer()
                                TextField("Height", text: $height)
                                    .keyboardType(.decimalPad)
                                    .frame(width:50)
                                    .padding()
                                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 14))
                                    .overlay(RoundedRectangle(cornerRadius: 14).stroke(Color.white.opacity(0.2)))
                                    .foregroundColor(.white)
                            }
                        }.frame(height:500, alignment: .top)
                    }
                    Spacer()
                    
                    NavigationLink(destination: OnboardCarouselView().environmentObject(userModel)){
                        Button(action: {
                            finishButtonTapped()
                            navigateToCarousel = true
                        }) {
                            Text("Finish")
                                .fontWeight(.semibold)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(colors: [Color.appPrimary, Color.appPrimary], startPoint: .leading, endPoint: .trailing))
                                .foregroundColor(.white)
                                .cornerRadius(14)
                                .shadow(radius: 8, y: 4)
                        }
                    }
                } else {
                    FitnessListView(isInside:false)
                        .environmentObject(userModel)
                }
            }
            .frame(height: 500)
            .background(Color.clear)
            
            NavigationLink(
                destination: OnboardCarouselView().environmentObject(userModel),
                isActive: $navigateToCarousel
            ) {
                EmptyView()
            }
            


        default:
            EmptyView()
        }
    }

    private func nextButton() -> some View {
        Button(action: {
            if  step == 0 && name.isEmpty ||
                step == 1 && gender.isEmpty ||
                step == 2 && (age.isEmpty || Int(age) == nil) ||
                step == 3 && (weight.isEmpty || Double(weight) == nil) {
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

        viewModel.addUserData(name:name.lowercased(), gender: gender, age: a, weight: Int(w), height: Int(h))
        userModel.setUser(user: UserType(name:name.lowercased(), email: userModel.currentUser.email, isMale: gender == "Male", age: a, weight: w, height: h, onboarded: false))
    }
}
