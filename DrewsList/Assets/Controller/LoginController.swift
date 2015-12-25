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
  
  public let model = LoginModel()
  
  // private let serverUrl = "http://drewslist-staging.herokuapp.com/user"
  private let serverUrl = "http://localhost:1337/user"
  private var refrainTimer: NSTimer?
  
  
  public init() {}
  
  public func loginUserToServer() {
    guard let email = model.email, let password = model.password else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(
      .POST,
      serverUrl + "/authenticateWithLocalAuth",
      parameters: [
        "email": email,
        "password": password
      ] as [String: AnyObject],
      encoding: .JSON
      )
      .response { [weak self] req, res, data, error in
        
        if let error = error {
          log.error(error)
          self?.model._serverError.fire(true)
          
        } else if let data = data, let json: JSON! = JSON(data: data) {
          
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
            // write user object to realm
            self?.writeRealmUser()
          }
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
  
  // MARK: Realm Functions
  public func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}











