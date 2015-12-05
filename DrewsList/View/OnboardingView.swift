//
//  ResetController.swift
// //RMprallax 
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///

import UIKit

public class OnboardingView: UIViewController {

  
  private var rmParallaxViewController: RMParallax?

  public override func viewDidLoad() {
      super.viewDidLoad()
      
    let item1 = RMParallaxItem(image: UIImage(named: "BackgroundImage_Books-33")!, text: "Drew's List")
    let item2 = RMParallaxItem(image: UIImage(named: "BackgroundImage_Orange-23")!, text: "Sell, Trade, and Buy your Books")
    let item3 = RMParallaxItem(image: UIImage(named: "BackgroundImage_Orange-23")!, text: "Chat with your friends with our instant chat!")
  
    rmParallaxViewController = RMParallax(items: [item1, item2, item3], motion: false)
    rmParallaxViewController?.completionHandler = { [weak self] in
      UIView.animateWithDuration(0.4, animations: {
        self?.rmParallaxViewController?.view.alpha = 0.0
      })
    }
    
    // Adding parallax view controller.
    addChildViewController(rmParallaxViewController!)
    view.addSubview(rmParallaxViewController!.view)
    rmParallaxViewController?.didMoveToParentViewController(self)
  }

  public override func prefersStatusBarHidden() -> Bool {
      return true
  }

}

