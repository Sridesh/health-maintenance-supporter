//
//  FaceIDCollection.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-03.
//

import SwiftUI

struct FaceIDCollectionView: View {
    @EnvironmentObject var session: AuthenticationViewModel
//    @EnvironmentObject var session: AuthenticationViewModelMock // for testing
    
    var body: some View {
        ZStack{
            LinearGradient(
                gradient: Gradient(colors: [Color.appBackgound, Color.appSecondary.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(alignment: .leading){
                Text("Please authenticate with your FaceID to proceed to the application")
                    .foregroundColor(.white)
                    .bold()
                    .frame(width: 300)
                    .multilineTextAlignment(.center)
                    .padding(.bottom)
                
                Button(action: {
                    session.authenticateWithBiometrics()
                }) {
                    HStack {
                        Image(systemName: "faceid")
                            .font(.title)
                            .padding(.trailing)
                        Text("Authenticate Face ID")
                            .fontWeight(.semibold)
                    }
                    .frame(width:300)
                    .padding()
                    .background(
//                        RoundedRectangle(cornerRadius: 14)
//                            .stroke(Color.white, lineWidth: 4)
                        .white.opacity(0.5)
                    )
                    .foregroundColor(Color.appSecondary)
                }
                .cornerRadius(14)
                .shadow(radius: 8, y: 4)
                
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .center)
            .frame(maxWidth: .infinity, alignment: .center)
        }
    }
}
