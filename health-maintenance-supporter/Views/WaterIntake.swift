//
//  WaterIntake.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-14.
//

import SwiftUI
import Charts


struct WaterIntake: View {
    @EnvironmentObject var goalViewModel: GoalsViewModel
    @EnvironmentObject var userViewModel: UserViewModel
    
//    @EnvironmentObject var userViewModel: UserViewModelMock // for testing
    
    @State var isAddIntakeOpen = false
    @State var customValue = ""
    var waterProgress: CGFloat {
        guard let dailyGoal = userViewModel.goal?.dailyTargets.water, dailyGoal > 0 else { return 1 }
        return CGFloat((goalViewModel.waterIntake?.intake ?? 0) / dailyGoal)
    }
    @State private var animateProgress = false
    
    
    var body: some View {
        
        GlassCard {
            VStack {
                HStack(alignment: .top) {
                    ZStack {
                        Circle()
                            .fill(LinearGradient(colors: [Color.appPrimary, Color.appSecondary], startPoint: .top, endPoint: .bottomTrailing))
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
                            .foregroundStyle(Color.appSecondary)
                    }
                    Spacer()
                }
                .padding(.bottom, 6)
                
                HStack(spacing: 24) {
                    //progress Circle
                    ZStack {
                        Circle()
                            .stroke(Color.appBlue.opacity(0.2), lineWidth: 12)
                        Circle()
                            .trim(from: 0, to: animateProgress ? waterProgress : 0)
                            .stroke(
                                LinearGradient(colors: [Color.appSecondary, Color.appPrimary], startPoint: .top, endPoint: .bottomTrailing),
                                style: StrokeStyle(lineWidth: 12, lineCap: .round)
                            )
                            .rotationEffect(.degrees(-90))
                            .animation(.easeOut(duration: 1.2), value: animateProgress)
                        
                        VStack(spacing: 2) {
                            Text("\(Int(waterProgress * 100))%")
                                .font(.title2.bold())
                                .foregroundColor(.appPrimary)
                            Text(String(format: "%.1fL", goalViewModel.waterIntake?.intake ?? 0))
                                .font(.caption2)
                                .foregroundColor(.appSecondary)
                        }
                    }
                    .frame(width: 90, height: 90)
                    .onAppear { animateProgress = true }
                    .accessibilityLabel("Water intake")
                    
                    //intake Buttons
                    VStack(alignment: .leading, spacing: 10) {
                        Text("Next sip in 12 min")
                            .foregroundColor(Color.appPrimary)
                            .bold()
                        
                        HStack(spacing: 12) {
                            IntakeButton(title: "-70ml", color: Color.appYellow.opacity(0.25), border: Color.appYellow)
                                .onTapGesture {
                                    goalViewModel.removeWaterIntake(amount: 0.07) // in liters
                                }
                                .accessibilityLabel("Add water intake")
                                .accessibilityHint("Adds 70ml of water to your daily goal")
                            IntakeButton(title: "+70ml", color: Color.appGreen.opacity(0.25), border: Color.appGreen)
                                .onTapGesture {
                                    goalViewModel.addWaterIntake(amount: 0.07)
                                }
                                .accessibilityLabel("Remove water intake")
                                .accessibilityHint("Removes 70ml of water to your daily goal")
                        }
                        
                        Divider().padding(.vertical)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Custom intake (ml)")
                                .font(.caption)
                                .bold()
                                .foregroundColor(Color.appSecondary)
                            HStack {
                                TextField("Amount", text: $customValue)
                                    .keyboardType(.numberPad)
                                    .padding(8)
                                    .background(Color(.systemGray6))
                                    .cornerRadius(8)
                                    .frame(width: 150)
                                    .onChange(of: customValue) { newValue in
                                        customValue = newValue.filter { "0123456789".contains($0) }
                                    }
                                Button {
                                    if let intakeMl = Double(customValue) {
                                        goalViewModel.addWaterIntake(amount: intakeMl / 1000) // convert to liters
                                        customValue = ""
                                    }
                                } label: {
                                    Image(systemName: "plus.circle.fill")
                                        .font(.title2)
                                        .foregroundColor((Int(customValue) ?? 0) > 0 ? .blue : .gray)
                                }
                                .disabled((Int(customValue) ?? 0) <= 0)
                            }
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }
}
