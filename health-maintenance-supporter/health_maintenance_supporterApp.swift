//
//  health_maintenance_supporterApp.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-02.
//

import SwiftUI
import SwiftData
import Firebase
import FirebaseAuth
import UserNotifications
import BackgroundTasks

@main
struct health_maintenance_supporterApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @StateObject private var authViewModel: AuthenticationViewModel
        @StateObject private var mealViewModel: MealsViewModel
        @StateObject private var foodItemViewModel: FoodItemViewModel
        @StateObject private var userViewModel: UserViewModel
        @StateObject private var goalViewModel: GoalsViewModel
        @StateObject private var activityViewModel: ActivityViewModel
    
        @StateObject private var healthStore = HealthStore()
    
    private let notificationService = NotificatioNService()

        
        let container: ModelContainer

    init() {
        FirebaseApp.configure()
        
        let modelContainer = try! ModelContainer(for:
            User.self,
            Meal.self,
            MealList.self,
            Food.self,
            Macro.self,
            Water.self,
            Activity.self
        )
        self.container = modelContainer
        
        _authViewModel = StateObject(wrappedValue: AuthenticationViewModel(context: modelContainer.mainContext))
        _mealViewModel = StateObject(wrappedValue: MealsViewModel(context: modelContainer.mainContext))
        _foodItemViewModel = StateObject(wrappedValue: FoodItemViewModel(context: modelContainer.mainContext))
        
        let userVM = UserViewModel()
        _userViewModel = StateObject(wrappedValue: userVM)
        let notificationService = NotificatioNService()
        _goalViewModel = StateObject(wrappedValue: GoalsViewModel(
            context: modelContainer.mainContext,
            userViewModel: userVM,
            notificationService: notificationService
        ))
        _activityViewModel = StateObject(wrappedValue: ActivityViewModel(context: modelContainer.mainContext))
        
        BGTaskScheduler.shared.register(
            forTaskWithIdentifier: "com.myapp.hourlyBackup",
            using: nil
        ) { task in
            BackupManager.shared.handleBackupTask(task: task as! BGAppRefreshTask)
        }
        BackupManager.shared.scheduleBackupTask()
        
    }

    
    
    
    var body: some Scene {
        WindowGroup {
            VStack{
                if authViewModel.userSessionLogged && userViewModel.userOnboarded {
                    if authViewModel.isAuthenticated  {
                        TabsView()
                            .environmentObject(goalViewModel)
                            .environmentObject(userViewModel)
                            .environmentObject(authViewModel)
                            .environmentObject(mealViewModel)
                            .environmentObject(foodItemViewModel)
                            .environmentObject(activityViewModel)
                    } else {
                        FaceIDCollectionView()
                            .environmentObject(authViewModel)
                            .onAppear {
                                authViewModel.authenticateWithBiometrics()
                            }
                    }
                } else if authViewModel.userSessionLogged && !userViewModel.userOnboarded {
                    AdditionalDetails()
                        .environmentObject(userViewModel)
                        .environmentObject(authViewModel)
                }
                else {
                    SignInView()
                        .environmentObject(authViewModel)
                }
                
                    
            }.onAppear {
                Auth.auth().addStateDidChangeListener { auth, user in
                    if let email = user?.email {
                        userViewModel.setMail(email: email)
                        userViewModel.fetchUser(email: email)
                        userViewModel.userName = user?.displayName ?? "Sridesh"
                        authViewModel.userSessionLogged = true
                        
                        Task { @MainActor in
                            activityViewModel.updateTodayActivity(
                                steps: Int(healthStore.steps),
                                distance: healthStore.distance,
                                burn: Int(healthStore.activeCalories + healthStore.basalCalories)
                            )
                        }
                    }
                }
                
                notificationService.scheduleWaterReminder()
            }
        }
    }
    
    

}

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                print("Permission granted")
            }
        }
        center.delegate = self
        return true
    }
    
    // Show notification even in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound])
    }
}




