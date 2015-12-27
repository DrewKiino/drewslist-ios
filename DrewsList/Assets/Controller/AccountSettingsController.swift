//
//  AccountSettingsController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/21/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import PermissionScope

public class AccountSettingsController {
  
  private let model = AccountSettingsModel()
  
  public func getModel() -> AccountSettingsModel { return model }
  
  // MARK: Realm Functions 
  public func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }

  private let Pscope = PermissionScope()
  
  
  public init () {
    initilize_Pscope()
  }
  
  private func initilize_Pscope() {
    
    Pscope.headerLabel.text = "Hello"
    Pscope.bodyLabel.text = "Do you want to log with Facebook."
    
    //PermissionSetUps
    Pscope.addPermission(NotificationsPermission(notificationCategories:
      nil ), message: "Thanks for the reply")
    
    
  }
  
  public func permissionsAppear() {
    
    switch PermissionScope().statusNotifications() {
    case .Unknown:
      
      Pscope.show({ finished, results in
        for result in results{
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
      SweetAlert().showAlert("Already Signed In!", subTitle: nil, style: .Success,
        buttonTitle: "Ok", buttonColor: .soothingBlue())
      return
      
    }
  }
}