//
//  HealthView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-11.
//

import SwiftUI

struct HealthView: View {
    @StateObject private var healthStore = HealthStore()
        
        var body: some View {
            VStack(spacing: 20) {
                Text("Your Activity Today")
                    .font(.title)
                    .padding(.bottom, 10)
                
                
                Image("activity")
                    .padding(.vertical)
                
                
                HStack {
                    Image("steps")
                        .resizable()
                        .frame(width: 40, height: 40)
                
                    Text("Steps:").font(.headline)
                    Spacer()
                    Text("\(Int(healthStore.steps))")
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
                
                HStack {
                    Image("distance")
                        .resizable()
                        .frame(width: 40, height: 40)
                     
                    Text("Distance:").font(.headline)
                    Spacer()
                    Text(String(format: "%.2f km", healthStore.distance / 1000)) // meters → km
                }.padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
                
                HStack {
                    Image("climb")
                        .resizable()
                        .frame(width: 40, height: 40)
            
                    Text("Flights Climbed:").font(.headline)
                    Spacer()
                    Text("\(Int(healthStore.flights))")
                }.padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
                
                HStack {
                    Image("active")
                        .resizable()
                        .frame(width: 40, height: 40)
                    
                    Text("Active Calories:").font(.headline)
                    Spacer()
                    Text("\(Int(healthStore.activeCalories)) kcal")
                }.padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
                
                HStack {
                    Image("rest")
                        .resizable()
                        .frame(width: 40, height: 40)
                                            Text("Basal Calories:").font(.headline)
                    Spacer()
                    Text("\(Int(healthStore.basalCalories)) kcal")
                }.padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color:Color(hex:"#ff724c").opacity(0.2),radius: 10)
            }
            
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .background(Color(hex: "#fff1ed"))
            
        }
}

#Preview {
    HealthView()
}
