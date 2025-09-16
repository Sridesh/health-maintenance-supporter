//
//  SplashScreen.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-16.
//

import SwiftUI

struct SplashScreen: View {
    var body: some View {
        VStack{
            Image("fitzy")
                .resizable()
                .frame(width: 200, height: 70)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        .background(Color.appSecondary.opacity(0.4))
    }
}
