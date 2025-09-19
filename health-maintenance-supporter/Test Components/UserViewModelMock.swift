//
//  UserViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-19.
//


import Foundation
import SwiftUI

final class UserViewModelMock: ObservableObject {
    @Published var currentUser = UserType(
        name: "Test",
        email: "test@test.com",
        isMale: true,
        age: 25,
        weight: 66,
        height: 160,
        goalId: 1,
        onboarded: true
    )
    
    @Published var goal: FitnessPlan? = FitnessPlan(id: 1, goal: "Test Goal", description: "Test description", dailyTargets: DailyTargets(calories: 10, macros: Macros(protein: 10, carbs: 10, fats: 10), water: 10, steps: 1000, distance: 1000), specialTargets: ["Test task 1":10, "Test task 2":10])
}
