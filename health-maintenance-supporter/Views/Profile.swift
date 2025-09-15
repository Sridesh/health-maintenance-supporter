//
//  Profile.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI

struct ProfileView:View {
    @EnvironmentObject var session: AuthenticationViewModel
    @EnvironmentObject var userViewModel : UserViewModel
    
    @State private var isShowingSheet = false
    @State private var isGoalShowingSheet = false

    var body: some View {
        NavigationView {
            
            ZStack{
                LinearGradient(
                    gradient: Gradient(colors: [Color.appPrimary.opacity(0.33), Color.appSecondary.opacity(0.20)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack{
                    ScrollView{
                        VStack(spacing: 20){
                            HStack{
                                Spacer()
                                Image("fitzy-pic")
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .padding(.vertical,0)
                                Spacer()
                                Text("Sridesh Fernando")
                                    .font(.title2).bold()
                                Spacer()
                            }
                            .padding(.horizontal)
                            
                            //                Text(session.user?.email ?? "No email")
                            //                    .frame(maxWidth: .infinity, alignment: .center)
                            //                    .bold()
                            //
                            //
                            //                Text(session.user?.password ?? "No phone number")
                            //                    .foregroundColor(.secondary)
                            //                Text(session.user?.gender ?? "No phone number")
                            //                    .foregroundColor(.secondary)
                            
                            
                            HStack{
                                Spacer()
                                VStack{
                                    Text("\(userViewModel.currentUser.age)").foregroundColor(.white).bold()
                                    Text("Current Age").font(.caption).foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                                VStack{
                                    Text("\(userViewModel.currentUser.isMale ? "Male" : "Female")").foregroundColor(.white).bold()
                                    Text("Gender").font(.caption).foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                                VStack{
                                    Text("\(Int(userViewModel.getBMI()))").foregroundColor(.white).bold()
                                    Text("Current BMI").font(.caption).foregroundColor(.white.opacity(0.5))
                                }
                                Spacer()
                            }.frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.appPrimary)
                                .cornerRadius(10)
                            
                            VStack{
                                Text("Account").foregroundColor(.appSecondary).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal).padding(.top)
                                GlassCard{
                                    VStack{
                                        InfoView(title: "Email", value: "\(userViewModel.currentUser.email)")
                                        Divider().padding(.vertical)
                                        InfoView(title: "Joined on", value: "")
                                    }.frame(maxWidth: .infinity)
                                }
                            }
                            
                            VStack{
                                HStack{
                                    Text("Profile").foregroundColor(.appSecondary).frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                    NavigationLink(destination: DashboardView()) {
                                        Button("Edit", systemImage: "pencil"){
                                            isShowingSheet = true
                                        }.foregroundColor(.blue)
                                    }
                                }.padding(.horizontal).padding(.top)
                                
                                GlassCard{
                                    VStack{
                                        InfoView(title: "Name", value: "Sridesh Fernando")
                                        Divider().padding(.vertical)
                                        InfoView(title: "Age", value: String(userViewModel.currentUser.age))
                                        Divider().padding(.vertical)
                                        InfoView(title: "Height", value: String(userViewModel.currentUser.height))
                                        Divider().padding(.vertical)
                                        InfoView(title: "Weight", value: String(userViewModel.currentUser.weight))
                                    }.frame(maxWidth: .infinity)
                                }
                            }.sheet(isPresented: $isShowingSheet, onDismiss: {
                                isShowingSheet = false
                            }) {
                                EditUserView().environmentObject(userViewModel)
                            }
                            
                            VStack{
                                HStack{
                                    Text("Goal").foregroundColor(.appSecondary).frame(maxWidth: .infinity, alignment: .leading)
                                    Spacer()
                                    NavigationLink(destination: DashboardView()) {
                                        Button("Change Goal", systemImage: "pencil"){
                                            isGoalShowingSheet = true
                                        }.foregroundColor(.blue)
                                    }
                                }.padding(.horizontal).padding(.top)
                                
                                GlassCard{
                                    VStack{
                                        HStack{
                                            Text("\(userViewModel.goal?.goal ?? "Error loading goal")")
                                            Spacer()
                                            Button("", systemImage: "chevron.right"){
                                                
                                            }.foregroundColor(.gray)
                                        }
                                    }.frame(maxWidth: .infinity)
                                }
                            }.sheet(isPresented: $isGoalShowingSheet, onDismiss: {
                                isGoalShowingSheet = false
                            }) {
                                FitnessListView(isInside: true)
                                    .environmentObject(userViewModel)
                            }
                            
                            VStack{
                                Text("About").foregroundColor(.appSecondary).frame(maxWidth: .infinity, alignment: .leading).padding(.horizontal).padding(.top)
                                GlassCard{
                                    VStack{
                                        HStack{
                                            Text("Privacy Policy")
                                            Spacer()
                                            Button("", systemImage: "chevron.right"){
                                                
                                            }.foregroundColor(.gray)
                                        }
                                        Divider().padding(.vertical)
                                        HStack{
                                            Text("Terms of services")
                                            Spacer()
                                            Button("", systemImage: "chevron.right"){
                                                
                                            }.foregroundColor(.gray)
                                        }
                                    }.frame(maxWidth: .infinity)
                                }
                            }
                            GlassCard{
                                Button("Logout", role: .destructive){
                                    session.logout(email: session.user?.email ?? "")
                                    userViewModel.goal = nil
                                    userViewModel.currentUser.goalId = nil
                                }.frame(maxWidth: .infinity)
                            }
                            
                            
                            Button("Delete Account", role: .destructive){
                                                session.deleteProfile()
                            }.frame(maxWidth: .infinity)
                        }
                        .padding()
                    }
                }.frame(height: 700)
            }
        }
    }
}

struct InfoView: View {
    let title: String
    let value: String
    var body: some View {
        HStack{
            Text(title).font(.headline)
            Spacer()
            Text(value).foregroundColor(.appSecondary)
        }
    }
}

#Preview {
//    ProfileView()
}
