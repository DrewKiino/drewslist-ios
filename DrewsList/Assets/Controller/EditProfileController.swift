//
//  EditProfileController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON

public class EditProfileController {

  public let model = EditProfileModel()
  
  public func setUp() {
  }
  
  public func setupDataBinding() {
  }
  
  public func setFirstName(string: String?) {
    UserModel.sharedUser().user?.firstName = string
  }
  
  public func setLastName(string: String?) {
     UserModel.sharedUser().user?.lastName = string
  }
  
  public func setUsername(string: String?) {
     UserModel.sharedUser().user?.username = string
  }
    
  public func setPhone(string: String?) {
    if let string = string where string.isValidPhoneNumber() {
      UserModel.sharedUser().user?.phone = Int(string)
    }
  }

  public func saveEdit() {
    log.debug("saving user...")
    log.debug(UserModel.sharedUser().user?.phone)
    UserController.updateUserToServer() { [weak self] user in
      log.debug(user?.phone)
      log.debug("user saved.")
      self?.model.user = user
    }
  }
}
