//
//  ResetController.swift
// //RMprallax 
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 Totem. All rights reserved.
///

import UIKit
import Onboard
import Neon
import SwiftyButton
import RealmSwift

public class OnboardingView : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
  
  private let pushController = PushController.sharedInstance()
  
  private let controller = OnboardingController()
  private let screen = UIScreen.mainScreen().bounds
  private var myViewControllers = Array(count: 2, repeatedValue:UIViewController())
  //private var skipButton: UIButton?
  private var pushPermissionsLaterButton: SwiftyButton?
  private var pushPermissionsAcceptButton: SwiftyButton?
  private var getStartedButton: SwiftyButton?
  
  private let firstPage = UIViewController()
  private let secondPage = UIViewController()
  private let thirdPage = UIViewController()
  private let fourthPage = UIViewController()
  private let fifthPage = UIViewController()
 
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupOnboardingView()
    
    FBSDKController.createCustomEventForName("UserOnboarding")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupOnboardingView() {
    
    let firstPageBG = UIImageView(image: Toucan(image: UIImage(named: "OnBoardingScreen-1")!).resize(firstPage.view.frame.size, fitMode: .Clip).image)
    firstPageBG.frame = firstPage.view.frame
    firstPage.view.addSubview(firstPageBG)
    //firstPage.view.addSubview(skipButton!)
    firstPage.title = "WelcomeScreen"
    
    let secondPageBG = UIImageView(image: Toucan(image: UIImage(named: "OnBoardingScreen-2")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    secondPageBG.frame = firstPage.view.frame
    secondPage.view.addSubview(secondPageBG)
    secondPage.title = "ScanInfoScreen"
    
    let thirdPageBG = UIImageView(image: Toucan(image: UIImage(named: "OnBoardingScreen-3")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    thirdPageBG.frame = thirdPage.view.frame
    thirdPage.view.addSubview(thirdPageBG)
    thirdPage.title = "GetMatchedScreen"
    
    let fourthPageBG = UIImageView(image: Toucan(image: UIImage(named: "OnBoardingScreen-4")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    fourthPageBG.frame = fourthPage.view.frame
    fourthPage.view.addSubview(fourthPageBG)
    fourthPage.title = "PermissionsForPushScreen"
    
    let fifthPageBG = UIImageView(image: Toucan(image: UIImage(named: "OnBoardingScreen-5")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
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
    pushPermissionsLaterButton?.shadowColor  = .juicyOrange()
    pushPermissionsLaterButton?.shadowHeight = 3
    pushPermissionsLaterButton?.cornerRadius = 3
    pushPermissionsLaterButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
    pushPermissionsLaterButton?.setTitle("Ask Later", forState: .Normal)
    pushPermissionsLaterButton?.frame = CGRectMake(48, screen.height - 124, 100, 24)
    pushPermissionsLaterButton?.addTarget(self, action: "askPushPermLater", forControlEvents: .TouchUpInside)
    
    view.addSubview(pushPermissionsLaterButton!)
    
    pushPermissionsAcceptButton = SwiftyButton()
    pushPermissionsAcceptButton?.buttonColor  = .sexyGray()
    pushPermissionsAcceptButton?.shadowColor  = .juicyOrange()
    pushPermissionsAcceptButton?.shadowHeight = 3
    pushPermissionsAcceptButton?.cornerRadius = 3
    pushPermissionsAcceptButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 16)
    pushPermissionsAcceptButton?.setTitle("Yes!", forState: .Normal)
    pushPermissionsAcceptButton?.frame = CGRectMake(screen.width - 148, screen.height - 124, 100, 24)
    pushPermissionsAcceptButton?.addTarget(self, action: "acceptPushPermNow", forControlEvents: .TouchUpInside)
    
    view.addSubview(pushPermissionsAcceptButton!)
  }
  
  private func setupGetStartedButton(view: UIView) {
    
    getStartedButton = SwiftyButton()
    getStartedButton?.buttonColor  = .whiteColor()
    getStartedButton?.shadowColor  = .sweetBeige()
    getStartedButton?.shadowHeight = 3
    getStartedButton?.cornerRadius = 3
    getStartedButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
    getStartedButton?.setTitleColor(UIColor.sexyGray(), forState: .Normal)
    getStartedButton?.setTitle("Lets get started!", forState: .Normal)
    getStartedButton?.frame = CGRectMake(screen.width / 2 - 100, screen.height - 48 - 48, 200, 48)
    getStartedButton?.addTarget(self, action: "skipOnboarding", forControlEvents: .TouchUpInside)
    
    view.addSubview(getStartedButton!)
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex =  self.myViewControllers.indexOf(viewController)! + 1
    if currentIndex >= self.myViewControllers.count { return nil }
    let currentView = self.myViewControllers[currentIndex]
    
    // clean subviews
    cleanSubviews(currentView.view)
    
    // add needed subviews
    switch currentView.title! {
    case "CloseTheDealScreen":
      PushController().showPermissions()
      setupGetStartedButton(currentView.view)
      break
    //default: currentView.view.addSubview(skipButton!)
    default: break
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
    switch currentView.title! {
    case "CloseTheDealScreen":
      PushController().showPermissions()
      setupGetStartedButton(currentView.view)
      break
    //default: currentView.view.addSubview(skipButton!)
    default: break
    }
    
    return currentView
  }
  
  public func skipOnboarding() {
    setOnboardingAsBeenSeen()
    // dismiss the onboarding view
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  private func cleanSubviews(view: UIView) {
    for view in view.subviews {
      if view == pushPermissionsLaterButton { view.removeFromSuperview() }
      else if view == pushPermissionsAcceptButton { view.removeFromSuperview() }
      else if view == getStartedButton { view.removeFromSuperview() }
//      else if view == skipButton { view.removeFromSuperview() }
    }
  }
  
  public func askPushPermLater() {
    setViewControllers([fifthPage], direction:.Forward, animated: true, completion:nil)
  }
  
  public func acceptPushPermNow() {
    controller.showPermissions()
  }
  
  
  public func setOnboardingAsBeenSeen() {
    UserModel.hasSeenOnboarding = true
  }
}
