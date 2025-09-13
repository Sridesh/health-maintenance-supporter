//
//  GoalViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//

import SwiftUI

@MainActor
final class GoalsViewModel: ObservableObject {
    @Published var goals: Macros
    @Published var waterIntake: Double
    @Published var steps: Int
    @Published var totalCalories: Int
    
    init(
        goals: Macros = Macros(protein: 0, carbs: 0, fats: 0),
        waterIntake: Double = 0.0,
        steps: Int = 0,
        totalCalories: Int = 0
    ) {
        self.goals = goals
        self.waterIntake = waterIntake
        self.steps = steps
        self.totalCalories = totalCalories
    }
    
    func addWaterIntake(intake: Double) {
        self.waterIntake += intake
    }

    func removeWaterIntake(intake: Double) {
        if self.waterIntake > intake {
            self.waterIntake -= intake
        } else {
            self.waterIntake = 0
        }
    }

}
