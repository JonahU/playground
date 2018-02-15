//
//  BottomViewController.swift
//  Playground
//
//  Created by Jonah U on 8/28/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import SpriteKit

class BottomViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = view as! SKView
        skView.showsFPS = false
        skView.showsNodeCount = false
        skView.ignoresSiblingOrder = false
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        if UIDevice.current.userInterfaceIdiom == .phone{
            return .allButUpsideDown
        }else{
            return .all
        }
    }
    
//    override var prefersStatusBarHidden: Bool{
//        return true
//    }

}
