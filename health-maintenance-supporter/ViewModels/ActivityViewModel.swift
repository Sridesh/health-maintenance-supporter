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
    
    init(context: ModelContext) {
        self.context = context
        fetchOrCreateTodayActivity()
    }
    
    //MARK: -  Fetch today's activity. If not found, create a new one.
    func fetchOrCreateTodayActivity() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        guard let tomorrow = calendar.date(byAdding: .day, value: 1, to: today) else {
            print("Error computing tomorrow's date")
            return
        }
    
        let descriptor = FetchDescriptor<Activity>(
            predicate: #Predicate { $0.date >= today && $0.date < tomorrow }
        )
        
        do {
            let activities = try context.fetch(descriptor)
            if let existing = activities.first {
                todayActivity = existing
            } else {
                // No record found, create a new default activity
                let newActivity = Activity(date: today, steps: 0, distance: 0.0, burn: 0)
                context.insert(newActivity)
                try context.save()
                todayActivity = newActivity
            }
        } catch {
            print("Error fetching/creating today's activity: \(error)")
        }
    }
    
    //MARK: -  Update values for today's activity
    func updateToday(steps: Int? = nil, distance: Double? = nil, burn: Int? = nil) {
        guard let activity = todayActivity else { return }
        
        if let steps = steps { activity.steps = steps }
        if let distance = distance { activity.distance = distance }
        if let burn = burn { activity.burn = burn }
        
        do {
            try context.save()
        } catch {
            print("Error saving updated activity: \(error)")
        }
    }
}
