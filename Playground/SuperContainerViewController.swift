//
//  SuperContainerViewController.swift
//  Playground
//
//  Created by Jonah U on 8/16/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit

protocol SuperContainerViewControllerDelegate {
    func outerScrollViewShouldScroll() -> Bool
}

class SuperContainerViewController: UIViewController, UIScrollViewDelegate {

    var topViewController: UIViewController?
    var leftViewController: UIViewController!
    var middleViewController: UIViewController!
    var rightViewController: UIViewController!
    var bottomViewController: UIViewController?
    
    var directionLockDisabled: Bool!
    
    var horizontalViews = [UIViewController]()
    var verticalViews = [UIViewController]()
    
    var initialContentOffset = CGPoint() //scrollView intial offset
    var middleVerticalScrollViewController: VerticalScrollViewController!
    var scrollView: UIScrollView!
    var delegate: SuperContainerViewControllerDelegate?
    
    class func containerViewWith(leftViewController: UIViewController,
                                 middleViewController: UIViewController,
                                 rightViewController: UIViewController,
                                 topViewController: UIViewController?=nil,
                                 bottomViewController: UIViewController?=nil,
                                 directionLockDisabled: Bool?=false) -> SuperContainerViewController {
        let container = SuperContainerViewController()
        
        container.directionLockDisabled = directionLockDisabled
        
        container.topViewController = topViewController
        container.leftViewController = leftViewController
        container.middleViewController = middleViewController
        container.rightViewController = rightViewController
        container.bottomViewController = bottomViewController
        return container
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupVerticalScrollView()
        setupHorizontalScrollView()
    }
    
    func setupVerticalScrollView(){
        middleVerticalScrollViewController = VerticalScrollViewController.verticalScrollViewControllerWith(middleViewController: middleViewController,
                                                                                                           topViewController: topViewController,
                                                                                                           bottomViewController: bottomViewController)
        delegate = middleVerticalScrollViewController
    }
    
    func setupHorizontalScrollView(){
        scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.bounces = false
        
        let view = (
            x: self.view.bounds.origin.x,
            y: self.view.bounds.origin.y,
            width: self.view.bounds.width,
            height: self.view.bounds.height
        )
        
        scrollView.frame = CGRect(x: view.x,
                                  y: view.y,
                                  width: view.width,
                                  height: view.height
        )
        
        self.view.addSubview(scrollView)
        
        let scrollWidth = 3*view.width
        let scrollHeight = view.height
        scrollView.contentSize = CGSize(width: scrollWidth, height: scrollHeight)
        
        leftViewController.view.frame = CGRect(x: 0,
                                               y: 0,
                                               width: view.width,
                                               height: view.height
        )
        
        middleVerticalScrollViewController.view.frame = CGRect(x: view.width,
                                                               y: 0,
                                                               width: view.width,
                                                               height: view.height
        )
        
        rightViewController.view.frame = CGRect(x: 2*view.width,
                                                y: 0,
                                                width: view.width,
                                                height: view.height
        )
        
        addChildViewController(leftViewController)
        addChildViewController(middleVerticalScrollViewController)
        addChildViewController(rightViewController)
        
        scrollView.addSubview(leftViewController.view)
        scrollView.addSubview(middleVerticalScrollViewController.view)
        scrollView.addSubview(rightViewController.view)
        
        leftViewController.didMove(toParentViewController: self)
        middleVerticalScrollViewController.didMove(toParentViewController: self)
        rightViewController.didMove(toParentViewController: self)
        
        scrollView.contentOffset.x = middleVerticalScrollViewController.view.frame.origin.x
        scrollView.delegate = self
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.initialContentOffset = scrollView.contentOffset
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if delegate != nil && !delegate!.outerScrollViewShouldScroll() && !directionLockDisabled {
            let newOffset = CGPoint(x: self.initialContentOffset.x, y: self.initialContentOffset.y)
            
            //setting the new offset to the scrollView makes it behave like a proper
            //directional lock, that allows you to scroll in only 1 direction at any given time
            self.scrollView!.setContentOffset(newOffset, animated: false)
        }
    }
    
    

}
