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
  var userProfileView: UserProfileViewContainer? = UserProfileViewContainer()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    setupCommunityTab()
    setupChatView()
    setupISBNScannerView()
    setupActivityView()
    setupUserProfileViewContainer()
    setupViewControllers()
    
    tabBar.translucent = false
    tabBar.tintColor = .soothingBlue()
    tabBar.barTintColor = .whiteColor()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    checkIfUserIsLoggedIn()
  }
  
  private func setupDataBinding() {
    model._shouldLogout.removeAllListeners()
    model._shouldLogout.listen(self) { [weak self] bool in
      if bool == true { self?.presentViewController(LoginView(), animated: false, completion: nil) }
    }
  }
  
  private func setupViewControllers() {
    
    var toucan: Toucan? = Toucan(image: UIImage(named: "DrewsListTabBar_Icon-1")).resize(CGSize(width: 24, height: 24))
    testView.tabBarItem = UITabBarItem(title: "Test View", image: toucan!.image, selectedImage: toucan!.image)
    toucan = nil
    
//    viewControllers = [searchBookView!]
    
    // set view controllers
    viewControllers = [communityView!, chatView!, scannerView!, activityView!, userProfileView!]
    
    // first initialize both the chat history view and activity feed view
    selectedIndex = 1
    selectedIndex = 3
    
    // fixture selected index
    selectedIndex = 3
    
    // dealloc reference view controllers
    communityView = nil
    chatView = nil
    scannerView = nil
    activityView = nil
    userProfileView = nil
  }
  
  private func setupCommunityTab() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "DrewsListTabBar_Icon-1")).resize(CGSize(width: 24, height: 24))
    communityView?.tabBarItem = UITabBarItem(title: "Community", image: toucan!.image, selectedImage: toucan!.image)
    toucan = nil
  }
  
  private func setupChatView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "DrewsListTabBar_Icon-3")).resize(CGSize(width: 24, height: 24))
    chatView?.tabBarItem = UITabBarItem(title: "Chat", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupISBNScannerView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "DrewsListTabBar_Icon-2")).resize(CGSize(width: 24, height: 24))
    scannerView?.tabBarItem = UITabBarItem(title: "Scanner", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupActivityView() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "DrewsListTabBar_Icon-5")).resize(CGSize(width: 24, height: 24))
    activityView?.tabBarItem = UITabBarItem(title: "Activity", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  private func setupUserProfileViewContainer() {
    var toucan: Toucan? = Toucan(image: UIImage(named: "DrewsListTabBar_Icon-4")).resize(CGSize(width: 24, height: 24))
    userProfileView?.tabBarItem = UITabBarItem(title: "Profile", image: toucan?.image, selectedImage: toucan?.image)
    toucan = nil
  }
  
  // MARK: User Auth
  public func checkIfUserIsLoggedIn() {
    if !controller.checkIfUserIsLoggedIn() && !controller.checkIfUserIsLogginInToFacebook() { presentViewController(LoginView(), animated: false, completion: nil) }
  }
  
  // tab switch functions
  public class func presentChatView(chatView: ChatView) {
    // get the chat history view of the tab view
    if  let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView,
        let chatHistoryView = (tabView.viewControllers?.filter { $0.isKindOfClass(ChatHistoryView) })?.first as? ChatHistoryView
    {
      // dismiss the current view controller
      tabView.dismissViewControllerAnimated(true, completion: nil)
      // go to teh selected index
      tabView.selectedIndex = 1
      // pop any existing chat views
      chatHistoryView.popToRootViewControllerAnimated(false)
      // push the new corresponding chat view
      chatHistoryView.pushViewController(chatView, animated: false)
    }
  }
}








