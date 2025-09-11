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
//    let formatter = DateFormatter()
//    formatter.dateFormat = "MMMM d, yyyy"  // Full month name
//    let todayString = formatter.string(from: Date())
        
        var body: some View {
            ZStack{
                VStack{
                    VStack{
                        
                    }.frame(maxWidth: .infinity)
                        .frame(height:150)
                        .background(
                            LinearGradient(colors: [.blue.opacity(0.15), .purple.opacity(0.15)], startPoint: .leading , endPoint: .trailing)
                        )
                } .frame(maxHeight: .infinity, alignment: .top)
                VStack(spacing: 20) {
                    HStack{
                        
                        Image(systemName: "figure.walk")
                            .foregroundColor(Color.white)
                            .padding(6)
                            .frame(width: 30)
                            .background(
                                LinearGradient(colors: [.blue, .purple], startPoint: .topLeading , endPoint: .bottomTrailing)
                            )
                            .cornerRadius(5)
                        
                        
                        
                        VStack{
                            Text("Your Activity Today")
                                .font(.headline)
                            //                      Text("Date•\(Date(), formatter: {
                            Text("Date • ").font(.caption) +
                            Text(Date(), formatter: {
                                let formatter = DateFormatter()
                                formatter.dateFormat = "MMMM d, yyyy"
                                return formatter
                            }()).font(.caption)
                            
                        }
                    }.frame(maxWidth: .infinity, alignment: .leading)
                    
                    
                    
                    
                    
                    
                    
                    
                    VStack {
                        //                        Image("steps")
                        //                            .resizable()
                        //                            .frame(width: 40, height: 40)
                        //
                        //                        Text("Steps:").font(.headline)
                        //                        Spacer()
                        //                        Text("\(Int(healthStore.steps))")
                        
                        HStack{
                            
                            Image(systemName: "flame")
                                .foregroundColor(Color.white)
                                .padding(6)
                                .frame(width: 30)
                                .background(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .cyan]),
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
                                .foregroundColor(Color.gray.opacity(0.2))
                                .cornerRadius(4)
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [.blue, .cyan]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 340 * 0.5, height: 7)
                                .cornerRadius(4)
                            
                        }.frame(height: 7)
                        
                        HStack{
                            Text("At rest: ").font(.caption).font(.caption).foregroundColor(Color.gray) +
                            Text("\(Int(healthStore.activeCalories)) kcal").font(.caption).bold()
                            
                            Spacer()
                            
                            Text("From activity: ").font(.caption).foregroundColor(Color.gray) + Text("\(Int(healthStore.activeCalories)) kcal").font(.caption).bold()
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(color:Color.gray.opacity(0.2),radius: 10)
                    
                    
                    HStack{
                        VStack {
                            Image("walking")
                                .resizable()
                                .frame(width: 180, height: 110)
                            
                            VStack{
                                Text("Step Count:").font(.headline).padding(.bottom, 3)
                                Text("\(Int(healthStore.steps))").font(.title2)
                            }.padding(.vertical,3)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color:Color.gray.opacity(0.2),radius: 10)
                        Spacer()
                        
                        VStack {
                            Image("steps")
                                .resizable()
                                .frame(width: 180, height: 110)
                            
                            VStack{
                                Text("Flights Climbed:").font(.headline).padding(.bottom, 3)
                                Text("\(Int(healthStore.flights))").font(.title2)
                            }.padding(.vertical,3)
                        }
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color:Color.gray.opacity(0.2),radius: 10)
                        
                        
                        
                    }
                    
                    
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
                    }.padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(color:Color.gray.opacity(0.2),radius: 10)
                    
                    VStack{
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
                        
                    }.background(Color.white)
                        .cornerRadius(10)
                        .shadow(color:Color.gray.opacity(0.2),radius: 10)
                }
                
                .frame(maxHeight: .infinity, alignment: .top)
                .padding()
//                .background(Color(hex: "#fff1ed"))
              
            }
            
        }
}

#Preview {
    HealthView()
}
