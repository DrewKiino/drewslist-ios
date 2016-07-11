//
//  AccountSettingsController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/21/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import PermissionScope
import Alamofire
import SwiftyJSON

public class AccountSettingsController {
  
  private let model = AccountSettingsModel()
  
  private let pushController = PushController.sharedInstance()
  private let locationController = LocationController.sharedInstance()
  private let userPrivacyController = UserPrivacyController.sharedInstance()
  
  public func getModel() -> AccountSettingsModel { return model }
}