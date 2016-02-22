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
import Alamofire
import SwiftyJSON

public class AccountSettingsController {
  
  private let model = AccountSettingsModel()
  
  private let pushController = PushController.sharedInstance()
  private let locationController = LocationController.sharedInstance()
  private let userPrivacyController = UserPrivacyController.sharedInstance()
  
  public func getModel() -> AccountSettingsModel { return model }
  
  public init () {
    setupSelf()
    setupDataBinding()
  }
  
  public func viewDidAppear() {
    // init user
    model.user = UserModel.sharedUser().user
    // check permissions
    pushController.isRegisteredForRemoteNotifications()
    locationController.isRegisteredForLocationUpdates()
  }
  
  public func viewWillDisappear() {
    userPrivacyController.updateUserPrivacySettingsInServer()
  }
  
  private func setupSelf() {
  }
  
  private func setupDataBinding() {
    // databind to the shared user
    UserModel.sharedUser()._user.removeListener(self)
    UserModel.sharedUser()._user.listen(self) { [weak self] user in
      // set the user whenever the shared user changes
      self?.model.user = user
    }
  }
  
  public func deleteAccount() {
    Alamofire.request(.DELETE, "\(ServerUrl.Default.getValue())/\(model.user?._id ?? "")")
    .response { [weak self] req, res, data, error in
      log.debug(JSON(data: data!))
    }
  }
  
  public func checkPushNotificationsPermission() {
  }
}