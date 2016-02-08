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

public class LoginController {
  
  // MARK: Singleton
  
  private struct Singleton { static let loginController = LoginController() }
  public class func sharedInstance() -> LoginController { return Singleton.loginController }
  
  public let model = LoginModel()
  
  private let userController = UserController()
  
  private let facebookManager = FBSDKController()
  
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
  }
  
  public func checkIfUserIsLoggedIn() -> Bool {
    // check if user is already logged in
    if let user = try! Realm().objects(RealmUser.self).first?.getUser() {
      
      model.user = user
      
      getUserFromServer()
      
      return true
      
    // if we already have a user, attempt to call the server to update the current user
    // if not show login view
    } else if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView {
      
      tabView.presentViewController(LoginView(), animated: false, completion: nil)
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
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.model.shouldRefrainFromCallingServer = false
    }
    
//    Alamofire.request(
//      .POST,
//      ServerUrl.Default.getValue() + "/user/authenticateWithLocalAuth",
//      parameters: [
//        "email": email,
//        "password": password,
//        "deviceToken": userController.readUserDefaults()?.deviceToken ?? ""
//      ] as [String: AnyObject],
//      encoding: .JSON
//    )
//    .response { [weak self] req, res, data, error in
//      
//      if let error = error {
//        log.error(error)
//        self?.model._serverError.fire(true)
//        
//      } else if let data = data, let json: JSON! = JSON(data: data) {
//        
//        if json["errmsg"].string != nil || json["error"].string != nil {
//          
//          if json["error"].string?.containsString("email") == true {
//            self?.model._isValidEmail.fire(false)
//          } else if json["error"].string?.containsString("password") == true {
//            self?.model._isValidPassword.fire(false)
//          } else {
//            self?.model._serverError.fire(true)
//          }
//          
//        } else {
//          // create and  user object
//          self?.model.user = User(json: json)
//          // write user object to realm
//          self?.writeRealmUser()
//          // set user online status to true
//          Sockets.sharedInstance().setOnlineStatus(true)
//        }
//      }
//      
//      // create a throttler
//      // this will disable this controllers server calls for 10 seconds
//      self?.refrainTimer?.invalidate()
//      self?.refrainTimer = nil
//      self?.model.shouldRefrainFromCallingServer = false
//    }
    
    // create a throttler
    // this will disable this controllers server calls for 10 seconds
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      self?.model.shouldRefrainFromCallingServer = false
    }
  }
  
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
  // this one deletes all prior users
  // we should only have one user in database, and that should be the current user
  public func deleteRealmUser(){ try! Realm().write { try! Realm().deleteAll() } }
}











