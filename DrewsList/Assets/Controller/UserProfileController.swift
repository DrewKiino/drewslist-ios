//
//  UserProfileController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 11/7/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import SwiftyTimer
import Signals
import Alamofire
import SwiftyJSON
import RealmSwift

public class UserProfileController {
  
  private let model = UserProfileModel()
  private var refrainTimer: NSTimer?
  private var view: UserProfileView?
//  private let serverUrl = "http://drewslist-staging.herokuapp.com/user"
  private let serverUrl = "http://localhost:1337/user"
  
  public func viewDidLoad() {
    
    // local
//    getUserFromServer("56733c2d11d037eb19e1488e")
    // server
    readRealmUser()
    getUserFromServer(model.user?._id)
  }
  
  public func userViewWillAppear() {
  }
  
  public func getUserFromServer(user_id: String?) {
    guard let user_id = user_id else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, serverUrl, parameters: [ "_id": user_id ], encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        
        // create and  user object
        self?.model.user = User(json: json)
        // write user object to realm
        self?.writeRealmUser()
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
  
  public func getModel() -> UserProfileModel { return model }
  
  public func get_User() -> Signal<User?> { return model._user }
  public func getUser() -> User? { return model.user }
  
  // MARK: Realm Functions
  public func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}
