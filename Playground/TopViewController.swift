//
//  TopViewController.swift
//  Playground
//
//  Created by Jonah U on 8/17/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit

class TopViewController: UIViewController {
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var flightsLabel: UILabel!

    let healthManager: HealthKitManager = HealthKitManager()
    var todaysSteps: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getHealthKitPermission()
    }
    
    func getHealthKitPermission(){
        healthManager.authorizeHealthKit{ (authorized, error) -> Void in
            if authorized {
                self.updateStepLabel()
                self.updateFlightsLabel()
                self.updateDistanceLabel()
            }else{
                if error != nil{
                    print(error!)
                }
                print("HealthKit Permission denied")
            }
            
        }
    }
    
    func updateStepLabel(){
        self.healthManager.getStepCount(completion: {(steps) -> Void in
            DispatchQueue.main.async {
                let stepVal: Int = Int(steps)
                self.stepsLabel.text = "\(stepVal) steps"
            }
        })
    }
    
    func updateDistanceLabel(){
        self.healthManager.getFlightsClimed(completion: {(flights) -> Void in
            DispatchQueue.main.async {
                let flightsVal: Int = Int(flights)
                self.distanceLabel.text = "\(flightsVal) flights climbed"
            }
        })
    }
    
    func updateFlightsLabel(){
        self.healthManager.getDistanceMoved(completion: {(distance) -> Void in
            DispatchQueue.main.async {
                self.flightsLabel.text = String(format: "%.2f miles", distance)
            }
        })
    }
}
