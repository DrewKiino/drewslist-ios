//
//  ResetController.swift
// //RMprallax 
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///

import UIKit
import Onboard
import Toucan
import Neon
import SwiftyButton

public class OnboardingView : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  private let controller = OnboardingController()
  private let screen = UIScreen.mainScreen().bounds
  private var myViewControllers = Array(count: 2, repeatedValue:UIViewController())
  private var skipButton: UIButton?
  private var pushPermissionsLaterButton: SwiftyButton?
  private var pushPermissionsAcceptButton: SwiftyButton?
  
  
  private let firstPage = UIViewController()
  private let secondPage = UIViewController()
  private let thirdPage = UIViewController()
  private let fourthPage = UIViewController()
  private let fifthPage = UIViewController()
 
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupOnboardingView()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    
  }
  
  private func setupOnboardingView() {
    
    skipButton = UIButton(frame: CGRectMake((view.frame.width / 2) - 50, view.frame.height - 60, 100, 48))
    skipButton?.addTarget(self, action: "skipOnboarding", forControlEvents: .TouchUpInside)
    
    let firstPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding1")!).resize(firstPage.view.frame.size, fitMode: .Clip).image)
    firstPageBG.frame = firstPage.view.frame
    firstPage.view.addSubview(firstPageBG)
    firstPage.view.addSubview(skipButton!)
    firstPage.title = "WelcomeScreen"
    
    let secondPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding2")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    secondPageBG.frame = firstPage.view.frame
    secondPage.view.addSubview(secondPageBG)
    secondPage.title = "ScanInfoScreen"
    
    let thirdPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding3")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    thirdPageBG.frame = thirdPage.view.frame
    thirdPage.view.addSubview(thirdPageBG)
    thirdPage.title = "GetMatchedScreen"
    
    let fourthPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding4")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    fourthPageBG.frame = fourthPage.view.frame
    fourthPage.view.addSubview(fourthPageBG)
    fourthPage.title = "PermissionsForPushScreen"
    
    let fifthPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding5")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    fifthPageBG.frame = fifthPage.view.frame
    fifthPage.view.addSubview(fifthPageBG)
    fifthPage.title = "CloseTheDealScreen"
    
    self.myViewControllers = [firstPage, secondPage, thirdPage, fourthPage, fifthPage]
    
    dataSource = self
    delegate = self
    
    setViewControllers([firstPage], direction:.Forward, animated:false, completion:nil)
  }
  
  private func setupPushPermissions(view: UIView) {
    pushPermissionsLaterButton = SwiftyButton()
    pushPermissionsLaterButton?.buttonColor  = .sexyGray()
    pushPermissionsLaterButton?.shadowColor  = .soothingBlue()
    pushPermissionsLaterButton?.shadowHeight = 3
    pushPermissionsLaterButton?.cornerRadius = 3
    pushPermissionsLaterButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
    pushPermissionsLaterButton?.setTitle("Ask Later", forState: .Normal)
    pushPermissionsLaterButton?.frame = CGRectMake(48, screen.height - 124, 100, 24)
    pushPermissionsLaterButton?.addTarget(self, action: "askPushPermLater", forControlEvents: .TouchUpInside)
    
    view.addSubview(pushPermissionsLaterButton!)
    
    pushPermissionsAcceptButton = SwiftyButton()
    pushPermissionsAcceptButton?.buttonColor  = .sexyGray()
    pushPermissionsAcceptButton?.shadowColor  = .soothingBlue()
    pushPermissionsAcceptButton?.shadowHeight = 3
    pushPermissionsAcceptButton?.cornerRadius = 3
    pushPermissionsAcceptButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
    pushPermissionsAcceptButton?.setTitle("Yes!", forState: .Normal)
    pushPermissionsAcceptButton?.frame = CGRectMake(screen.width - 148, screen.height - 124, 100, 24)
    pushPermissionsAcceptButton?.addTarget(self, action: "acceptPushPermNow", forControlEvents: .TouchUpInside)
    
    view.addSubview(pushPermissionsAcceptButton!)
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex =  self.myViewControllers.indexOf(viewController)! + 1
    if currentIndex >= self.myViewControllers.count { return nil }
    
    let currentView = self.myViewControllers[currentIndex]
    
    // clean subviews
    cleanSubviews(currentView.view)
    
    // add needed subviews
    
    currentView.view.addSubview(skipButton!)
    
    switch currentView.title! {
    case "PermissionsForPushScreen":
      setupPushPermissions(currentView.view)
      break
    default: break;
    }
    
    return currentView
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex =  self.myViewControllers.indexOf(viewController)! - 1
    if currentIndex < 0 { return nil }
    
    let currentView = self.myViewControllers[currentIndex]
    
    // clean subviews
    cleanSubviews(currentView.view)
    
    // add needed subviews
    
    currentView.view.addSubview(skipButton!)
    
    switch currentView.title! {
    case "PermissionsForPushScreen":
      setupPushPermissions(currentView.view)
      break
    default: break;
    }
    
    return currentView
  }
  
  public func skipOnboarding() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func cleanSubviews(view: UIView) {
    for view in view.subviews {
      if view == pushPermissionsLaterButton { view.removeFromSuperview() }
      else if view == pushPermissionsAcceptButton { view.removeFromSuperview() }
      else if view == skipButton { view.removeFromSuperview() }
    }
  }
  
  public func askPushPermLater() {
    
    setViewControllers([fifthPage], direction:.Forward, animated: true, completion:nil)
  }
  
  public func acceptPushPermNow() {
    controller.showPermissions()
  }
}
