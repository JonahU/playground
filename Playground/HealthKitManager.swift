//
//  HealthKitManager.swift
//  Playground
//
//  Created by Jonah U on 8/17/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import HealthKit

class HealthKitManager: NSObject {
    
    let healthKitStore: HKHealthStore = HKHealthStore()
    
    func authorizeHealthKit(completion: ((_ success: Bool, _ error: Error?) -> Void)!) {
        
        
        //State the health data type(s) want to read from HealthKit
        let healthDataToRead = Set(arrayLiteral: HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!, HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!)
        
        if !HKHealthStore.isHealthDataAvailable(){
            print("Unable to access HealthKit")
        }
        
        //Request authorization to read the specified data
        healthKitStore.requestAuthorization(toShare: nil, read: healthDataToRead) {(success,error) -> Void in
            if(completion != nil) {
                completion(success, error)
            }
        }
    }
    
    func getStepCount(completion: @escaping (Double) -> Void){
        
        let stepsCount = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: currentDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsCount, quantitySamplePredicate: predicate, options: .cumulativeSum) {(_, result, error) in
            
            var resultCount = 0.0
            
            guard let result = result else {
                print("Failed to fetch steps: \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func getDistanceMoved(completion: @escaping (Double) -> Void){
        
        let distanceMoved = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.distanceWalkingRunning)!
        
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: currentDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: distanceMoved, quantitySamplePredicate: predicate, options: .cumulativeSum) {(_, result, error) in
            
            var resultCount = 0.0
            
            guard let result = result else {
                print("Failed to fetch distance moved: \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.mile())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthKitStore.execute(query)
    }
    
    func getFlightsClimed(completion: @escaping (Double) -> Void){
        
        let flightsClimed = HKQuantityType.quantityType(forIdentifier: HKQuantityTypeIdentifier.flightsClimbed)!
        
        let currentDate = Date()
        let startOfDay = Calendar.current.startOfDay(for: currentDate)
        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: currentDate, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: flightsClimed, quantitySamplePredicate: predicate, options: .cumulativeSum) {(_, result, error) in
            
            var resultCount = 0.0
            
            guard let result = result else {
                print("Failed to flights climed: \(error?.localizedDescription ?? "N/A")")
                completion(resultCount)
                return
            }
            
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        
        healthKitStore.execute(query)
    }

    
    
}
