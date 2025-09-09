//
//  Profile.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI

struct ProfileView:View {
    @EnvironmentObject var session: AuthenticationViewModel
    
    
    @State private var isShowingSheet = false
    @State private var location = "Colombo"
    
    var body: some View {
        VStack{
            
            
            VStack{
                Image("profile")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(50)
                    .padding(.vertical,0)
                
                Text(session.user?.email ?? "No email")
                    .frame(maxWidth: .infinity, alignment: .center)
                    .bold()
                
                
                Text(session.user?.password ?? "No phone number")
                    .foregroundColor(.secondary)
                Text(session.user?.gender ?? "No phone number")
                    .foregroundColor(.secondary)
                

            }
            
            Button("Logout", role: .destructive){
                session.logout(email: session.user?.email ?? "")
            }
            
            Button("Delete Account", role: .destructive){
                session.deleteProfile()
            }

            
//            Section(header: Text("My Actions")){
//                    ForEach(actions, id: \.self){
//                        item in
//                        HStack{
//                            
//                            Text(item)
//                            Spacer()
//                            Image(systemName: "chevron.right")
//                                .foregroundColor(.secondary)
//                        }
//                    }
//                
//            }
            
//            Section(header: Text("Account")){
//                ForEach(options, id: \.self){
//                    item in
//                    HStack{
//                        
//                        Text(item)
//                        Spacer()
//                        Image(systemName: "chevron.right")
//                            .foregroundColor(.secondary)
//                    }
//                }
//            }
        }
    }
}
