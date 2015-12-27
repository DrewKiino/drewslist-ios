//
//  AppDelegate.swift
//  DrewsList
//
//  Created by Andrew Aquino on 10/28/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import Signals
import RealmSwift

public let log = Atlantis.Logger()
public let screen = UIScreen.mainScreen().bounds

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    // figure out if user defaults already exist 
    // if it doesn't, create one and persist it.
    if readUserDefaults() == nil { writeNewUserDefaults() }
    
    // configure Atlantis Logger
    Atlantis.Configuration.hasColoredLogs = true
    
    setupRootView()
    
    // on foreground, reset the badge number
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    
    // remove the back button
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // on foreground, reset the badge number
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    log.info("deviceToken: \(deviceToken)")
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    
    // log the push message
    if  let aps = userInfo["aps"] as? NSDictionary,
        let alert = aps.valueForKey("alert"),
        let payload = userInfo["payload"] as? NSDictionary,
        let user_id = payload.valueForKey("user_id")
    {
      log.info("received remote notification from server: \(alert)")
    }
  }
  
  private func setupRootView() {
    
    // init the root view
//    var tabView: TabView? = TabView()
    var tabView: SearchUserView? = SearchUserView()
    
    /*
    * Use this code to get the bounds of the screen
    *
    *       UIScreen.mainScreen().bounds
    *
    */
    tabView?.view.frame = UIScreen.mainScreen().bounds
    
    // set the window to match the screen's bounds
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    
    // set the root view as the window's root view
    window?.rootViewController = tabView
    tabView = nil
    
    // commit change
    window?.makeKeyAndVisible()
  }
  
  // MARK: Realm Functions
  func readUserDefaults() -> UserDefaults? { if let defaults =  try! Realm().objects(UserDefaults.self).first { return defaults } else { return nil } }
  func writeNewUserDefaults(){ try! Realm().write { try! Realm().delete(Realm().objects(UserDefaults.self)); try! Realm().add(UserDefaults(), update: true) } }
}


public class UserDefaults: Object {
  
  dynamic var _id: String?
  
  // onboarding
  dynamic var didShowOnboarding: Bool = false
  
  // school selection
  dynamic var school: String?
  dynamic var state: String?
  
  public override static func primaryKey() -> String? {
    return "_id"
  }
}


