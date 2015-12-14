//
//  OnboardingController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import PermissionScope

public class OnboardingController {
  
  private let model = OnboardingModel()
  private let pscope = PermissionScope()
  
  public init() {
    initializePScope()
  }
  
  private func initializePScope() {
    
    pscope.headerLabel.text = "Hey cool person!"
    pscope.bodyLabel.text = "Let us enhance your app experience with live updates."
    
    // Set up permissions
    pscope.addPermission(NotificationsPermission(notificationCategories: nil), message: "Thanks in advance.")
  }
  
  public func showPermissions() {
    
    // manual push perm
//    let settings = UIUserNotificationSettings(forTypes: [.Alert, .Badge], categories: nil)
//    application.registerUserNotificationSettings(settings)
//    application.registerForRemoteNotifications()
    
    switch PermissionScope().statusNotifications() {
    case .Unknown:
      // Show dialog with callbacks
      pscope.show({ finished, results in
        for result in results {
          switch result.status {
          case .Authorized:
            UIApplication.sharedApplication().registerForRemoteNotifications()
            break
          default: break
          }
        }
      }, cancelled: { (results) -> Void in
      })
    case .Unauthorized, .Disabled: return
    case .Authorized:
      SweetAlert().showAlert("Already authorized!", subTitle: nil, style: .Success, buttonTitle: "Ok", buttonColor: .soothingBlue())
      return
    }
  }
}