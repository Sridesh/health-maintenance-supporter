//
//  ActivityViewModel.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-14.
//

import SwiftUI
import SwiftData

@MainActor
final class ActivityViewModel: ObservableObject {
    private let context: ModelContext
    
    @Published var todayActivity: Activity?
    
    private var dailyReport : DailyReport
    
    init(context: ModelContext) {
        self.context = context
        dailyReport = DailyReportManager.getTodayReport(context: context)
        
        setupTodayActivity()   
    }
    
    //MARK: -  Fetch today's activity
    @MainActor
    private func setupTodayActivity() {
        print("Setting up today’s activity")
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: today)
        
        print("Looking for activity with dateString: \(todayString)")
        
        // Fetch existing Activity record for today
        let fetchDescriptor = FetchDescriptor<Activity>(
            predicate: #Predicate<Activity> { $0.dateString == todayString }
        )
        
        if let existing = try? context.fetch(fetchDescriptor).first {
            print("Found existing activity record for today")
            self.todayActivity = existing
        } else {
            print("Creating new activity record for today")
            
            let newActivity = Activity(date: today, steps: 0, distance: 0.0, burn: 0)
            context.insert(newActivity)
            
            do {
                try context.save()
                self.todayActivity = newActivity
                print("Successfully created and saved new activity record")
            } catch {
                print("Failed to save Activity: \(error)")
            }
        }
    }
    
    //MARK: -  update activity
    func updateTodayActivity(steps: Int? = nil, distance: Double? = nil, burn: Int? = nil) {
        print("Updating activity")
        guard let activity = todayActivity else {
            print("No activity record found for today")
            return
        }
        
        if let steps = steps {
            activity.steps = steps
            dailyReport.stepsTotal = steps
        }
        
        if let distance = distance {
            activity.distance = distance
            dailyReport.distanceTotal = Int(distance)
        }
        
        if let burn = burn {
            activity.burn = burn
            dailyReport.calorieTotal = max(dailyReport.calorieTotal - burn, 0)
        }
        
        do {
            try context.save()
            print("Successfully updated today's activity")
            // Notify SwiftUI that object changed
            objectWillChange.send()
        } catch {
            print("Failed to update today's activity: \(error)")
        }
    }
}
