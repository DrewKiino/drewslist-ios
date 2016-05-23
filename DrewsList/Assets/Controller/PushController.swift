//
//  PushController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/12/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import PermissionScope
import UIKit
import Signals

public class PushController {
  
  private struct Singleton {
    static let pushController = PushController()
  }
  
  public class func sharedInstance() -> PushController { return Singleton.pushController }
  
  private let model = PushModel()
  
  public let _didUpdateAuthorizationStatus = Signal<Bool>()
  
  public init() {
    model._authorizationStatus.removeListener(self)
    model._authorizationStatus.listen(self) { [weak self] bool in
      self?._didUpdateAuthorizationStatus.fire(bool)
    }
    _didRegisterForRemoteNotificationsWithDeviceToken.removeListener(self)
    _didRegisterForRemoteNotificationsWithDeviceToken.listen(self) { [weak self] bool in
      self?.model.authorizationStatus = bool
    }
  }
  
  public func isRegisteredForRemoteNotifications() -> Bool? {
    
    model.authorizationStatus = UIApplication.sharedApplication().isRegisteredForRemoteNotifications()
    
    if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue == 0 {
      return nil
    } else if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue > 0 {
      return true
    }
    
    return model.authorizationStatus
  }
  
  public func registerForRemoteNotifications() {
    UIApplication.sharedApplication().registerForRemoteNotifications()
  }
  
  public func showPermissions(force: Bool) -> Bool {
    
    if UIApplication.sharedApplication().currentUserNotificationSettings()?.types.rawValue == 0 {
      UIApplication.sharedApplication().registerUserNotificationSettings(UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil))
      UIApplication.sharedApplication().registerForRemoteNotifications()
      return true
    } else if force {
      
      let alertController = UIAlertController(title: "Permissions", message: "We send you push notifications to notify you with the latest app updates including chats, listings, etc!", preferredStyle: .Alert)
      alertController.addAction(UIAlertAction(title: "Open app settings", style: UIAlertActionStyle.Default) { action in
        NSTimer.after(0.2) {
          if let nsurl = NSURL(string: UIApplicationOpenSettingsURLString) { UIApplication.sharedApplication().openURL(nsurl) }
        }
      })
      alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
      })
      
      UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
    }
    
    return false
  }
}





















