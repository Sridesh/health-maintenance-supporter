//
//  FoodIntake.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI


struct FoodIntake:View {
    var title: String
    var icon: String
    
    var body: some View {
        VStack{
            HStack{
                Image(icon).resizable().frame(width: 50, height: 50)
                Text(title).bold()
                Spacer()
                Button("View", systemImage: "plus"){
                    
                }.padding(10).background(Color(hex: "#ff724c")).cornerRadius(50).foregroundColor(.white)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading).padding(20)
        .background(Color.white)
        .cornerRadius(15)
        .shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
    }
}
#Preview {
    FoodIntake(title: "Breakfast", icon: "breakfast")
}
