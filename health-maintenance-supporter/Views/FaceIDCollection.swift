//
//  FaceIDCollection.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-03.
//

import SwiftUI

struct FaceIDCollectionView: View {
    @EnvironmentObject var session: AuthenticationViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            LinearGradient(
                gradient: Gradient(colors: [Color.appPrimary.opacity(0.5), Color.appSecondary.opacity(0.5)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
        }.frame(maxHeight: .infinity, alignment: .top)
    }
}
