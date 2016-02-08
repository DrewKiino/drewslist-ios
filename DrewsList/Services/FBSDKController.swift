//
//  FacebookManager.swift
//  DrewsList
//
//  Created by Steven Yang on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit
import SwiftyJSON
import Signals

public class FBSDKController {
  
  private struct Singleton {
    static let facebook = FBSDKController()
  }
  
  public class func sharedInstance() -> FBSDKController { return Singleton.facebook }
  
  public let didFinishGettingUserAttributesFromFacebook = Signal<(User?, [User]?)>()
  
  // MARK: MVC
  private let model = FBSDKModel()
  
  // MARK: Realm
  private var user: User?
  
  private func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { user = realmUser.getUser() } }
  private func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.user), update: true) } }
  
  // MARK: Facebook
  /// Basic Info
  private var id: String?
  private var email: String?
  private var first_name: String?
  private var last_name: String?
  private var gender: String?
  private var age_range: String?
  private var link: String?
  private var locale: String?
  private var pictureURL: String?
  private var cover: String?
  private var timezone: String?
  private var updated_time: String?
  private var verified: String?
  
  /// Social
  private var friends: JSON?
  
  public func userIsLoggedIntoFacebook() -> Bool { return FBSDKAccessToken.currentAccessToken() != nil }
 
  public func populateBasicFBUserInfo(callback: Bool -> Void) {
    if userIsLoggedIntoFacebook() {
      FBSDKGraphRequest.init(graphPath: "me?fields=id,email,first_name,last_name,gender,age_range,link,locale,picture,cover,timezone,updated_time,verified", parameters: nil)
      .startWithCompletionHandler() { [weak self] (connection, result, error) in
        
        if let error = error {
          
          log.error(error)
          
          return callback(false)
          
        } else if let result = result, let json: JSON! = JSON(result) {
          
          // create a user
          let user = User()
          
          // add the attributes received from facebook
          user.facebook_id = json["id"].string
          user.facebook_link = json["link"].string
          user.facebook_update_time = json["updated_time"].string
          user.facebook_verified = json["verified"].string
          user.email = json["email"].string
          user.firstName = json["first_name"].string
          user.lastName = json["last_name"].string
          user.gender = json["gender"].string
          user.age_min = json["age_range"]["min"].string
          user.age_max = json["age_range"]["max"].string
          user.locale = json["locale"].string
          user.imageUrl = json["picture"]["data"]["url"].string
          user.bgImage = json["cover"]["source"].string
          user.timezone = json["timezone"].string
          
          self?.model.user = user
          
          return callback(true)
        }
        
        return callback(false)
      }
    }
  }
  
  public func populateListOfFBFriends(callback: Bool -> Void) {
    if userIsLoggedIntoFacebook() {
      FBSDKGraphRequest.init(graphPath: "me?fields=friends", parameters: nil)
      .startWithCompletionHandler() { [weak self] (connection, result, error: NSError!) in
        if let error = error {
          
          log.error(error)
          
          return callback(false)
          
        } else if let result = result, let jsonArray = JSON(result)["friends"]["data"].array {
          
          self?.model.friends.removeAll(keepCapacity: false)
          
          for json in jsonArray {
            let user = User()
            user.facebook_id = json["id"].string
            user.firstName = json["name"].string?.componentsSeparatedByString(" ").first
            user.lastName = json["name"].string?.componentsSeparatedByString(" ").last
            self?.model.friends.append(user)
          }
          
          return callback(true)
        }
        
        return callback(false)
      }
    }
  }
  
  public func getUserAttributesFromFacebook() {
    populateBasicFBUserInfo() { [weak self] bool in
      self?.populateListOfFBFriends() { [weak self] bool in
        self?.didFinishGettingUserAttributesFromFacebook.fire((self?.model.user, self?.model.friends))
      }
    }
  }
  
  public func getBasicFBUserInfo() -> (id: String?, email: String?, first_name: String?, last_name: String?, gender: String?, age_range: String?, link: String?, locale: String?, picture: String?, cover: String?, timezone: String?, updated_time: String?, verified: String?) {
    return (self.id, self.email, self.first_name, self.last_name, self.gender, self.age_range, self.link, self.locale, self.pictureURL, self.cover, self.timezone, self.updated_time, self.verified)
  }
  
  public func getListOfFBFriends() -> JSON? {
    if let friends = friends {
      return friends
    } else {
      print("Problem retrieving friends")
      return nil
    }
  }
  
  public func disconnect() {
    if let token = FBSDKAccessToken.currentAccessToken() {
      print("User \(token) will be logged out")
      FBSDKAccessToken.setCurrentAccessToken(nil)
    } else { print("User could not be logged out") }
  }
}
