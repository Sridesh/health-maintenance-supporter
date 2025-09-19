//
//  DailyReportManager.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-16.
//

import SwiftUI
import SwiftData
import Firebase

@MainActor
struct DailyReportManager {
    static func getTodayReport(context: ModelContext) -> DailyReport { // get daily report for today
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let todayString = formatter.string(from: Date())
        
        let fetchDescriptor = FetchDescriptor<DailyReport>(
            predicate: #Predicate<DailyReport> { $0.dateString == todayString }
        )
        
        if let existing = try? context.fetch(fetchDescriptor).first {
            print("SUCCESS: Found a daily report for today")
            return existing
        } else {
            print("INFO: Did not found a daily report for today")
            let newReport = DailyReport(
                date: Date(),
                calorieTotal: 0,
                stepsTotal: 0,
                waterTotal: 0,
                distanceTotal: 0,
                macrosTotal: Macro(carbs: 0, protein: 0, fats: 0),
                taskCompletion: 0
            )
            context.insert(newReport)
            
            do { try context.save() } catch {
                print("ERR: Failed to save DailyReport: \(error)") }
            
            return newReport
        }
    }

    static func hasReportsBeforeToday(context: ModelContext) -> Bool {      //check if there are any pasts reports which haven'r been backed up
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let todayString = formatter.string(from: Date())
        
        let descriptor = FetchDescriptor<DailyReport>(
            predicate: #Predicate { $0.dateString < todayString }
        )
        
        do {
            let results = try context.fetch(descriptor)
            return !results.isEmpty
        } catch {
            print("ERR: Failed to fetch DailyReports: \(error)")
            return false
        }
    }
    
    
    static func backupOldReports(context: ModelContext, email:String,  completion: @escaping (Bool) -> Void) {      // back up found old reports
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todayString = formatter.string(from: Date())
            
            let descriptor = FetchDescriptor<DailyReport>(
                predicate: #Predicate { $0.dateString < todayString }
            )
            
            do {
                let oldReports = try context.fetch(descriptor)
                guard !oldReports.isEmpty else {
                    print("No reports to backup")
                    completion(true)
                    return
                }
                
                let db = Firestore.firestore()
                backupReportsSequentially(oldReports, context: context, db: db, index: 0, email: email, completion: completion)
                
            } catch {
                print("Failed to fetch DailyReports: \(error)")
                completion(false)
            }
        }
        
        private static func backupReportsSequentially(      //back up found old reports and delete them from core data
            _ reports: [DailyReport],
            context: ModelContext,
            db: Firestore,
            index: Int,
            email: String,
            completion: @escaping (Bool) -> Void
        ) {
            guard index < reports.count else {
                completion(true)
                return
            }
            
            let report = reports[index]
            
            // Convert report → dictionary for Firestore
            let reportData: [String: Any] = [
                "email":email,
                "dateString": report.dateString,
                "calorieTotal":report.calorieTotal,
                "stepsTotal": report.stepsTotal,
                "waterTotal": report.waterTotal,
                "distanceTotal":  report.distanceTotal,
                "macrosTotal": [
                        "carbs": report.macrosTotal.carbs,
                        "protein": report.macrosTotal.protein,
                        "fats": report.macrosTotal.fats
                    ],
                "taskCompletion": report.taskCompletion,
            ]
            
            print("Uploading report: \(reportData)")
            
            db.collection("dailyReports")
                .document("\(report.dateString)_\(email)") //unique key by date
                .setData(reportData) { error in
                    if let error = error {
                        print("Failed to backup report \(report.dateString): \(error)")
                        completion(false)
                    } else {
                        print("Backed up report \(report.dateString)")
                        
                        //delete from core data  if backup succeed
                        context.delete(report)
                        do {
                            try context.save()
                        } catch {
                            print("Failed to delete after backup: \(error)")
                        }

                        backupReportsSequentially(reports, context: context, db: db, index: index + 1, email: email, completion: completion)
                    }
                }
        }
    
    static func fetchDailyReportsLastWeek(email: String, completion: @escaping ([DailyReport]) -> Void) {       // fetch historical backedup data from fire base for last week
        let db = Firestore.firestore()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = .current
        
        let today = Date()
        let calendar = Calendar.current
        guard let weekAgo = calendar.date(byAdding: .day, value: -6, to: today) else {
            completion([])
            return
        }
        
        let todayString = formatter.string(from: today)
        let weekAgoString = formatter.string(from: weekAgo)
        
        db.collection("dailyReports")
            .whereField("email", isEqualTo: email)      // verification for email to avoid other's reports
            .whereField("dateString", isGreaterThanOrEqualTo: weekAgoString)
            .whereField("dateString", isLessThanOrEqualTo: todayString)
            .order(by: "dateString", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching reports: \(error.localizedDescription)")
                    completion([])
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    completion([])
                    return
                }
                
                var reports: [DailyReport] = []
                
                for doc in documents {
                    let data = doc.data()
                    
                    let dateString = data["dateString"] as? String ?? formatter.string(from: today)
                    let calorieTotal = data["calorieTotal"] as? Int ?? 0
                    let stepsTotal = data["stepsTotal"] as? Int ?? 0
                    let waterTotal = data["waterTotal"] as? Int ?? 0
                    let distanceTotal = data["distanceTotal"] as? Int ?? 0
                    
                    let macrosDict = data["macrosTotal"] as? [String: Int] ?? [:]
                    let macros = Macro(
                        carbs: Double(macrosDict["carbs"] ?? 0),
                        protein: Double(macrosDict["protein"] ?? 0 ),
                        fats: Double(macrosDict["fats"] ?? 0)
                    )
                    
                    let report = DailyReport(
                        date: formatter.date(from: dateString) ?? today,
                        calorieTotal: calorieTotal,
                        stepsTotal: stepsTotal,
                        waterTotal: waterTotal,
                        distanceTotal: distanceTotal,
                        macrosTotal: macros,
                        taskCompletion: data["taskCompletion"] as? Double ?? 0
                    )
                    
                    reports.append(report)
                }
                
                completion(reports)
            }
    }
}
