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
import Alamofire
import SwiftyJSON

public let log = Atlantis.Logger()
public let screen = UIScreen.mainScreen().bounds

public enum ServerUrl {
  case Local
  case Staging
  case Default
  public func getValue() -> String {
    switch self {
    case .Local: return "http://localhost:1337"
    case .Staging: return "https://drewslist-staging.herokuapp.com"
//    case .Default: return "http://localhost:1337"
    case .Default: return "https://drewslist-staging.herokuapp.com"
    }
  }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
  
  private let userController = UserController()

  var window: UIWindow?
  
  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    // figure out if user defaults already exist 
    // if it doesn't, create one and persist it.
    if userController.readUserDefaults() == nil { userController.writeNewUserDefaults() }
    
    // configure Atlantis Logger
    Atlantis.Configuration.hasColoredLogs = true
    
    setupRootView()
    
    // on foreground, reset the badge number
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    
    // remove the back button
    UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(0, -60), forBarMetrics: .Default)
    
    // connect to server
    Sockets.sharedInstance().connect()
  
    // MARK: remote notification register fixtures
    UIApplication.sharedApplication().registerForRemoteNotifications()
    
    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    // disconnect from server when app backgrounds
    Sockets.sharedInstance().disconnect()
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    
    // on foreground, reset the badge number
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    
    // connect to server when app enters foreground
    Sockets.sharedInstance().connect()
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    
    // disconnect from server when app terminages
    Sockets.sharedInstance().disconnect()
  }
  
  func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: NSData) {
    
    log.info("deviceToken: \(deviceToken)")
    
    let deviceTokenString = (deviceToken.description as NSString).stringByTrimmingCharactersInSet(NSCharacterSet( charactersInString: "<>")) as String
    
    // set the device token as the default device token in the user defaults
    userController.updateUserDefaults { defaults in
      defaults.deviceToken = deviceTokenString
    }
    
    // get the device token string, then read the current realm user, and update it with the new device token
    userController.updateUserToServer { user in
      user?.deviceToken = deviceTokenString
      return user
    }
  }
  
  func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {
    
    log.debug(userInfo)
  }
  
  private func setupRootView() {
    
    // init the root view
    var tabView: DeleteListingView? = DeleteListingView()
    
//    var tabView: SettingsView? = SettingsView()
//    var tabView: UserProfileView? = UserProfileView()
    
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
}
























