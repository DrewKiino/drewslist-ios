//
//  EditProfileController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift

public class EditProfileController {

  public let model = EditProfileModel()
  
  public func setUp() {
  }
  
  public func setupDataBinding() {
    model._profileImage.listen(self) { [weak self] image in
     self?.updateUserInServer()
    }
  }
  
  private func updateUserInServer() {
    
  }
  
  public func setFirstName(string: String?) {
    model.user?.firstName = string
  }
  
  public func setLastName(string: String?) {
    model.user?.lastName = string
  }
  
  public func setUsername(string: String?) {
    UserModel.sharedUser().user?.username = string
    //model.user?.username = string
  }
  
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}
