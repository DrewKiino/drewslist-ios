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

public class UserProfileController {
  
  private let model = UserProfileModel()
  private var view: UserProfileView?
  private let serverUrl = "http://drewslist-staging.herokuapp.com/user"
//  private let serverUrl = "http://localhost:1337/user"
  
  public func viewDidLoad() {
    
    // local
//    getUserFromServer("5672243dce7e7a49fc299832")
    // server
    getUserFromServer("5673198d8844191f0076af1a")
  }
  
  public func userViewWillAppear() {
  }
  
  public func getUserFromServer(user_id: String?) {
    guard let user_id = user_id else { return }
    Alamofire.request(.GET, serverUrl, parameters: [ "_id": user_id ], encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        
        // create user object
        let user = User(json: json)
        
        // set user object
        self?.model.user = user
      }
    }
  }
  
  public func getModel() -> UserProfileModel { return model }
  
  public func get_User() -> Signal<User?> { return model._user }
  public func getUser() -> User? { return model.user }
}
