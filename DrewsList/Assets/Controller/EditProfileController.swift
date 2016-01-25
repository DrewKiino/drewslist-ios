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
  
    let user = User()
    user.imageUrl = "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwinxvapkezJAhUMKyYKHR3CAskQjRwIBw&url=http%3A%2F%2Fengineering.unl.edu%2Fkayla-person%2F&psig=AFQjCNFJgRTV0bIR5OTWTumjJpDKdjFU5w&ust=1450759200227606"
    user.firstName = "Kevin"
    user.lastName = "Mowers"
    user.username = "KasperSeas"
    model.user = user
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
    model.user?.username = string
  }
  
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}
