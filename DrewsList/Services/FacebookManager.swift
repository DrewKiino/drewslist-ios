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

public class FBSDKController {
  
  private struct Singleton {
    static let facebook = FBSDKController()
  }
  
  public class func sharedInstance() -> FBSDKController { return Singleton.facebook }
  
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
  
  public func userIsLoggedIntoFacebook() -> Bool {
    if let _ = FBSDKAccessToken.currentAccessToken() { return true } else { return false }
  }
 
  public func populateBasicFBUserInfo() {
    if userIsLoggedIntoFacebook() {
      FBSDKGraphRequest.init(graphPath: "me?fields=id,email,first_name,last_name,gender,age_range,link,locale,picture,cover,timezone,updated_time,verified", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
        guard let result = result else {
          print(error)
          return
        }
        let json = JSON(result)
        print(json)
        
        // Add the result data to local variables
        self.id = json["id"].string
        self.email = json["email"].string
        self.first_name = json["first_name"].string
        self.last_name = json["last_name"].string
        self.gender = json["gender"].string
        self.age_range = json["age_range"].string
        self.link = json["link"].string
        self.locale = json["locale"].string
        self.pictureURL = json["picture"]["data"]["url"].string
        self.cover = json["cover"]["source"].string
        self.timezone = json["timezone"].string
        self.updated_time = json["updated_time"].string
        self.verified = json["verified"].string
      })
    }
  }
  
  public func populateListOfFBFriends() {
    if userIsLoggedIntoFacebook() {
      let friendsRequest = FBSDKGraphRequest.init(graphPath: "me?fields=friends", parameters: nil)
      friendsRequest.startWithCompletionHandler({
        (connection, result, error: NSError!) -> Void in
        if let error = error {
          print(error)
        } else {
          print(result)
          self.friends = JSON(result)
        }
      })
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
