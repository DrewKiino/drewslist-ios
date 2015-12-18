//
//  TabView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/4/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Toucan
import Onboard

public class TabView: RAMAnimatedTabBarController {
  
  let communityTab = CommunityFeedView()
  let chatView = ChatHistoryView()
  let scannerView = ScannerView()
  let activityView = UIViewController()
  let userProfileView = UserProfileView()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupViewControllers()
    setupFeedView()
    setupChatView()
    setupISBNScannerView()
    setupActivityView()
    setupUserProfileView()
    
    tabBar.translucent = false
    tabBar.tintColor = .soothingBlue()
    tabBar.backgroundColor = .whiteColor()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
//    if !NSUserDefaults.standardUserDefaults().boolForKey("OnboardingSeen") { presentViewController( OnboardingView(), animated: true, completion: nil) }
//    presentViewController(OnboardingView(), animated: true, completion: nil)
  }
  
  private func setupViewControllers() {
    viewControllers = [communityTab, userProfileView, chatView, scannerView, activityView]
  }
  
  private func setupFeedView() {
    
    communityTab.view.backgroundColor = .whiteColor()
    
    let image = Toucan(image: UIImage(named: "Icon-Book")!).resize(CGSize(width: 24, height: 24)).image
    let item = RAMAnimatedTabBarItem(title: "Community", image: image, selectedImage: image)
    communityTab.tabBarItem = item
  }
  
  private func setupChatView() {
    
    let image = Toucan(image: UIImage(named: "Icon-Message-1")!).resize(CGSize(width: 24, height: 24)).image
    let item = RAMAnimatedTabBarItem(title: "Chat", image: image, selectedImage: image)
    chatView.tabBarItem = item
  }
  
  private func setupISBNScannerView() {
    
    let image = Toucan(image: UIImage(named: "Icon-Camera")!).resize(CGSize(width: 24, height: 24)).image
    let item = RAMAnimatedTabBarItem(title: "List", image: image, selectedImage: image)
    scannerView.tabBarItem = item
  }
  
  private func setupActivityView() {
    
    let image = Toucan(image: UIImage(named: "Icon-CameraSnap")!).resize(CGSize(width: 24, height: 24)).image
    let item = RAMAnimatedTabBarItem(title: "Activity", image: image, selectedImage: image)
    activityView.tabBarItem = item
  }
  
  private func setupUserProfileView() {
    
    let image = Toucan(image: UIImage(named: "Icon-GreyStarEmpty")!).resize(CGSize(width: 24, height: 24)).image
    let item = RAMAnimatedTabBarItem(title: "Your Profile", image: image, selectedImage: image)
    userProfileView.tabBarItem = item
  }
}