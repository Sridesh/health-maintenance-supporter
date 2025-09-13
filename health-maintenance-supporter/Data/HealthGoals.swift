//
//  HealthGoals.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//

import Foundation

struct FitnessPlan {
    let id : Int
    let goal: String
    let description: String
    let dailyTargets: DailyTargets
    let specialTargets: [String: Any] // flexible, since keys differ
}

struct DailyTargets {
    let calories: Int
    let macros: Macros
    let water: Double
    let steps: Int
    let distance: Int
}

struct Macros {
    let protein: Int
    let carbs: Int
    let fats: Int
}

let fitnessPlans: [FitnessPlan] = [
    FitnessPlan(
        id: 1,
        goal: "Fat Loss / Weight Reduction",
        description: "Reduce overall body fat percentage and weight through a calorie deficit while preserving muscle mass.",
        dailyTargets: DailyTargets(
            calories: 2000,
            macros: Macros(protein: 140, carbs: 180, fats: 55),
            water: 3.2,
            steps: 10000,
            distance: 8
        ),
        specialTargets: [
            "cardio_minutes": 40,
            "strength_training_sessions": 3,
            "fiber_g": 30
        ]
    ),
    FitnessPlan(
        id: 2,
        goal: "Lean Muscle Gain (Body Recomposition)",
        description: "Build lean muscle while minimizing fat gain by using a slight calorie surplus and progressive strength training.",
        dailyTargets: DailyTargets(
            calories: 2400,
            macros: Macros(protein: 150, carbs: 250, fats: 60),
            water: 3.5,
            steps: 9000,
            distance: 7
        ),
        specialTargets: [
            "strength_training_sessions": 5,
            "stretching_minutes": 10,
            "creatine_g": 5
        ]
    ),
    FitnessPlan(
        id: 3,
        goal: "Muscle Mass Gain (Bulking)",
        description: "Maximize muscle growth through a clean bulk, prioritizing hypertrophy and strength training.",
        dailyTargets: DailyTargets(
            calories: 2800,
            macros: Macros(protein: 140, carbs: 350, fats: 70),
            water: 4.0,
            steps: 8000,
            distance: 6
        ),
        specialTargets: [
            "strength_training_sessions": 6,
            "cardio_minutes": 10,
            "recovery_hrs": 8
        ]
    ),
    FitnessPlan(
        id: 4,
        goal: "Cholesterol Reduction / Heart Health",
        description: "Lower LDL cholesterol, improve HDL, and enhance cardiovascular health through diet and regular aerobic exercise.",
        dailyTargets: DailyTargets(
            calories: 2100,
            macros: Macros(protein: 130, carbs: 200, fats: 55),
            water: 3.0,
            steps: 10000,
            distance: 8
        ),
        specialTargets: [
            "cardio_minutes": 45,
            "strength_training_sessions": 3,
            "fiber_g": 30
        ]
    ),
    FitnessPlan(
        id: 5,
        goal: "Diabetes / Blood Sugar Control",
        description: "Regulate blood sugar and improve insulin sensitivity with controlled carbohydrate intake, strength training, and post-meal activity.",
        dailyTargets: DailyTargets(
            calories: 2000,
            macros: Macros(protein: 140, carbs: 180, fats: 55),
            water: 3.0,
            steps: 11000,
            distance: 9
        ),
        specialTargets: [
            "strength_training_sessions": 4,
            "post_meal_walk_minutes": 15,
            "fiber_g": 35
        ]
    ),
    FitnessPlan(
        id: 6,
        goal: "Mental Wellness / Stress Management",
        description: "Reduce stress, improve mental clarity, and promote restful sleep with mindfulness, journaling, and movement.",
        dailyTargets: DailyTargets(
            calories: 2000,
            macros: Macros(protein: 120, carbs: 220, fats: 60),
            water: 3.0,
            steps: 7000,
            distance: 5
        ),
        specialTargets: [
            "mindfulness_minutes": 15,
            "journaling_minutes": 5,
            "screen_time_hours": 2
        ]
    ),
    FitnessPlan(
        id: 7,
        goal: "Endurance / Athletic Performance",
        description: "Optimize stamina, VO₂ max, and recovery with structured cardio and strength training.",
        dailyTargets: DailyTargets(
            calories: 2600,
            macros: Macros(protein: 140, carbs: 320, fats: 60),
            water: 3.5,
            steps: 12000,
            distance: 10
        ),
        specialTargets: [
            "cardio_minutes": 60,
            "strength_training_sessions": 3,
            "recovery_minutes": 15
        ]
    ),
    FitnessPlan(
        id: 8,
        goal: "Immunity & Longevity",
        description: "Promote long-term health with nutrient-rich food, activity, stress management, and good sleep habits.",
        dailyTargets: DailyTargets(
            calories: 2100,
            macros: Macros(protein: 130, carbs: 220, fats: 60),
            water: 3.2,
            steps: 9000,
            distance: 7
        ),
        specialTargets: [
            "sun_exposure_minutes": 15,
            "alcohol_limit_units": 1
        ]
    ),
    FitnessPlan(
        id: 9,
        goal: "Micro Goals / Daily Habits",
        description: "Small, easy-to-follow habits to improve adherence, posture, and overall lifestyle balance.",
        dailyTargets: DailyTargets(
            calories: 2000,
            macros: Macros(protein: 130, carbs: 200, fats: 55),
            water: 3.0,
            steps: 7000,
            distance: 5
        ),
        specialTargets: [
            "posture_resets": 3,
            "breathing_exercises": 5,
            "hydration_sips": 12,
            "digital_detox_hours": 1
        ]
    )
]
