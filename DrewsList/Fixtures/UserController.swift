//
//  UserController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class UserController {
  
  private struct Singleton {
    static let userController = UserController()
  }
  
  public static func sharedInstance() -> UserController { return Singleton.userController }
  
  private let socket = Sockets.sharedInstance()
  
  public let model = UserModel()
  
  public func login() {
    // MARK: hardcoded login user
    let user_id = "564fa61b77b7915420dc89b2"
    
    socket.on("/user/login(callback)") { [unowned self] json in
      self.model.user = User(json: json["response"])
      if let user = self.model.user, _id = user._id {
        log.info("logged in: \(_id)")
      }
    }
    
    socket.emit("/user/login", "564fa61b77b7915420dc89b2")
  }
  
  public func getUser() -> User? {
    return model.user
  }
}