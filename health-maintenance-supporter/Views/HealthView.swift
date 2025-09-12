//
//  HealthView.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-11.
//

import SwiftUI
import Charts

struct StepData: Identifiable {
    var id = UUID()
    var day: String
    var steps: Double
}

struct HealthView: View {
    
    let data: [StepData] = [
        StepData(day: "Mon", steps: 5000),
        StepData(day: "Tue", steps: 7500),
        StepData(day: "Wed", steps: 9000),
        StepData(day: "Thu", steps: 6500),
        StepData(day: "Fri", steps: 10000),
        StepData(day: "Sat", steps: 12000),
        StepData(day: "Sun", steps: 8000),
    ]
    
    
    @StateObject private var healthStore = HealthStore()
    
    var body: some View {
        ZStack{
            //background
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBlue).opacity(0.13), Color(.systemPurple).opacity(0.10)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            
            VStack(spacing: 20) {
                HStack{

                    VStack{
                        Text("Your Activity Today")
                            .font(.headline)
                            .padding(.top)
                            .padding(.horizontal, 30)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                    
                
                
                ScrollView{
                    //content
                    VStack(spacing: 15){
                    GlassCard {
                        HStack{
                            Image(systemName: "flame")
                                .foregroundColor(Color.white)
                                .padding(6)
                                .frame(width: 30)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(5)
                            
                            
                            
                            VStack(alignment: .leading) {
                                Text("Calories Burned")
                                    .font(.headline)
                                
                                HStack(alignment: .firstTextBaseline, spacing: 2) {
                                    Text("\(Int(healthStore.basalCalories + healthStore.activeCalories))")
                                        .font(.title2)
                                    Text("/ 10,000")
                                        .font(.caption).foregroundColor(Color.gray)
                                }
                            }
                            
                            
                        }.frame(maxWidth: .infinity, alignment: .leading)
                        
                        ZStack(alignment: .leading) {
                            Rectangle()
                                .frame( width: 340,height: 7)
                                .foregroundColor(Color.gray.opacity(0.3))
                                .cornerRadius(4)
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 340 * 0.5, height: 7)
                                .cornerRadius(4)
                            
                        }.frame(height: 7)
                            .padding(.top)
                        
                        HStack{
                            Text("At rest: ").font(.caption).font(.system(size: 15)).foregroundColor(Color.gray) +
                            Text("\(Int(healthStore.activeCalories)) kcal").font(.system(size: 15)).bold()
                            
                            Spacer()
                            
                            Text("From activity: ").font(.system(size: 15)).foregroundColor(Color.gray) + Text("\(Int(healthStore.activeCalories)) kcal").font(.system(size: 15)).bold()
                        }.padding(.top,3)
                    }

                    HStack{
                        VStack {
                            Image("walking")
                                .resizable()
                                .frame(width: 180, height: 110)
                            
                            VStack{
                                Text("Step Count:").font(.headline)
                                Text("\(Int(healthStore.steps))").font(.title2)
                            }.padding(.vertical,3)
                        }
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .shadow(color:Color.gray.opacity(0.3),radius: 10)
                        Spacer()
                        
                        VStack {
                            Image("steps")
                                .resizable()
                                .frame(width: 180, height: 110)
                            
                            VStack{
                                Text("Flights Climbed:").font(.headline)
                                Text("\(Int(healthStore.flights))").font(.title2)
                            }.padding(.vertical,3)
                        }
                        .background(Color.white.opacity(0.5))
                        .cornerRadius(10)
                        .shadow(color:Color.gray.opacity(0.3),radius: 10)
                        
                        
                        
                    }            
                    
                    GlassCard{
                        HStack {
                            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                                .foregroundColor(Color.white)
                                .padding(6)
                                .frame(width: 30)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.blue, Color.purple]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .cornerRadius(5)
                            
                            Text("Distance:").font(.headline)
                            Spacer()
                            Text(String(format: "%.2f km", healthStore.distance / 1000)) // meters → km
                        }
                    }
                    
                    GlassCard{
                        Chart {
                            ForEach(data) { point in
                                LineMark(
                                    x: .value("Day", point.day),
                                    y: .value("Steps", point.steps)
                                )
                                .interpolationMethod(.catmullRom) // smooth curve
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.blue, .purple],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                
                                // Optional: Fill under the line with gradient
                                AreaMark(
                                    x: .value("Day", point.day),
                                    y: .value("Steps", point.steps)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue.opacity(0.3), .purple.opacity(0.1)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        
                    }
                    }.padding(.horizontal, 20)
                }
                
                .frame(height: 730)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding(.vertical)
            //                .background(Color(hex: "#fff1ed"))
            
        }
        
    }
}

#Preview {
    HealthView()
}
