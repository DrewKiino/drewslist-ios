//
//  ViewController.swift
//  RMParallax
//
///  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///


import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = RMParallaxItem(image: UIImage(named: "item1")!, text: "")
      
        let item2 = RMParallaxItem(image: UIImage(named: "item2")!, text: "Buy, Sell, Trade your books with ease!")
        let item3 = RMParallaxItem(image: UIImage(named: "item3")!, text: "Communicate with your friends with our Real-Time Chat")
        
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

