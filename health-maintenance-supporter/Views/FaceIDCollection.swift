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
            Text("Logging in \(session.user?.gender)").foregroundColor(Color(hex: "#ff724c"))
            Text("We use Face ID to log you into our application")
                .foregroundColor(Color(hex: "#ff724c")).opacity(0.5)
        }.frame(maxHeight: .infinity, alignment: .top)
    }
}
