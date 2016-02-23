//
//  ProfileImagePickerController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKCoreKit
import Alamofire

public class ProfileImagePickerController {
  
  public let model = ProfileImagePickerModel()
  private let fbsdkController = FBSDKController()
  
  public init() {
    setupDataBinding()
    setupFBProfile()
  }
  
  public func setupDataBinding() {
    
  }
 
  public func setupFBProfile(){
    let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
    pictureRequest.startWithCompletionHandler({
      (connection, result, error: NSError!) -> Void in
      if error == nil {
        if let url = result["data"]["url"]{
          self.model.fbProfileImageURL = "\(url)"
        }
      } else {
        print("\(error)")
      }
    })
  }
  
  public func updateUserInServer() {
    UserController.sharedInstance().updateUserToServer() { [weak self] user in
      user?.imageUrl = self?.model.user?.imageUrl
      return user
    }
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
