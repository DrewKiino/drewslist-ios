//
//  ResetController.swift
// //RMprallax 
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///

import UIKit

class OnboardingView: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = RMParallaxItem(image: UIImage(named: "item1")!, text: "")
        let item2 = RMParallaxItem(image: UIImage(named: "book7")!, text: "Sell, Trade, and Buy your Books")
        let item3 = RMParallaxItem(image: UIImage(named: "book7")!, text: "Chat with your friends with our instant chat!")
        
        let rmParallaxViewController = RMParallax(items: [item1, item2, item3], motion: false)
        rmParallaxViewController.completionHandler = {
            UIView.animateWithDuration(0.4, animations: { () -> Void in
                rmParallaxViewController.view.alpha = 0.0
            })
        }
        
        // Adding parallax view controller.
        self.addChildViewController(rmParallaxViewController)
        self.view.addSubview(rmParallaxViewController.view)
        rmParallaxViewController.didMoveToParentViewController(self)
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

}

