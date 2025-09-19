//
//  DailyGoals.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-15.
//

import SwiftUI

struct DailyGoals: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @EnvironmentObject var goalViewModel: GoalsViewModel

    var goals: [String]? {
        guard let specialTargets = userViewModel.goal?.specialTargets else { return nil }
        return specialTargets.map { key, value in
            "\(formatKey(key)): \(value)"
        }
    }

    func formatKey(_ key: String) -> String {
        key.replacingOccurrences(of: "_", with: " ")
            .capitalized
    }
    
    var body: some View {
        ScrollView {
            Text("Your Other Tasks Today")
                .font(.title3)
                .bold()
                .foregroundColor(.appPrimary)
            
            VStack(spacing: 5) {
                if let targets = goals, !targets.isEmpty {
                    ForEach(targets, id: \.self) { target in
                        GlassCard {
                            HStack {
                                Text(target)
                                Spacer()
                                if goalViewModel.dailyGoals.contains(target) {
                                    Button("", systemImage: "minus.circle.fill", role:.destructive){
                                        goalViewModel.removeGoal(target)
                                    }.font(.system(size: 40))
                                } else {
                                    Button("", systemImage: "plus.circle.fill"){
                                        goalViewModel.addCompletedGoal(target)
                                    }.foregroundColor(Color.appGreen)
                                        .font(.system(size: 40)) 
                                }
                            }
                        }
                    }
                } else {
                    Text("No daily goals")
                        .foregroundColor(.secondary)
                        .padding()
                }
            }
            .padding()
        }
    }
}

