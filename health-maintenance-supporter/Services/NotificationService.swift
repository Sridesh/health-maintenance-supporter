//
//  NotificationService.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-15.
//

import SwiftUI
import UserNotifications

final class NotificatioNService {
    
    func scheduleWaterReminder() {
        let content = UNMutableNotificationContent()
        content.title = "Time to drink water"
        content.subtitle = "Keep hydrated! Your goal isn’t reached yet."
        content.sound = UNNotificationSound.default
        

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60*30, repeats: true)     //notification repeating every 30 mins
        
        let request = UNNotificationRequest(identifier: "waterReminder",
                                            content: content,
                                            trigger: trigger)
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            } else {
                print("SUCCESS: Notification scheduled!")
            }
        }
    }
    
    func stopWaterReminder() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["waterReminder"])
        print("DEBUG: Water reminder stopped")
    }
}
