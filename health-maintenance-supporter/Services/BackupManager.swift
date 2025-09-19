//
//  BackupManager.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-15.
//

import Foundation
import FirebaseFirestore
import BackgroundTasks
import UIKit
import SwiftData


class BackupManager {
    static let shared = BackupManager()
    private init() {}
    
    private let taskIdentifier = "com.fitzy.hourlyBackup"
    private var isBackgroundTaskAvailable = false
    
    var userViewModel: UserViewModel?
    var context: ModelContext?
    
    private var healthStore = HealthStore()
    
    // MARK: - Register
    func registerBackgroundTask() {
        #if targetEnvironment(simulator)
        setupForegroundBackupFallback()
        return
        #endif
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: taskIdentifier,
            using: nil
        ) { task in
            self.handleBackupTask(task: task as! BGAppRefreshTask)
        }
        
        isBackgroundTaskAvailable = true
        print("INFO: Background task registered successfully")
    }
    
    // MARK: - Schedule
    func scheduleBackupTask() {
        guard isBackgroundTaskAvailable else {
            print("ERR: Background tasks unavailable, using foreground fallback")
            return
        }
        
        //cancel existing pending tasks
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskIdentifier)
        
        let request = BGAppRefreshTaskRequest(identifier: taskIdentifier)
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60*60) // 1 hour
        
        do {
            try BGTaskScheduler.shared.submit(request)
            print("INFO: Backup task scheduled successfully")
        } catch {
            print("ERR: Failed to schedule backup task: \(error)")
            handleSchedulingError(error)
        }
    }
    
    // MARK: - Handle Scheduling Errors
    private func handleSchedulingError(_ error: Error) {
        if let bgError = error as? BGTaskScheduler.Error {
            switch bgError.code {
            case .unavailable:
                isBackgroundTaskAvailable = false
                setupForegroundBackupFallback()
            case .tooManyPendingTaskRequests:
                print("Err: Too many pending task requests")
                cancelAllPendingTasks()
            case .notPermitted:
                print("Err: Background app refresh is disabled in Settings")
                showBackgroundRefreshAlert()
            @unknown default:
                print("Err: Unknown BGTaskScheduler error: \(bgError)")
            }
        }
    }
    
    // MARK: - Handle Background Task
    func handleBackupTask(task: BGAppRefreshTask) {
        print("Handling background backup task")
        
        task.expirationHandler = {
            print("Backup task expired")
            task.setTaskCompleted(success: false)
        }
        
        uploadBackup { success in
            print(success ? "SUCCESS: Background backup completed" : "ERR: Background backup failed")
            task.setTaskCompleted(success: success)
        }
        
        //schedule next backup
        scheduleBackupTask()
    }
    
    // MARK: - Foreground Backup Fallback
    private func setupForegroundBackupFallback() {
        Timer.scheduledTimer(withTimeInterval: 3600, repeats: true) { _ in
            if UIApplication.shared.applicationState == .active {
                self.performForegroundBackup()
            }
        }
        print("INF: Foreground backup fallback activated")
    }
    
    private func performForegroundBackup() {
        uploadBackup { success in
            print(success ? "SUCCES: Foreground backup completed" : "ERR: Foreground backup failed")
        }
    }
    
    
    // MARK: - Upload Backup
    func uploadBackup(completion: @escaping (Bool) -> Void) {       // this background task will backup activity in the background
        Task { @MainActor in
            guard let email = userViewModel?.currentUser.email, !email.isEmpty else {
                print("ERR: No email available for backup ID")
                completion(false)
                return
            }
            
            // Use today's date
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let todayString : String = formatter.string(from: Date())
            
            let backupId = "\(todayString)-\(email)"
            
            // Fetch today's report, or create a TEST one
            guard let context = self.context else {
                print("ERR: No context available for backup")
                completion(false)
                return
            }
            
            
            let report = DailyReportManager.getTodayReport(context: context) ?? DailyReport(date: Date(), calorieTotal: 0, stepsTotal: 0, waterTotal: 0, distanceTotal: 0, macrosTotal: Macro(carbs: 0, protein: 0, fats: 0), taskCompletion: 0)

            let reportData: [String: Any] = [
                "email": email,
                "dateString": report.dateString,
                "calorieTotal": report.calorieTotal,
                "stepsTotal": healthStore.steps,
                "waterTotal": report.waterTotal,
                "distanceTotal": healthStore.distance,
                "macrosTotal": [
                    "carbs": report.macrosTotal.carbs,
                    "protein": report.macrosTotal.protein,
                    "fats": report.macrosTotal.fats
                ],
                "taskCompletion": report.taskCompletion,
                "backupType": isBackgroundTaskAvailable ? "background" : "foreground",
                "timestamp": Timestamp()
            ]
            
            let db = Firestore.firestore()
            db.collection("dailyReports")
                .document(backupId)
                .setData(reportData, merge: true) { error in
                    if let error = error {
                        print("ERR: Backup upload failed: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("SUCCESS: Backup stored for \(backupId)")
                        completion(true)
                    }
                }
        }
    }


    
    // MARK: - Utility Methods
    func cancelAllPendingTasks() {
        BGTaskScheduler.shared.cancel(taskRequestWithIdentifier: taskIdentifier)
    }
    
    private func showBackgroundRefreshAlert() {
        DispatchQueue.main.async {
            print("💡 Consider showing user alert to enable Background App Refresh in Settings")
        }
    }
    
    
    // MARK: - Status Check
    func getBackupStatus() -> String {
        if isBackgroundTaskAvailable {
            return "Background tasks enabled"
        } else {
            #if targetEnvironment(simulator)
            return "Simulator mode - using foreground fallback"
            #else
            return "Background tasks unavailable - using foreground fallback"
            #endif
        }
    }
}
