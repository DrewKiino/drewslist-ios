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
import FBSDKLoginKit
import WebKit

public class OnboardingView : UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, FBSDKLoginButtonDelegate {
  
  private let pushController = PushController.sharedInstance()
  
  private var myViewControllers = Array(count: 2, repeatedValue:UIViewController())
  //private var skipButton: UIButton?
  private var pushPermissionsLaterButton: SwiftyButton?
  private var pushPermissionsAcceptButton: SwiftyButton?
//  private var getStartedButton: SwiftyButton?
  private var fbLoginButton: FBSDKLoginButton?
  
  private let firstPage = UIViewController()
  private let secondPage = UIViewController()
  private let thirdPage = UIViewController()
  private let fourthPage = UIViewController()
  private let fifthPage = UIViewController()
  
  private let browserView = DLNavigationController()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupOnboardingView()
    
    FBSDKController.createCustomEventForName("UserOnboarding")
    
    view.showLoadingScreen(0, bgOffset: -64)
    
    // log use out whenever onboarding is seen
    logout()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    NSTimer.after(0.5) { [weak self] in
      self?.view.hideLoadingScreen()
    }
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
  
  private func setupFacebookLogin(view: UIView) {
    fbLoginButton = FBSDKLoginButton()
    fbLoginButton?.delegate = self
    fbLoginButton?.readPermissions = ["public_profile","email","user_friends"]
    view.addSubview(fbLoginButton!)
    fbLoginButton?.anchorToEdge(.Bottom, padding: 16, width: 256, height: 36)
  }
  
//  private func setupGetStartedButton(view: UIView) {
//    
//    getStartedButton = SwiftyButton()
//    getStartedButton?.buttonColor  = .whiteColor()
//    getStartedButton?.shadowColor  = .sweetBeige()
//    getStartedButton?.shadowHeight = 3
//    getStartedButton?.cornerRadius = 3
//    getStartedButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 18)
//    getStartedButton?.setTitleColor(UIColor.sexyGray(), forState: .Normal)
//    getStartedButton?.setTitle("Lets get started!", forState: .Normal)
//    getStartedButton?.frame = CGRectMake(screen.width / 2 - 100, screen.height - 48 - 48, 200, 48)
//    getStartedButton?.addTarget(self, action: "skipOnboarding", forControlEvents: .TouchUpInside)
//    
//    view.addSubview(getStartedButton!)
//  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex =  self.myViewControllers.indexOf(viewController)! + 1
    if currentIndex >= self.myViewControllers.count { return nil }
    let currentView = self.myViewControllers[currentIndex]
    
    // clean subviews
    cleanSubviews(currentView.view)
    
    // add needed subviews
    switch currentView.title! {
    case "CloseTheDealScreen":
      PushController().showPermissions(false)
      setupFacebookLogin(currentView.view)
//      setupGetStartedButton(currentView.view)
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
      PushController().showPermissions(false)
      setupFacebookLogin(currentView.view)
//      setupGetStartedButton(currentView.view)
      break
    //default: currentView.view.addSubview(skipButton!)
    default: break
    }
    
    return currentView
  }
  
  public func skipOnboarding() {
    setOnboardingAsBeenSeen()
    // dismiss the onboarding view
    NSTimer.after(0.5) { [weak self] in
      self?.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
  }
  
  private func cleanSubviews(view: UIView) {
    for view in view.subviews {
      if view == pushPermissionsLaterButton { view.removeFromSuperview() }
      else if view == pushPermissionsAcceptButton { view.removeFromSuperview() }
      else if view == fbLoginButton { view.removeFromSuperview() }
    }
  }
  
  public func askPushPermLater() {
    setViewControllers([fifthPage], direction:.Forward, animated: true, completion:nil)
  }
  
  public func setOnboardingAsBeenSeen() {
    UserModel.hasSeenOnboarding = true
  }
  
  // MARK: FBSDK LOGIN BUTTON
  
  // MARK: Delegates
  public func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    
    // show the user there was an error if the fbsdk login did not succeed
    if let error = error {
      log.error(error)
      
      // else, if the login was cancelled show the user as well that the fbsdk login did not succeed
    } else if result.isCancelled {
      
      // Handle cancellations
      log.debug("FB login has been cancelled")
      
      // else, the user has successfully logged in
    } else {
      
//      controller.getUserAttributesFromFacebook()
      
      log.info("User is logged in")
      
      FBSDKController.getUser() { [weak self] user in
        if let user = user {
          log.debug("user returned from Facebook SDK")
          LoginController.authenticateUserToServer(user) { [weak self] updatedUser in
            if let user = updatedUser {
              log.debug("user authentcated in server")
              if let url = NSURL(string: "http://totemv.com/drewslist/useragreement"), let view = self?.viewControllers?.first, let browserView = self?.browserView where !user.hasAgreedToUserAgreement {
                view.presentViewController(browserView, animated: true) { [weak self] bool in
                  let webView = WKWebView()
                  webView.loadRequest(NSURLRequest(URL: url))
                  browserView.rootView?.view.addSubview(webView)
                  webView.fillSuperview()
                  browserView.rootView?.setButton(.LeftBarButton, title: "Done", target: self, selector: "dismissBrowser")
                }
              } else {
                self?.skipOnboarding()
              }
            } else {
              self?.logout()
            }
          }
        } else {
          self?.logout()
        }
      }
    }
  }
  
  public func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    log.info("User Logged Out")
  }
  
  public func logout() {
    log.info("user has logged out")
    FBSDKLoginManager().logOut()
  }
  
  public func dismissBrowser() {
    browserView.dismissViewControllerAnimated(true) { [weak self] bool in
      if let view = self?.viewControllers?.first {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
        alertController.addAction(UIAlertAction(title: "I agree with Drew's List User Agreement", style: .Default) { action in
          UserController.updateUserToServer({ (user) -> User? in
            log.debug("updating user...")
            user?.hasAgreedToUserAgreement = true
            return user
            }, completionBlock: { (user) -> Void in
              if let user = user {
                log.debug("user updated.")
                self?.skipOnboarding()
              } else {
                self?.logout()
              }
          })
          })
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
          self?.logout()
          })
        view.presentViewController(alertController, animated: true, completion: nil)
      }
    }
  }
}
