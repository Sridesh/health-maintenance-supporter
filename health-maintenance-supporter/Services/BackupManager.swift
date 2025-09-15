//
//  BackupManager.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-15.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth
import UserNotifications
import BackgroundTasks

class BackupManager {
    static let shared = BackupManager()
    
    private init() {}
    
    func uploadBackup(completion: @escaping (Bool) -> Void) {
        let db = Firestore.firestore()
        let backupData: [String: Any] = [
            "timestamp": Timestamp(),
            "data": "Example backup data"
        ]
        
        db.collection("backups").addDocument(data: backupData) { error in
            if let error = error {
                print("Backup failed: \(error)")
                completion(false)
            } else {
                print("Backup uploaded successfully!")
                completion(true)
            }
        }
    }
    
    func handleBackupTask(task: BGAppRefreshTask) {
        BackupManager.shared.scheduleBackupTask() // reschedule next
        
        task.expirationHandler = {
            print("Backup task expired!")
        }
        
        DispatchQueue.global().async {
            BackupManager.shared.uploadBackup { success in
                task.setTaskCompleted(success: success)
            }
        }
    }
    
    func scheduleBackupTask() {
        let request = BGAppRefreshTaskRequest(identifier: "com.myapp.hourlyBackup")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(request)
            print("Backup task scheduled!")
        } catch {
            print("Failed to schedule backup task: \(error)")
        }
    }
}
