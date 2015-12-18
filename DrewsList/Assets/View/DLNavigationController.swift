//
//  DLNavigationController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class DLNavigationController: UINavigationController {
  
  public var rootView: UIViewController?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupRootView()
    setupSelf()
  }
  
  private func setupSelf() {
    navigationBar.barTintColor = UIColor.soothingBlue()
    navigationBar.tintColor = UIColor.whiteColor()
    
    navigationBar.titleTextAttributes = [
      NSFontAttributeName: UIFont.asapBold(16),
      NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
  }
  
  public func setupRootView() {
    rootView = UIViewController()
    rootView?.title = "Drew's List"
    setViewControllers([rootView!], animated: false)
  }
  
  public func setRootViewTitle(title: String?) {
    rootView?.title = title
  }
}
