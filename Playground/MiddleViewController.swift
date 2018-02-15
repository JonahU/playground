//
//  ViewController.swift
//  Playground
//
//  Created by Jonah U on 8/14/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit

class MiddleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func becomeFirstResponder() -> Bool {
        return true
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        if motion == .motionShake {
            view.backgroundColor = UIColor.blue
        }
    } // no longer works
    
    func randomizeColor() -> UIColor{
        //Implement Color randomizer
        let color = UIColor.brown
        return color
    } //non functioning
    
}

