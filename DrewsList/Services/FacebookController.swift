//
//  FacebookController.swift
//  DrewsList
//
//  Created by Steven Yang on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit

public class FacebookController {
  private struct Singleton {
    static let facebook = FacebookController()
  }
  
  public class func sharedInstance() -> FacebookController { return Singleton.facebook }
  
  // MARK: Realm Functions
  
  private var user: User?
  
  private func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { user = realmUser.getUser() } }
  private func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.user), update: true) } }
  
  // MARK: Facebook Functions
  public func disconnect() {
    if let token = FBSDKAccessToken.currentAccessToken() {
      print("User \(token) will be logged out")
      FBSDKAccessToken.setCurrentAccessToken(nil)
    }
  }
}
