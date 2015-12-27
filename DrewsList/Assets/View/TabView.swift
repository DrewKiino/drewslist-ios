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
import RealmSwift

public class TabView: UITabBarController {
  
  private let controller = TabController()
  private var model: TabModel { get { return controller.model } }
  
  var testView = CreateListingView()
  var communityView: CommunityFeedView? = CommunityFeedView()
  var chatView: ChatHistoryView?  = ChatHistoryView()
  var scannerView: ScannerView? = ScannerView()
  var activityView: ActivityFeedView? = ActivityFeedView()
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
    tabBar.barTintColor = .whiteColor()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkIfUserIsLoggedIn()
  }
  
  private func setupViewControllers() {
    
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-1")).resize(CGSize(width: 24, height: 24))
    testView.tabBarItem = UITabBarItem(title: "Test View", image: toucan!.image, selectedImage: toucan!.image)
    toucan = nil
//    viewControllers = [userProfileView!, scannerView!, communityTab!, chatView!]
    
    // set view controllers
    viewControllers = [communityView!, chatView!, scannerView!, activityView!, userProfileView!]
    
    // dealloc reference view controllers
    communityView = nil
    chatView = nil
    scannerView = nil
    activityView = nil
    userProfileView = nil
  }
  
  private func setupCommunityTab() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-1")).resize(CGSize(width: 24, height: 24))
    communityView?.tabBarItem = UITabBarItem(title: "Community", image: toucan!.image, selectedImage: toucan!.image)
    toucan = nil
  }
  
  private func setupChatView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-4")).resize(CGSize(width: 24, height: 24))
    chatView?.tabBarItem = UITabBarItem(title: "Chat", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupISBNScannerView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-3")).resize(CGSize(width: 24, height: 24))
    scannerView?.tabBarItem = UITabBarItem(title: "Scanner", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupActivityView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-2")).resize(CGSize(width: 24, height: 24))
    activityView?.tabBarItem = UITabBarItem(title: "Activity", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupUserProfileView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "TabBarIcons-5")).resize(CGSize(width: 24, height: 24))
    userProfileView?.tabBarItem = UITabBarItem(title: "Profile", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  // MARK: User Auth
  public func checkIfUserIsLoggedIn() {
    if !controller.checkIfUserIsLoggedIn() { presentViewController(LoginView(), animated: false, completion: nil) }
  }
}








