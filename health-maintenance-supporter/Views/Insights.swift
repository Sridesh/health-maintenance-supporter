//
//  Insights.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import Charts

struct NutritionCount {
    var category: String
    var count: Int
}

let byCategory: [NutritionCount] = [
    .init(category: "Fat", count: 79),
    .init(category: "Protein", count: 73),
    .init(category: "Carbs", count: 58),
    .init(category: "Fiber", count: 15),
    .init(category: "Sugar", count: 9)
]

struct InsightsView: View {
    @State var isAddIntakeOpen = false
    @State var customValue = ""
    @State private var waterProgress: CGFloat = 0.67
    @State private var animateProgress = false
    
    var body: some View {
        ZStack {
            
            LinearGradient(
                gradient: Gradient(colors: [Color(.systemBlue).opacity(0.13), Color(.systemPurple).opacity(0.10)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            
            // MARK: - content
            VStack(spacing: 20) {
                HStack{

                    VStack{
                        Text("Insight Tracker")
                            .font(.headline)
                            .padding(.top)
                            .padding(.horizontal, 30)
                    }
                }.frame(maxWidth: .infinity, alignment: .leading)
                
                GlassCard {
                    VStack{
                        HStack{
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [Color.blue, Color.purple], startPoint: .top, endPoint: .bottomTrailing))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "leaf.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                                
                            }
                            VStack{
                                Text("Nutritions")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .font(.headline)
                                Text("Today’s macros")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }.frame(maxWidth: .infinity, alignment: .leading)
                        }
                        VStack{
                            PieChart(data: byCategory)
                        }.frame(width: 250)
                    }
                }
  
                // MARK: - Water Intake
                GlassCard {
                    VStack{
                        HStack(alignment: .top) {
                            ZStack {
                                Circle()
                                    .fill(LinearGradient(colors: [Color.blue, Color.purple], startPoint: .top, endPoint: .bottomTrailing))
                                    .frame(width: 44, height: 44)
                                Image(systemName: "drop.fill")
                                    .foregroundColor(.white)
                                    .font(.title2)
                            }
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Water Intake")
                                    .font(.headline)
                                Text("Keep hydrated")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                        }
                        .padding(.bottom, 6)
                        
                        HStack(spacing: 24) {
                            // Animated Progress Circle
                            ZStack {
                                Circle()
                                    .stroke(Color.cyan.opacity(0.12), lineWidth: 12)
                                Circle()
                                    .trim(from: 0, to: animateProgress ? waterProgress : 0)
                                    .stroke(
                                        LinearGradient(colors: [Color.blue, Color.purple], startPoint: .top, endPoint: .bottomTrailing),
                                        style: StrokeStyle(lineWidth: 12, lineCap: .round)
                                    )
                                    .rotationEffect(.degrees(-90))
                                    .animation(.easeOut(duration: 1.2), value: animateProgress)
                                VStack(spacing: 2) {
                                    Text("\(Int(waterProgress * 100))%")
                                        .font(.title2.bold())
                                        .foregroundColor(.blue)
                                    Text("3.2L")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .frame(width: 90, height: 90)
                            .onAppear { animateProgress = true }
                            
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Next sip in 12 min")
                                    .font(.caption)
                                    .foregroundColor(.cyan)
                                    .bold()
                                
                                HStack(spacing: 12) {
                                    IntakeButton(title: "-70ml", color: .purple.opacity(0.15), border: .purple)
                                    IntakeButton(title: "+70ml", color: .blue.opacity(0.15), border: .blue)
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Custom intake (ml)")
                                        .font(.caption2)
                                        .foregroundColor(.secondary)
                                    HStack {
                                        TextField("Amount", text: $customValue)
                                            .keyboardType(.numberPad)
                                            .padding(8)
                                            .background(Color(.systemGray6))
                                            .cornerRadius(8)
                                            .frame(width: 70)
                                            .onChange(of: customValue) { newValue in
                                                customValue = newValue.filter { "0123456789".contains($0) }
                                            }
                                        Button {
                                            // Add custom intake action
                                        } label: {
                                            Image(systemName: "plus.circle.fill")
                                                .font(.title2)
                                                .foregroundColor((Int(customValue) ?? 0) > 50 ? .blue : .gray)
                                        }
                                        .disabled((Int(customValue) ?? 0) <= 50)
                                    }
                                }
                            }
                            Spacer()
                        }
                        .padding(.top, 8)
                        
                    }
                    
                
                 }
                
                
                
            }
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        }
        
    }}
#Preview {
    InsightsView()
}
