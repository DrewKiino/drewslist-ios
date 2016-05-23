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
    model._profileImage.listen(self) { [weak self] image in
     self?.updateUserInServer()
    }
  }
  
  public func setFirstName(string: String?) {
    model.user?.firstName = string
  }
  
  public func setLastName(string: String?) {
    model.user?.lastName = string
  }
  
  public func setUsername(string: String?) {
    UserModel.sharedUser().user?.username = string
  }
    
    public func setPhone(string: String?) {
        UserModel.sharedUser().user?.phone
    }
    
  
  
  public func updateUserInServer() {
    Alamofire.request(.POST, "\(ServerUrl.Default.getValue())/user/update?_id=\(UserModel.sharedUser().user?._id ?? "")", parameters: [
      "username": UserModel.sharedUser().user?.username ?? false,
      "phone": UserModel.sharedUser().user?.phone ?? false
      ] as [ String: AnyObject ])
      .response { [weak self] req, res, data, error in
        if let error = error {
          log.error(error)
        } else if let data = data, let json: JSON! = JSON(data: data) {
          UserModel.setSharedUser(User(json: json))
        }
    }
  }

    

  
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}
