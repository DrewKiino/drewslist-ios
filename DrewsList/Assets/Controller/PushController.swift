//
//  PushController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/12/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import PermissionScope

public class PushController {
  
  private struct Singleton {
    static let pushController = PushController()
  }
  
  public class func sharedInstance() -> PushController { return Singleton.pushController }
  
  public let model = PushModel()
  
  private let permissionScope = PermissionScope()
  
  public init() {
    setupPermissionScope()
  }
  
  private func setupPermissionScope() {
    
    permissionScope.headerLabel.text = "Hey cool person!"
    permissionScope.bodyLabel.text = "Let us enhance your app experience with live updates."
    
    // Set up permissions
    permissionScope.addPermission(NotificationsPermission(notificationCategories: nil), message: "Thanks in advance.")
  }
  
  public func removeNotificationsAllowed() -> Bool {
    
//    return permissionScope.statusNotifications()
    return true
  }
  
  public func showPermissions() {
    
    // manual push perm
    //    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
    //    application.registerUserNotificationSettings(settings)
    //    application.registerForRemoteNotifications()
    
//    switch PermissionScope().statusNotifications() {
//    case .Unknown:
      // Show dialog with callbacks
//      pscope.show({ finished, results in
//        for result in results {
//          switch result.status {
//          case .Authorized:
//            UIApplication.sharedApplication().registerForRemoteNotifications()
//            break
//          default: break
//          }
//        }
//        }, cancelled: { (results) -> Void in
//      })
//    case .Unauthorized, .Disabled: return
//    case .Authorized:
//      SweetAlert().showAlert("Already authorized!", subTitle: nil, style: .Success, buttonTitle: "Ok", buttonColor: .soothingBlue())
//      return
//    }
  }
}





















