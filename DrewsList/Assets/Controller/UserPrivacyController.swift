//
//  PermissionsController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals
import Alamofire
import SwiftyJSON

public class UserPrivacyController {
  
  // MARK: Singleton instance
  
  private struct Singleton { static let userPrivacyController = UserPrivacyController() }
  public class func sharedInstance() -> UserPrivacyController { return Singleton.userPrivacyController }
  
  public init() {
    UserModel.sharedUser()._user.removeListener(self)
    UserModel.sharedUser()._user.listen(self) { [weak self] user in
      self?.privatePhoneNumber = user?.privatePhoneNumber
    }
  }
  
  private func setupDataBinding() {
    
  }
  
  public let _privatePhoneNumber = Signal<Bool?>()
  public var privatePhoneNumber: Bool? = false {
    didSet {
      _privatePhoneNumber => privatePhoneNumber
      UserModel.sharedUser().user?.privatePhoneNumber = privatePhoneNumber ?? false
    }
  }
  
  public func hasPrivatePhoneNumber() -> Bool? {
    privatePhoneNumber = UserModel.sharedUser().user?.privatePhoneNumber ?? false
    return privatePhoneNumber
  }
  
  public func updateUserPrivacySettingsInServer() {
    Alamofire.request(.POST, "\(ServerUrl.Default.getValue())/user/\(UserModel.sharedUser().user?._id ?? "")", parameters: [
      "privatePhoneNumber": UserModel.sharedUser().user?.privatePhoneNumber ?? false
    ] as [ String: AnyObject ])
    .response { [weak self] req, res, data, error in
      if let error = error {
        log.error(error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        UserModel.setSharedUser(User(json: json))
      }
    }
  }
}