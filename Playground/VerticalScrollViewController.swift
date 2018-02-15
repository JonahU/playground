//
//  VerticalScrollViewController.swift
//  Playground
//
//  Created by Jonah U on 8/16/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit

class VerticalScrollViewController: UIViewController, SuperContainerViewControllerDelegate {
    
    var topViewController: UIViewController!
    var middleViewController: UIViewController!
    var bottomViewController: UIViewController!
    var scrollView: UIScrollView!

    class func verticalScrollViewControllerWith(middleViewController: UIViewController,
                                                topViewController: UIViewController?=nil,
                                                bottomViewController: UIViewController?=nil) -> VerticalScrollViewController {
        let middleScrollViewController = VerticalScrollViewController()
        
        middleScrollViewController.topViewController = topViewController
        middleScrollViewController.middleViewController = middleViewController
        middleScrollViewController.bottomViewController = bottomViewController
        
        return middleScrollViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
    }
    
    func setupScrollView() {
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        
        scrollView.frame = CGRect(x: view.x, y: view.y, width: view.width, height: view.height)
        self.view.addSubview(scrollView)
        
        let scrollWidth: CGFloat = view.width
        var scrollHeight: CGFloat
        
        if topViewController != nil && bottomViewController != nil {
            scrollHeight = 3*view.height
            topViewController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            middleViewController.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
            bottomViewController.view.frame = CGRect(x: 0, y: 2*view.height, width: view.width, height: view.height)
            
            addChildViewController(topViewController)
            addChildViewController(middleViewController)
            addChildViewController(bottomViewController)
            
            scrollView.addSubview(topViewController.view)
            scrollView.addSubview(middleViewController.view)
            scrollView.addSubview(bottomViewController.view)
            
            topViewController.didMove(toParentViewController: self)
            middleViewController.didMove(toParentViewController: self)
            bottomViewController.didMove(toParentViewController: self)
            
            scrollView.contentOffset.y = middleViewController.view.frame.origin.y
        } else if topViewController == nil {
            scrollHeight = 2*view.height
            middleViewController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            bottomViewController.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
            
            addChildViewController(middleViewController)
            addChildViewController(bottomViewController)
            
            scrollView.addSubview(middleViewController.view)
            scrollView.addSubview(bottomViewController.view)
            
            middleViewController.didMove(toParentViewController: self)
            bottomViewController.didMove(toParentViewController: self)
            
            scrollView.contentOffset.y = 0
        } else if bottomViewController == nil {
            scrollHeight = 2*view.height
            topViewController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            middleViewController.view.frame = CGRect(x: 0, y: view.height, width: view.width, height: view.height)
            
            addChildViewController(topViewController)
            addChildViewController(middleViewController)
            
            scrollView.addSubview(topViewController.view)
            scrollView.addSubview(middleViewController.view)
            
            topViewController.didMove(toParentViewController: self)
            middleViewController.didMove(toParentViewController: self)
            
            scrollView.contentOffset.y = middleViewController.view.frame.origin.y
        } else {
            scrollHeight = view.height
            middleViewController.view.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
            
            addChildViewController(middleViewController)
            scrollView.addSubview(middleViewController.view)
            middleViewController.didMove(toParentViewController: self)
        }
        
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
    }
    
    
    //MARK: - SuperContainerViewControllerDelegate Methods
    
    func outerScrollViewShouldScroll() -> Bool {
        if scrollView.contentOffset.y < middleViewController.view.frame.origin.y || scrollView.contentOffset.y > middleViewController.view.frame.origin.y{
            return false
        } else {
            return true
        }
    }
}
