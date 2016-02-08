//
//  TabViewController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/24/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift
import FBSDKLoginKit

public class TabController {
  
  public let model = TabModel()
  
  public var refrainTimer: NSTimer?
  
  public init() {
    // NOTE: Important! These functions have to be called in this order
    readRealmUser()
  }
  
  public func checkIfUserIsLogginInToFacebook() -> Bool {
      if FBSDKController.sharedInstance().userIsLoggedIntoFacebook() {
        print("User logged into FB")
//        FBSDKController.sharedInstance().populateBasicFBUserInfo()
//        FBSDKController.sharedInstance().populateListOfFBFriends()
      return true
    } else {
      print("User is not logged into FB")
      return false
    }
  }
  
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
  // this one deletes all prior users
  // we should only have one user in database, and that should be the current user
  public func deleteRealmUser(){ try! Realm().write { try! Realm().deleteAll() } }
}