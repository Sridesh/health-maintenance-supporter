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
    
    @EnvironmentObject var user : UserViewModel
    
    @StateObject private var healthStore = HealthStore()
    
    var body: some View {
        ZStack{
            VStack(spacing: 20) {
                
                Text("Your Activity Today")
                    .font(.title3)
                    .bold()
                    .foregroundColor(.appPrimary)

                
                ScrollView{
                    //content
                    VStack(spacing: 15){
            
                    CalCount().environmentObject(user)
                        
                    GlassCard{
                        HStack {
                            Image(systemName: "point.topleft.down.to.point.bottomright.curvepath")
                                .foregroundColor(Color.white)
                                .padding(6)
                                .frame(width: 30)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.appPrimary, Color.appSecondary]),
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
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [.appBlue, .appSecondary],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                

                                AreaMark(
                                    x: .value("Day", point.day),
                                    y: .value("Steps", point.steps)
                                )
                                .interpolationMethod(.catmullRom)
                                .foregroundStyle(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color.appPrimary.opacity(0.3), Color.appBlue.opacity(0.2)]),
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                            }
                        }
                        .frame(height: 200)
                        .padding()
                        
                    }
                    }
//                    .padding(.horizontal, 20)
                }
                
                .frame(height: 550)
            }
            .frame(maxHeight: .infinity, alignment: .top)
            
        }
        
    }
}

struct CalCount: View {
    @EnvironmentObject var user : UserViewModel
    
    @StateObject private var healthStore = HealthStore()
    
    var body: some View {
        GlassCard {
            HStack{
                Image(systemName: "flame")
                    .foregroundColor(Color.white)
                    .padding(6)
                    .frame(width: 30)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors: [.appPrimary, .appSecondary]),
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
                        Text(" / \(user.goal?.dailyTargets.steps ?? 0)")
                            .font(.caption).foregroundColor(Color.appSecondary)
                    }
                }
                
                
            }
            .frame(alignment: .leading)
            
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame( width: 300,height: 7)
                    .foregroundColor(Color.appSecondary.opacity(0.3))
                    .cornerRadius(4)
                Rectangle()
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [.appPrimary, .appSecondary]),
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .frame(width: 300 * 0.5, height: 7)
                    .cornerRadius(4)
                
            }.frame(height: 7)
                .padding(.top)
            
            HStack{
                Text("At rest: ").font(.caption).font(.system(size: 15)).foregroundColor(Color.appSecondary) +
                Text("\(Int(healthStore.activeCalories)) kcal").font(.system(size: 15)).bold()
                
                Spacer()
                
                Text("From activity: ").font(.system(size: 15)).foregroundColor(Color.appSecondary) + Text("\(Int(healthStore.activeCalories)) kcal").font(.system(size: 15)).bold()
            }.padding(.top,3)
        }
        
        HStack{
            VStack {
                Image("walking")
                    .resizable()
                    .frame(width: 160, height: 110)
                
                VStack{
                    Text("Step Count:").font(.headline).foregroundColor(.white)
                    Text("\(Int(healthStore.steps))").font(.title2).foregroundColor(.white)
                }.padding(.vertical,3)
            }
            .background(Color.appPrimary)
            .cornerRadius(10)
            .shadow(color:Color.appSecondary.opacity(0.3),radius: 10)
            Spacer()
            
            VStack {
                Image("steps")
                    .resizable()
                    .frame(width: 160, height: 110)
                
                VStack{
                    Text("Flights Climbed:").font(.headline).foregroundColor(.white)
                    Text("\(Int(healthStore.flights))").font(.title2).foregroundColor(.white)
                }.padding(.vertical,3)
            }
            .background(Color.appSecondary)
            .cornerRadius(10)
            .shadow(color:Color.appSecondary.opacity(0.3),radius: 10)
            
            
            
        }
    }
}

#Preview {
    let mockGoalVM = UserViewModel()
    
    AdditionsView()
        .environmentObject(mockGoalVM)
}
