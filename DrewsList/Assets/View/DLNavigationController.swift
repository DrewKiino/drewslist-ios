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
  
  public class func showActivityAnimation(view: UIViewController?, leftHandSide: Bool = false) {
    if let view = view {
      var activityView: UIActivityIndicatorView! = UIActivityIndicatorView(activityIndicatorStyle: .White)
      if leftHandSide == true {
        view.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: activityView)
      } else {
        view.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: activityView)
      }
      activityView.startAnimating()
      activityView = nil
    }
  }
  
  public class func hideActivityAnimation(view: UIViewController?, leftHandSide: Bool = false) {
    if let view = view {
      if leftHandSide == true {
        view.navigationItem.leftBarButtonItem = nil
      } else {
        view.navigationItem.rightBarButtonItem = nil
      }
    }
  }
  
  private func setupSelf() {
    
    navigationBar.barTintColor = UIColor.soothingBlue()
    navigationBar.tintColor = UIColor.whiteColor()
    
    navigationBar.titleTextAttributes = [
      NSFontAttributeName: UIFont.asapBold(16),
      NSForegroundColorAttributeName: UIColor.whiteColor()
    ]
    
    navigationBar.translucent = false
    
    view.backgroundColor = .whiteColor()
  }
  
  public func setupRootView() {
    rootView = UIViewController()
    rootView?.title = "Drew's List"
    setViewControllers([rootView!], animated: false)
  }
  
  public func setRootViewController(rootViewController: UIViewController?) {
    rootView = rootViewController
  }

  public func setRootViewTitle(title: String?) {
    rootView?.title = title
  }
  
  public class func setRightBarButton(view: UIViewController?, customView: UIView?) {
    if let view = view, let customView = customView {
        view.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: customView)
    }
  }
}
