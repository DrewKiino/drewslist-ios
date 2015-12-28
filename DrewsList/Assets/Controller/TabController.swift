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

public class TabController {
  
  public let model = TabModel()
  
  public var refrainTimer: NSTimer?
  
  public init() {
    // NOTE: Important! These functions have to be called in this order
    readRealmUser()
  }
  
  public func checkIfUserIsLoggedIn() -> Bool {
    // check if user is already logged in
    if let user = try! Realm().objects(RealmUser.self).first?.getUser() {
      
      model.user = user
      
      getUserFromServer()
      
      return true
    // if we already have a user, attempt to call the server to update the current user
    // if not show login view
    } else { return false }
  }
  
  public func getUserFromServer() {
    guard let user_id = model.user?._id else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, ServerUrl.Staging.getValue() + "/user", parameters: [ "_id": user_id ], encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        
        log.error(error)
        
      } else if let data = data, let json: JSON! = JSON(data: data) where !json.isEmpty {
        
        // create and  user object
        self?.model.user = User(json: json)
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

  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
  // this one deletes all prior users
  // we should only have one user in database, and that should be the current user
  public func deleteRealmUser(){ try! Realm().write { try! Realm().deleteAll() } }
}