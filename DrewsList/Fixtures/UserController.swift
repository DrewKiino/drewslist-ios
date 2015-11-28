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
    let user_id = "564fab9d1690801f00d8f6bd"
    
    socket.on("/user/login(callback)") { [unowned self] json in
      self.model.user = User(json: json["response"])
      if let user = self.model.user, _id = user._id {
        log.info("logged in: \(_id)")
      }
    }
    
    socket.emit("/user/login", "564fab9d1690801f00d8f6bd")
  }
  
  public func getUser() -> User? {
    return model.user
  }
  
//  public class func userFixtures() -> User {
  public class func friendFixtures() -> User {
    let user = User()
    user._id = "5653dd45e4a2811f00336b5e"
//    user._id = "5653c79300066fed237cb2c7"
    user.firstName = "Lisa"
    user.lastName = "Berthhart"
    user.username = "LisaXOXO"
    user.avatar = "stockphoto1"
    return user
  }
  
//  public class func friendFixtures() -> User {
  public class func userFixtures() -> User {
    let user = User()
    user._id = "564fab9d1690801f00d8f6bd"
//    user._id = "5653ba1972c0370e0487b5f8"
    user.firstName = "Bobby"
    user.lastName = "Hill"
    user.username = "XStyler"
    user.avatar = "stockphoto2"
    return user
  }

}