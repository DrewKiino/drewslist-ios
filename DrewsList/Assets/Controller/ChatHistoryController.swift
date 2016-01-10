//
//  ChatHistoryController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift

public class ChatHistoryController {
  
  private let userController = UserController.sharedInstance()
  private let socket = Sockets.sharedInstance()
  
  public let model = ChatHistoryModel()
  
  public init() {
    setupDataBinding()
    readRealmUser()
  }
  
  public func setupDataBinding() {
  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}