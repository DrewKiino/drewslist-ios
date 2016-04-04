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
  private var view: UserProfileView?
  private var isOtherUser: Bool?
  private var refrainTimer: NSTimer?
  
  public let isLoadingUserDataFromServer = Signal<Bool>()
  public let didLoadUserDataFromServer = Signal<Bool>()
  
  public func changeOtherUserBoolean(isOtherUser: Bool?){
    if let isOtherUser = isOtherUser {
      self.isOtherUser = isOtherUser
    }
  }
  
  public func viewDidAppear() {
    if isOtherUser == false { model.user = UserModel.sharedUser().user }
    getUserFromServer()
  }
  
  public class func updateUserToServer(parameters: [String: AnyObject], callback: (User -> Void)? = nil) {
    Alamofire.request(.POST, "\(ServerUrl.Default.getValue())/user/\(UserModel.sharedUser().user?._id ?? "")", parameters: parameters)
    .response { req, res, data, error in
      if let error = error {
        log.error(error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        UserModel.setSharedUser(User(json: json))
        callback?(User(json: json))
      }
    }
  }
  
  public func getUserFromServer(override: Bool = false) {
    if override {
      refrainTimer?.invalidate()
      refrainTimer = nil
      model.shouldRefrainFromCallingServer = false
    }
    // make sure the user_id exists
    guard let user_id = model.user?._id where model.shouldRefrainFromCallingServer == false else { return }
    isLoadingUserDataFromServer => true
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, ServerUrl.Default.getValue() + "/user", parameters: [ "_id": user_id ], encoding: .URL)
    .response { [weak self] req, res, data, error in
      if let error = error {
        log.error(error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        // create and  user object
        self?.model.user = User(json: json)
        // write user object to realm
        self?.writeRealmUser()
        
        self?.didLoadUserDataFromServer.fire(true)
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.refrainTimer = NSTimer.after(5.0) { [weak self] in
        // allow the controller to make server calls again
        self?.model.shouldRefrainFromCallingServer = false
      }
    }
    
    // just in case the doesn't ever respond...
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(5.0) { [weak self] in
      // disable loading screen
      self?.model.shouldRefrainFromCallingServer = false
    }
  }
  
  public func getModel() -> UserProfileModel { return model }
  
  public func get_User() -> Signal<User?> { return model._user }
  public func getUser() -> User? { return model.user }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}
