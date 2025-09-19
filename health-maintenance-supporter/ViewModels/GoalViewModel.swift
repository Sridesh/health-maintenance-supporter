//
//  GoalViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-13.
//

import SwiftUI
import SwiftData

@MainActor
final class GoalsViewModel: ObservableObject {
    private var context: ModelContext
    
    @Published var waterIntake: Water?
    @Published var dailyGoals: [String] = []
    @Published var completedPctg: Int = 0
    
    private let notificationService: NotificatioNService
    private let userViewModel : UserViewModel
    
    private var dailyReport : DailyReport
    
    init(context: ModelContext, userViewModel: UserViewModel, notificationService: NotificatioNService) {
        self.context = context
        self.userViewModel = userViewModel
        self.notificationService = notificationService
        
        dailyReport = DailyReportManager.getTodayReport(context: context)
        
        setupWaterIntake()
    }
    
    // MARK: - Setup today's water intake
    private func setupWaterIntake() {
        print("INFO: Setting up today’s water intake")
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)

        
        //fetch existing water record for today
        let fetchDescriptor = FetchDescriptor<Water>(
            predicate: #Predicate<Water> { $0.dateString == todayString }
        )
        
        if let existing = try? context.fetch(fetchDescriptor).first {
            print("SUCCESS: Found existing water record for today")
            self.waterIntake = existing
        } else {
            print("INFO: Creating new water record for today")
            
            let newWater = Water(date: today, intake: 0)
            context.insert(newWater)
            
            do {
                try context.save()
                self.waterIntake = newWater
                print("SUCCESS: Successfully created new water record")
            } catch {
                print("ERR: Failed to save Water: \(error)")
            }
        }
    }
    
    // MARK: - Add water intake
    func addWaterIntake(amount: Double) {
        guard let water = waterIntake else { return }
        water.intake += amount
        
        dailyReport.waterTotal += Int(amount)

        if waterIntake?.intake ?? 0 > userViewModel.goal?.dailyTargets.water ?? 0 {     // conditional stopping for push notification
            notificationService.stopWaterReminder()
        } 
        save()
    }
    
    // MARK: - Remove water intake
    func removeWaterIntake(amount: Double) {
        guard let water = waterIntake else { return }
        let actualRemoved = min(amount, water.intake) // avoid negative
            water.intake -= actualRemoved

        dailyReport.waterTotal = max(dailyReport.waterTotal - Int(actualRemoved), 0)
        
        if waterIntake?.intake ?? 0 < userViewModel.goal?.dailyTargets.water ?? 0 {     //conditional starting of push notification
            notificationService.scheduleWaterReminder()
        }
        save()
    }
    
    // MARK: - Save context helper
    private func save() {
        do {
            try context.save()
        } catch {
            print("ERR: Failed to save Water intake: \(error)")
        }
    }
    
    // MARK: - Add a daily goal
    func addCompletedGoal(_ goal: String) {
            if !dailyGoals.contains(goal) {
                dailyGoals.append(goal)
            }
        
        dailyReport.taskCompletion  = Double(dailyGoals.count /  (userViewModel.goal?.specialTargets.count ?? 1))
        }
    
    // MARK: - Remove a daily goal
    func removeGoal(_ goal: String) {
        dailyGoals.removeAll { $0 == goal }
        
        dailyReport.taskCompletion  = Double(dailyGoals.count /  (userViewModel.goal?.specialTargets.count ?? 1))
        }
    
    // MARK: - Reset on logout
    func onLogout() {
            if let water = waterIntake {
                context.delete(water)
                waterIntake = nil
            }
            
            // Reset daily goals
            dailyGoals.removeAll()
            completedPctg = 0
            
            // Reset daily report
            dailyReport = DailyReport(
                date: Date(),
                calorieTotal: 0,
                stepsTotal: 0,
                waterTotal: 0,
                distanceTotal: 0,
                macrosTotal: Macro(carbs: 0, protein: 0, fats: 0),
                taskCompletion: 0
            )
            
            //Stopwater reminders
            notificationService.stopWaterReminder()

            do {
                try context.save()
                print("GoalsViewModel: All data reset successfully.")
            } catch {
                print("GoalsViewModel: Failed to reset data: \(error)")
            }
        }
}
