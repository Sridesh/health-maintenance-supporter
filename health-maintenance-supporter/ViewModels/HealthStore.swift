//
//  HealthStore.swift
//  health-maintenance-supporter
//
//  Created by Sridesh 001 on 2025-09-11.
//

import Foundation
import HealthKit

class HealthStore: ObservableObject {
    let healthStore = HKHealthStore()
    
    @Published var steps: Double = 0
    @Published var distance: Double = 0
    @Published var flights: Double = 0
    @Published var activeCalories: Double = 0
    @Published var basalCalories: Double = 0
    
    init() {
        requestAuthorization()
    }
    
    private func requestAuthorization() {
        if HKHealthStore.isHealthDataAvailable() {
            let typesToRead: Set<HKQuantityType> = [
                HKObjectType.quantityType(forIdentifier: .stepCount)!,
                HKObjectType.quantityType(forIdentifier: .distanceWalkingRunning)!,
                HKObjectType.quantityType(forIdentifier: .flightsClimbed)!,
                HKObjectType.quantityType(forIdentifier: .activeEnergyBurned)!,
                HKObjectType.quantityType(forIdentifier: .basalEnergyBurned)!
            ]
            
            healthStore.requestAuthorization(toShare: [], read: typesToRead) { success, error in
                if success {
                    self.fetchAllData()
                } else {
                    print("HealthKit authorization failed: \(String(describing: error))")
                }
            }
        }
    }
    
    /// Fetch all activity data for today
    func fetchAllData() {
        fetchSteps()
        fetchDistance()
        fetchFlights()
        fetchActiveCalories()
        fetchBasalCalories()
    }
    
    private func fetchSteps() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .stepCount) else { return }
        fetchSum(for: type, unit: HKUnit.count()) { value in
            DispatchQueue.main.async { self.steps = value }
        }
    }
    
    private func fetchDistance() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning) else { return }
        fetchSum(for: type, unit: HKUnit.meter()) { value in
            DispatchQueue.main.async { self.distance = value }
        }
    }
    
    private func fetchFlights() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else { return }
        fetchSum(for: type, unit: HKUnit.count()) { value in
            DispatchQueue.main.async { self.flights = value }
        }
    }
    
    private func fetchActiveCalories() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned) else { return }
        fetchSum(for: type, unit: HKUnit.kilocalorie()) { value in
            DispatchQueue.main.async { self.activeCalories = value }
        }
    }
    
    private func fetchBasalCalories() {
        guard let type = HKQuantityType.quantityType(forIdentifier: .basalEnergyBurned) else { return }
        fetchSum(for: type, unit: HKUnit.kilocalorie()) { value in
            DispatchQueue.main.async { self.basalCalories = value }
        }
    }
    
    /// Helper to fetch today’s total sum for a given type
    private func fetchSum(for quantityType: HKQuantityType,
                          unit: HKUnit,
                          completion: @escaping (Double) -> Void) {
        
        let now = Date()
        guard let startOfDay = Calendar.current.startOfDay(for: now) as Date? else { return }
        
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: quantityType,
                                      quantitySamplePredicate: predicate,
                                      options: .cumulativeSum) { _, result, _ in
            let value = result?.sumQuantity()?.doubleValue(for: unit) ?? 0
            completion(value)
        }
        
        healthStore.execute(query)
    }
}
