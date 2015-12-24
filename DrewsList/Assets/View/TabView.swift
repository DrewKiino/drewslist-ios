//
//  TabView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/4/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Onboard

public class TabView: RAMAnimatedTabBarController {
  
  var testView = CreateListingView()
  var communityTab: CommunityFeedView? = CommunityFeedView()
  var chatView: ChatHistoryView?  = ChatHistoryView()
  var scannerView: ScannerView? = ScannerView()
  var activityView: UIViewController? = UIViewController()
  var userProfileView: UserProfileView? = UserProfileView()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupCommunityTab()
    setupChatView()
    setupISBNScannerView()
    setupActivityView()
    setupUserProfileView()
    setupViewControllers()
    
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
    
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-1")).resize(CGSize(width: 24, height: 24))
    testView.tabBarItem = RAMAnimatedTabBarItem(title: "Test View", image: toucan!.image, selectedImage: toucan!.image)
    toucan = nil
//    viewControllers = [userProfileView!, scannerView!, communityTab!, chatView!]
    
    // set view controllers
    viewControllers = [communityTab!, chatView!, scannerView!, activityView!, userProfileView!]
    
    // dealloc reference view controllers
    communityTab = nil
    chatView = nil
    scannerView = nil
    activityView = nil
    userProfileView = nil
  }
  
  private func setupCommunityTab() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-1")).resize(CGSize(width: 24, height: 24))
    communityTab?.tabBarItem = RAMAnimatedTabBarItem(title: "Community", image: toucan!.image, selectedImage: toucan!.image)
    toucan = nil
  }
  
  private func setupChatView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-4")).resize(CGSize(width: 24, height: 24))
    chatView?.tabBarItem = RAMAnimatedTabBarItem(title: "Chat", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupISBNScannerView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-3")).resize(CGSize(width: 24, height: 24))
    scannerView?.tabBarItem = RAMAnimatedTabBarItem(title: "Scanner", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupActivityView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-2")).resize(CGSize(width: 24, height: 24))
    activityView?.tabBarItem = RAMAnimatedTabBarItem(title: "Activity", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupUserProfileView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-5")).resize(CGSize(width: 24, height: 24))
    userProfileView?.tabBarItem = RAMAnimatedTabBarItem(title: "Profile", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
}