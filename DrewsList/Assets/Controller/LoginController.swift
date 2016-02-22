//
//  ViewController.swift
//  Swifty
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 Flowers Designs. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON
import Signals
import FBSDKLoginKit

public class LoginController {
  
  // MARK: Singleton
  
  private struct Singleton { static let loginController = LoginController() }
  public class func sharedInstance() -> LoginController { return Singleton.loginController }
  
  public let model = LoginModel()
  
  private let userController = UserController()
  private let fbsdkController = FBSDKController()
  
  public let shouldDismissView = Signal<Bool>()
  public let shouldPresentPhoneInputView = Signal<Bool>()
  
  private var refrainTimer: NSTimer?
  
  public init() {
    setupDataBinding()
  }
  
  private func setupDataBinding() {
    model._shouldLogout.removeAllListeners()
    model._shouldLogout.listen(self) { [weak self] shouldLogout in
      if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView where shouldLogout {
        tabView.presentViewController(LoginView(), animated: false, completion: nil)
      }
    }
    fbsdkController.didFinishGettingUserAttributesFromFacebook.removeAllListeners()
    fbsdkController.didFinishGettingUserAttributesFromFacebook.listen(self) { [weak self] user, friends in
      // set the state of the model
      self?.model.isCurrentlyAuthenticatingUserWithFacebook = true
      // set the model's email with the created user email
      self?.model.email = user?.email
      // set the user and friends as well
      self?.model.user = user
      self?.model.friends = friends ?? []

      // authenticate user
      self?.authenticateUserToServer(false)
    }
  }
  
  public func checkIfUserIsLoggedIn() -> Bool {
    // check if user is already logged in
    if let user = try! Realm().objects(RealmUser.self).first?.getUser() where user._id != nil {
      
      // set the user's model
      model.user = user
      
      getUserFromServer()
      
      // dismiss the view
      shouldDismissView.fire(true)
      
    // check if user is logged into facebook
    } else if fbsdkController.userIsLoggedIntoFacebook() {
      
      fbsdkController.getUserAttributesFromFacebook()
      
    // if we already have a user, attempt to call the server to update the current user
    // if not show login view
    } else if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView {
      
      tabView.presentViewController(LoginView(), animated: false) { bool in
        // else, log use out of facebook
        FBSDKLoginManager().logOut()
      }
    }
    
    return false
  }
  
