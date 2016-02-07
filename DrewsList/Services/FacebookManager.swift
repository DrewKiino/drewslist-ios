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

public class FacebookManager {
  private struct Singleton {
    static let facebook = FacebookManager()
    weak var delegate: FBSDKLoginButtonDelegate?
  }
  
  public class func sharedInstance() -> FacebookManager { return Singleton.facebook }
  
  // MARK: Realm Functions
  
  private var user: User?
  
  private func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { user = realmUser.getUser() } }
  private func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.user), update: true) } }
  
  // MARK: Facebook Functions
  private func userIsLoggedIntoFacebook() -> Bool {
    if let _ = FBSDKAccessToken.currentAccessToken() { return true } else { return false }
  }
  
  public func getBasicFBUserInfo() -> User? {
    if userIsLoggedIntoFacebook() {
      print("User logged into FB")
      FBSDKGraphRequest.init(graphPath: "me?fields=id,email,first_name,last_name,gender,age_range,link,locale,picture,cover,timezone,updated_time,verified", parameters: nil).startWithCompletionHandler({ (connection, result, error) -> Void in
        guard let result = result else {
          print(error)
          return
        }
        let json = JSON(result)
        print(json)
        //          if let fullname = json["name"].string {
        //            self.model.user?.username = fullname;
        //            print("The user name is: \(fullname)")
        //            let fullNameArray = fullname.characters.split{$0 == " "}.map(String.init)
        //            self.model.user?.firstName = fullNameArray[0]
        //            self.model.user?.lastName = fullNameArray[1]
        //            print("First name is \(fullNameArray[0])")
        //            print("Last name is \(fullNameArray[1])")
        //          }
      })
      
            //
      //      let coverRequest = FBSDKGraphRequest(graphPath: "me?fields=cover", parameters: nil)
      //        coverRequest.startWithCompletionHandler({
      //          (connection, result, error: NSError!) -> Void in
      //          if let error = error {
      //            print(error)
      //          } else {
      //            let json = JSON(result)
      //            //print(json)
      //            print("Cover url is: \(json["cover"]["source"])")
      //          }
      //        })
      //
    }
    guard let user = user else { return nil }
    return user
  }
  
  public func getFBProfilePictureURL() -> String? {
    if userIsLoggedIntoFacebook() {
      let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
      var pictureUrl: String?
      pictureRequest.startWithCompletionHandler({
        (connection, result, error: NSError!) -> Void in
        if error == nil {
          let json = JSON(result)
          pictureUrl = json["data"]["url"].description
          print("Profile picture url is: \(json["data"]["url"])")
        } else {
          print(error)
        }
      })
      if let picture = pictureUrl {
        return picture
      } else { return nil }
    } else { return nil }
  }
  
  public func getListOfFBFriends() -> JSON? {
    if userIsLoggedIntoFacebook() {
      let friendsRequest = FBSDKGraphRequest(graphPath: "me?fields=friends", parameters: nil)
      var json: JSON?
      friendsRequest.startWithCompletionHandler({
        (connection, result, error: NSError!) -> Void in
        if let error = error {
          print(error)
        } else {
          json = JSON(result)
          print(json)
        }
      })
      if let json = json { return json } else { return nil }
    } else { return nil }
  }
  
  public func disconnect() {
    if let token = FBSDKAccessToken.currentAccessToken() {
      print("User \(token) will be logged out")
      FBSDKAccessToken.setCurrentAccessToken(nil)
    } else { print("User could not be logged out") }
  }
  
  // MARK: Delegates
  public func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    if let error = error {
      // Process error
      print("Login Button Error: \(error)")
    }
    else if result.isCancelled {
      // Handle cancellations
      print("FB login has been cancelled")
    }
    else {
      print("User is logged in")
      // Navigate to other view
      print("Naviating to the new view")
//      self.delegate.presentViewController(TabView(), animated: true, completion: nil)
    }
  }
  
  public func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    print("User Logged Out")
  }
}
