////
////  AcitivityTests.swift
////  health-maintenance-supporter
////
////  Created by Sridesh 001 on 2025-09-19.
////
//
//
//import XCTest
//import SwiftData
//import SwiftUI
//@testable import health_maintenance_supporter
//
//@MainActor
//final class ActivityViewModelTests: XCTestCase {
//    
//    var modelContainer: ModelContainer!
//    var context: ModelContext!
//    var viewModel: ActivityViewModel!
//    
//    override func setUpWithError() throws {
//        try super.setUpWithError()
//        
//        // Create an in-memory model container for testing
//        let config = ModelConfiguration(isStoredInMemoryOnly: true)
//        modelContainer = try ModelContainer(for: Activity.self, DailyReport.self, configurations: config)
//        context = modelContainer.mainContext
//        
//        // Clear any existing data
//        try context.delete(model: Activity.self)
//        try context.delete(model: DailyReport.self)
//        try context.save()
//    }
//    
//    override func tearDownWithError() throws {
//        viewModel = nil
//        context = nil
//        modelContainer = nil
//        try super.tearDownWithError()
//    }
//    
//    // MARK: - Initialization Tests
//    
//    func testInit_WithNoExistingActivity_CreatesNewActivity() throws {
//        // Given
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let expectedDateString = formatter.string(from: today)
//        
//        // When
//        viewModel = ActivityViewModel(context: context)
//        
//        // Then
//        XCTAssertNotNil(viewModel.todayActivity, "Should create a new activity for today")
//        XCTAssertEqual(viewModel.todayActivity?.dateString, expectedDateString)
//        XCTAssertEqual(viewModel.todayActivity?.steps, 0)
//        XCTAssertEqual(viewModel.todayActivity?.distance, 0.0)
//        XCTAssertEqual(viewModel.todayActivity?.burn, 0)
//        
//        // Verify activity was saved to context
//        let fetchDescriptor = FetchDescriptor<Activity>()
//        let activities = try context.fetch(fetchDescriptor)
//        XCTAssertEqual(activities.count, 1)
//        XCTAssertEqual(activities.first?.dateString, expectedDateString)
//    }
//    
//    func testInit_WithExistingActivity_LoadsExistingActivity() throws {
//        // Given
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let todayString = formatter.string(from: today)
//        
//        // Create existing activity
//        let existingActivity = Activity(date: today, steps: 5000, distance: 3.5, burn: 200)
//        context.insert(existingActivity)
//        try context.save()
//        
//        // When
//        viewModel = ActivityViewModel(context: context)
//        
//        // Then
//        XCTAssertNotNil(viewModel.todayActivity)
//        XCTAssertEqual(viewModel.todayActivity?.dateString, todayString)
//        XCTAssertEqual(viewModel.todayActivity?.steps, 5000)
//        XCTAssertEqual(viewModel.todayActivity?.distance ?? 0.0, 3.5, accuracy: 0.01)
//        XCTAssertEqual(viewModel.todayActivity?.burn, 200)
//        
//        // Verify no duplicate activities were created
//        let fetchDescriptor = FetchDescriptor<Activity>()
//        let activities = try context.fetch(fetchDescriptor)
//        XCTAssertEqual(activities.count, 1)
//    }
//    
//    // MARK: - Update Activity Tests
//    
//    func testUpdateTodayActivity_UpdateSteps_UpdatesStepsAndDailyReport() throws {
//        // Given
//        viewModel = ActivityViewModel(context: context)
//        let initialSteps = viewModel.todayActivity?.steps ?? 0
//        let newSteps = 8000
//        
//        // When
//        viewModel.updateTodayActivity(steps: newSteps)
//        
//        // Then
//        XCTAssertEqual(viewModel.todayActivity?.steps, newSteps)
//        XCTAssertNotEqual(viewModel.todayActivity?.steps, initialSteps)
//        
//        // Verify changes are persisted
//        try context.save()
//        let fetchDescriptor = FetchDescriptor<Activity>()
//        let activities = try context.fetch(fetchDescriptor)
//        XCTAssertEqual(activities.first?.steps, newSteps)
//    }
//    
//    func testUpdateTodayActivity_UpdateDistance_UpdatesDistanceAndDailyReport() throws {
//        // Given
//        viewModel = ActivityViewModel(context: context)
//        let newDistance = 5.2
//        
//        // When
//        viewModel.updateTodayActivity(distance: newDistance)
//        
//        // Then
//        XCTAssertEqual(viewModel.todayActivity?.distance ?? 0.0, newDistance, accuracy: 0.01)
//        
//        // Verify changes are persisted
//        try context.save()
//        let fetchDescriptor = FetchDescriptor<Activity>()
//        let activities = try context.fetch(fetchDescriptor)
//        XCTAssertEqual(activities.first?.distance ?? 0.0, newDistance, accuracy: 0.01)
//    }
//    
//    func testUpdateTodayActivity_UpdateBurn_UpdatesBurnAndDailyReport() throws {
//        // Given
//        viewModel = ActivityViewModel(context: context)
//        let newBurn = 350
//        
//        // When
//        viewModel.updateTodayActivity(burn: newBurn)
//        
//        // Then
//        XCTAssertEqual(viewModel.todayActivity?.burn, newBurn)
//        
//        // Verify changes are persisted
//        try context.save()
//        let fetchDescriptor = FetchDescriptor<Activity>()
//        let activities = try context.fetch(fetchDescriptor)
//        XCTAssertEqual(activities.first?.burn, newBurn)
//    }
//    
//    func testUpdateTodayActivity_UpdateAllValues_UpdatesAllFields() throws {
//        // Given
//        viewModel = ActivityViewModel(context: context)
//        let newSteps = 12000
//        let newDistance = 8.7
//        let newBurn = 500
//        
//        // When
//        viewModel.updateTodayActivity(steps: newSteps, distance: newDistance, burn: newBurn)
//        
//        // Then
//        XCTAssertEqual(viewModel.todayActivity?.steps, newSteps)
//        XCTAssertEqual(viewModel.todayActivity?.distance ?? 0.0, newDistance, accuracy: 0.01)
//        XCTAssertEqual(viewModel.todayActivity?.burn, newBurn)
//    }
//    
//    func testUpdateTodayActivity_WithNilValues_DoesNotUpdateCorrespondingFields() throws {
//        // Given
//        viewModel = ActivityViewModel(context: context)
//        
//        // Set initial values
//        viewModel.updateTodayActivity(steps: 5000, distance: 3.0, burn: 200)
//        let initialSteps = viewModel.todayActivity?.steps
//        let initialDistance = viewModel.todayActivity?.distance
//        let initialBurn = viewModel.todayActivity?.burn
//        
//        // When - Update only steps, leave others as nil
//        viewModel.updateTodayActivity(steps: 7000)
//        
//        // Then
//        XCTAssertEqual(viewModel.todayActivity?.steps, 7000)
//        XCTAssertEqual(viewModel.todayActivity?.distance, initialDistance) // Should remain unchanged
//        XCTAssertEqual(viewModel.todayActivity?.burn, initialBurn) // Should remain unchanged
//    }
//    
//    // MARK: - Error Handling Tests
////    
////    func testUpdateTodayActivity_WithNoTodayActivity_DoesNotCrash() {
////        // Given
////        viewModel = ActivityViewModel(context: context)
////        viewModel.todayActivity = nil // Simulate no activity
////        
////        // When & Then - Should not crash
////        XCTAssertNoThrow {
////            viewModel.updateTodayActivity(steps: 5000)
////        }
////    }
//    
//    // MARK: - Published Property Tests
//    
//    func testTodayActivity_IsPublished() {
//        // Given
//        let expectation = XCTestExpectation(description: "Published property should notify changes")
//        viewModel = ActivityViewModel(context: context)
//        
//        // When
//        let cancellable = viewModel.$todayActivity.sink { _ in
//            expectation.fulfill()
//        }
//        
//        viewModel.updateTodayActivity(steps: 1000)
//        
//        // Then
//        wait(for: [expectation], timeout: 1.0)
//        cancellable.cancel()
//    }
//    
//    // MARK: - Date Handling Tests
//    
//    func testSetupTodayActivity_UsesCorrectDateFormat() throws {
//        // Given
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        let formatter = DateFormatter()
//        formatter.dateFormat = "yyyy-MM-dd"
//        let expectedDateString = formatter.string(from: today)
//        
//        // When
//        viewModel = ActivityViewModel(context: context)
//        
//        // Then
//        XCTAssertEqual(viewModel.todayActivity?.dateString, expectedDateString)
//    }
//    
//    func testSetupTodayActivity_WithDifferentTimezone_HandlesCorrectly() throws {
//        // Given
//        let calendar = Calendar.current
//        let today = calendar.startOfDay(for: Date())
//        
//        // When
//        viewModel = ActivityViewModel(context: context)
//        
//        // Then
//        XCTAssertNotNil(viewModel.todayActivity)
//        // Verify the date is start of day (time components should be zero)
//        let activityDate = viewModel.todayActivity?.date
//        XCTAssertEqual(calendar.component(.hour, from: activityDate!), 0)
//        XCTAssertEqual(calendar.component(.minute, from: activityDate!), 0)
//        XCTAssertEqual(calendar.component(.second, from: activityDate!), 0)
//    }
//    
//    // MARK: - Performance Tests
//    
//    func testPerformance_InitializationWithManyActivities() throws {
//        // Given - Create many activities for different dates
//        let calendar = Calendar.current
//        for i in 1...100 {
//            let date = calendar.date(byAdding: .day, value: -i, to: Date())!
//            let activity = Activity(date: date, steps: i * 100, distance: Double(i), burn: i * 10)
//            context.insert(activity)
//        }
//        try context.save()
//        
//        // When & Then
//        measure {
//            let testViewModel = ActivityViewModel(context: context)
//            _ = testViewModel.todayActivity
//        }
//    }
//    
//    func testPerformance_UpdateActivity() throws {
//        // Given
//        viewModel = ActivityViewModel(context: context)
//        
//        // When & Then
//        measure {
//            viewModel.updateTodayActivity(steps: Int.random(in: 1000...20000))
//        }
//    }
//}
