//
//  AppDelegate.swift
//  DrewsList
//
//  Created by Andrew Aquino on 10/28/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import Signals

public let log = Atlantis.Logger()
public let remoteNotification = Signal<[NSObject: AnyObject]>()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?
  
  private let socket = Sockets.sharedInstance()

  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    // Override point for customization after application launch.
    
    // set the window
//    let rootView = UINavigationController(rootViewController: ChatView())
    let rootView = UINavigationController(rootViewController: ChatHistoryView())
    rootView.view.frame = UIScreen.mainScreen().bounds
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    window!.rootViewController = rootView
    window!.makeKeyAndVisible()
    
    // create a WebSocket connection to the server
    socket.connect() {
      let userController = UserController.sharedInstance()
      userController.login()
    }
    
    // configure Atlantis Logger
    Atlantis.Configuration.hasColoredLogs = true
    
    // PUSH NOTIFICATION
    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
    application.registerUserNotificationSettings(settings)
    application.registerForRemoteNotifications()
    
    // on foreground, reset the badge number
    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
    
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
      // publish to server that the app received the push notification
      socket.emit("didReceivePushNotification", ["user_id": user_id], forceConnection: true)
    }
  }
}

