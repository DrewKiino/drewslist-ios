//
//  UserController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import RealmSwift
import Alamofire
import SwiftyJSON

public class UserController {
  
  private struct Singleton {
    static let userController = UserController()
  }
  
  public static func sharedInstance() -> UserController { return Singleton.userController }
  
  private let socket = Sockets.sharedInstance()
  
  public let model = UserModel()
  
  public func getUser() -> User? { return model.user }
  
  // MARK: Realm Functions
  func readUserDefaults() -> UserDefaults? { if let defaults =  try! Realm().objects(UserDefaults.self).first { return defaults } else { return nil } }
  func writeNewUserDefaults() { try! Realm().write { try! Realm().delete(Realm().objects(UserDefaults.self)); try! Realm().add(UserDefaults(), update: true) } }
  func updateUserDefaults(writeBlock: ((defaults: UserDefaults) -> Void)? = nil) { if let defaults = readUserDefaults() { try! Realm().write { writeBlock?(defaults: defaults) } } }
  
  // MARK: Realm Functions
  func readRealmUser() -> RealmUser? { if let realmUser =  try! Realm().objects(RealmUser.self).first { return realmUser } else { return nil } }
  func writeRealmUser(user: User?) -> User? { if let user = user { try! Realm().write { try! Realm().add(RealmUser().setRealmUser(user), update: true) }; return user } else { return nil } }
  
  // MARK: User Functions
  func updateUserToServer(updateBlock: ((user: User?) -> User?)? = nil) {
    guard let user = updateBlock?(user: model.user), let user_id = model.user?._id else { return }
    Alamofire.request(
      .POST,
      ServerUrl.Default.getValue() + "/user/\(user_id)",
      parameters: [
        "deviceToken": user.deviceToken ?? ""
      ] as [String: AnyObject],
      encoding: .JSON
    )
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        log.info("server: received device token.")
        log.debug(json)
        self?.model.user = User(json: json)
      }
    }
  }
}