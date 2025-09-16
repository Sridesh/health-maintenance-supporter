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
    static func getTodayReport(context: ModelContext) -> DailyReport {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let todayString = formatter.string(from: Date())
        
        let fetchDescriptor = FetchDescriptor<DailyReport>(
            predicate: #Predicate<DailyReport> { $0.dateString == todayString }
        )
        
        if let existing = try? context.fetch(fetchDescriptor).first {
            print("Found a daily report for today")
            return existing
        } else {
            print("Did not found a daily report for today")
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
            
            do { try context.save() } catch { print("Failed to save DailyReport: \(error)") }
            
            return newReport
        }
    }

    static func hasReportsBeforeToday(context: ModelContext) -> Bool {
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
            print("Failed to fetch DailyReports: \(error)")
            return false
        }
    }
    
    
    static func backupOldReports(context: ModelContext, email:String,  completion: @escaping (Bool) -> Void) {
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
        
        private static func backupReportsSequentially(
            _ reports: [DailyReport],
            context: ModelContext,
            db: Firestore,
            index: Int,
            email: String,
            completion: @escaping (Bool) -> Void
        ) {
            guard index < reports.count else {
                completion(true) // All backed up
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
                .document("\(report.dateString)_\(email)") // unique key by date
                .setData(reportData) { error in
                    if let error = error {
                        print("Failed to backup report \(report.dateString): \(error)")
                        completion(false)
                    } else {
                        print("Backed up report \(report.dateString)")
                        
                        // Delete from Core Data  if backup succeeded
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
    
    static func fetchDailyReportsLastWeek(completion: @escaping ([DailyReport]) -> Void) {
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
            .whereField("dateString", isGreaterThanOrEqualTo: weekAgoString)
            .whereField("dateString", isLessThanOrEqualTo: todayString)
            .order(by: "dateString", descending: false)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("❌ Error fetching reports: \(error.localizedDescription)")
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
    
//    static func fetchDailyReportsLastWeek(email: String, completion: @escaping ([DailyReport]) -> Void) {
//        let db = Firestore.firestore()
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        formatter.timeZone = TimeZone(secondsFromGMT: 0) // Use UTC for consistency
//        
//        let today = Date()
//        let calendar = Calendar.current
//        guard let weekAgo = calendar.date(byAdding: .day, value: -6, to: today) else {
//            print("❌ Failed to calculate week ago date")
//            completion([])
//            return
//        }
//        
//        let todayString = formatter.string(from: today)
//        let weekAgoString = formatter.string(from: weekAgo)
//        
//        // Generate all possible document IDs for the date range
//        var documentIds: [String] = []
//        var currentDate = weekAgo
//        
//        while currentDate <= today {
//            let dateString = formatter.string(from: currentDate)
//            let docId = "\(email)_\(dateString)"
//            documentIds.append(docId)
//            
//            guard let nextDay = calendar.date(byAdding: .day, value: 1, to: currentDate) else {
//                break
//            }
//            currentDate = nextDay
//        }
//        
//        print("🔍 Looking for documents: \(documentIds)")
//        
//        // Fetch documents by their compound IDs
//        let dispatchGroup = DispatchGroup()
//        var reports: [DailyReport] = []
//        var fetchErrors: [Error] = []
//        
//        for docId in documentIds {
//            dispatchGroup.enter()
//            
//            db.collection("dailyReports")
//                .document(docId)
//                .getDocument { snapshot, error in
//                    defer { dispatchGroup.leave() }
//                    
//                    if let error = error {
//                        print("❌ Error fetching document \(docId): \(error.localizedDescription)")
//                        fetchErrors.append(error)
//                        return
//                    }
//                    
//                    guard let document = snapshot,
//                          document.exists,
//                          let data = document.data() else {
//                        print("📄 No document found for \(docId)")
//                        return
//                    }
//                    
//                    // Parse the document data
//                    let dateString = data["dateString"] as? String ?? ""
//                    let calorieTotal = data["calorieTotal"] as? Int ?? 0
//                    let stepsTotal = data["stepsTotal"] as? Int ?? 0
//                    let waterTotal = data["waterTotal"] as? Int ?? 0
//                    let distanceTotal = data["distanceTotal"] as? Int ?? 0
//                    let taskCompletion = data["taskCompletion"] as? Double ?? 0.0
//                    
//                    // Parse macros - handle both Int and Double values
//                    let macrosDict = data["macrosTotal"] as? [String: Any] ?? [:]
//                    let carbs: Double
//                    let protein: Double
//                    let fats: Double
//                    
//                    if let carbsInt = macrosDict["carbs"] as? Int {
//                        carbs = Double(carbsInt)
//                    } else {
//                        carbs = macrosDict["carbs"] as? Double ?? 0.0
//                    }
//                    
//                    if let proteinInt = macrosDict["protein"] as? Int {
//                        protein = Double(proteinInt)
//                    } else {
//                        protein = macrosDict["protein"] as? Double ?? 0.0
//                    }
//                    
//                    if let fatsInt = macrosDict["fats"] as? Int {
//                        fats = Double(fatsInt)
//                    } else {
//                        fats = macrosDict["fats"] as? Double ?? 0.0
//                    }
//                    
//                    let macros = Macro(carbs: carbs, protein: protein, fats: fats)
//                    
//                    let report = DailyReport(
//                        date: formatter.date(from: dateString) ?? Date(),
//                        calorieTotal: calorieTotal,
//                        stepsTotal: stepsTotal,
//                        waterTotal: waterTotal,
//                        distanceTotal: distanceTotal,
//                        macrosTotal: macros,
//                        taskCompletion: taskCompletion
//                    )
//                    
//                    reports.append(report)
//                    print("✅ Successfully parsed report for \(dateString)")
//                }
//        }
//        
//        dispatchGroup.notify(queue: .main) {
//            // Sort reports by date (oldest first)
//            reports.sort { $0.date < $1.date }
//            
//            print("📊 Fetched \(reports.count) reports for last week")
//            if !fetchErrors.isEmpty {
//                print("⚠️ Encountered \(fetchErrors.count) errors during fetch")
//            }
//            
//            completion(reports)
//        }
//    }
}