  public func getUserFromServer() {
    guard let user_id = model.user?._id else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, ServerUrl.Default.getValue() + "/user", parameters: [ "_id": user_id ], encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        
        log.error(error)
        
      } else if let data = data, let json: JSON! = JSON(data: data) where !json.isEmpty && json["error"].string != "user is undefined" {
        
        // create and  user object
        self?.model.user = User(json: json)
        // set the shared user instance
        UserController.setSharedUser(self?.model.user)
        // write user object to realm
        self?.writeRealmUser()
        
        // dismiss the view
        self?.shouldDismissView.fire(true)
        
      // user does not exist in database
      } else {
        
        // nullify the model and
        // delete the deprecated user
        self?.model.user = nil
        self?.deleteRealmUser()
        // then log user out
        self?.model.shouldLogout = true
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.refrainTimer = NSTimer.after(3.0) { [weak self] in
        self?.model.shouldRefrainFromCallingServer = false
      }
    }
  }
  
  public func authenticateUserToServer(localAuth: Bool = true) {
    guard let email = model.email else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Sockets.sharedInstance().on("authenticateUser.response") { [weak self] json in
      
      if json["errmsg"].string != nil || json["error"].string != nil {
        
        // update the UI if the authentication session was done through local auth
        if localAuth {
          if json["error"].string?.containsString("email") == true {
            self?.model._isValidEmail.fire(false)
          } else if json["error"].string?.containsString("password") == true {
            self?.model._isValidPassword.fire(false)
          } else {
            self?.model._serverError.fire(true)
          }
        }
        
        // if theres an error, log the user out
        FBSDKLoginManager().logOut()
        
      } else {
        
        // create and  user object
        self?.model.user = User(json: json)
        
        // set the shared user instance
        UserController.setSharedUser(self?.model.user)
        // write user object to realm
        self?.writeRealmUser()
        
        // set user online status to true
        Sockets.sharedInstance().setOnlineStatus(true)
        
        if self?.model.user?.phone == nil {
          self?.shouldPresentPhoneInputView.fire(true)
        } else {
          self?.shouldDismissView.fire(true)
        }
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.model.shouldRefrainFromCallingServer = false
    }
    
    let password: String = model.password ?? ""
    let phone: String = model.phone ?? ""
    // NOTE: password is not given by facebook
    // facebook attributes
    let facebook_id: String = model.user?.facebook_id ?? ""
    let facebook_link: String = model.user?.facebook_link ?? ""
    let facebook_update_time: String = model.user?.facebook_update_time ?? ""
    let facebook_verified: String = model.user?.facebook_verified ?? ""
    let gender: String = model.user?.gender ?? ""
    let age_min: String = model.user?.age_min ?? ""
    let age_max: String = model.user?.age_max ?? ""
    let locale: String = model.user?.locale ?? ""
    let image: String = model.user?.imageUrl ?? ""
    let bgImage: String = model.user?.bgImage ?? ""
    let timezone: String = model.user?.timezone ?? ""
    let firstName: String = model.user?.firstName ?? ""
    let lastName: String = model.user?.lastName ?? ""
    let deviceToken: String = userController.readUserDefaults()?.deviceToken ?? ""
    
    var friends = [[String: AnyObject]]()
    for friend in model.friends {
      let friend_facebook_id: String = friend.facebook_id ?? ""
      let friend_firstName: String = friend.firstName ?? ""
      let friend_lastName: String = friend.lastName ?? ""
      friends.append([
        "facebook_id": friend_facebook_id,
        "firstName": friend_firstName,
        "lastName": friend_lastName
      ] as [String: AnyObject ])
    }
    
    Sockets.sharedInstance().emit("authenticateUser", [
      "email": email,
      "password": password,
      "phone" : phone,
      // NOTE: password is not given by facebook
      // facebook attributes
      "facebook_id": facebook_id,
      "facebook_link": facebook_link,
      "facebook_update_time": facebook_update_time,
      "facebook_verified": facebook_verified,
      "gender": gender,
      "age_min": age_min,
      "age_max": age_max,
      "locale": locale,
      "image": image,
      "bgImage": bgImage,
      "timezone": timezone,
      "firstName": firstName,
      "lastName": lastName,
      "deviceToken": deviceToken,
      "friends": friends,
      "localAuth": localAuth
    ] as [String: AnyObject])
    
    // create a throttler
    // this will disable this controllers server calls for 10 seconds
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      self?.model.shouldRefrainFromCallingServer = false
    }
  }
  
  public func loginUserToServer() {
    guard let email = model.email, let password = model.password else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Sockets.sharedInstance().emit("authenticateWithLocalAuth", [
      "email": email,
      "password": password,
      "deviceToken": userController.readUserDefaults()?.deviceToken ?? ""
    ] as [String: AnyObject])
    
    Sockets.sharedInstance().on("authenticateWithLocalAuth.response") { [weak self] json in
      
      if json["errmsg"].string != nil || json["error"].string != nil {

        if json["error"].string?.containsString("email") == true {
          self?.model._isValidEmail.fire(false)
        } else if json["error"].string?.containsString("password") == true {
          self?.model._isValidPassword.fire(false)
        } else {
          self?.model._serverError.fire(true)
        }
        
      } else {
        
        // create and  user object
        self?.model.user = User(json: json)
        // set the shared user instance
        UserController.setSharedUser(self?.model.user)
        // write user object to realm
        self?.writeRealmUser()
        // set user online status to true
        Sockets.sharedInstance().setOnlineStatus(true)
        
        self?.shouldDismissView.fire(true)
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.model.shouldRefrainFromCallingServer = false
    }
    
    // create a throttler
    // this will disable this controllers server calls for 10 seconds
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      self?.model.shouldRefrainFromCallingServer = false
    }
  }
  
  public func getUserAttributesFromFacebook() {
    fbsdkController.getUserAttributesFromFacebook()
  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
  // this one deletes all prior users
  // we should only have one user in database, and that should be the current user
  public func deleteRealmUser(){ try! Realm().write { try! Realm().deleteAll() } }
  
  public class func logOut() {
    // deletes the current user, then will log user out.
    LoginController.sharedInstance().deleteRealmUser()
    // log out of facebook if they are logged in
    FBSDKController.logout()
    // since the current user does not exist anymore
    // we ask the tab view to check any current user, since we have no current user
    // it will present the login screen
    LoginController.sharedInstance().checkIfUserIsLoggedIn()
  }
}











