//
//  ChatModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import JSQMessagesViewController
import ObjectMapper
import SwiftyJSON
import SwiftDate

public class ChatModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _users = Signal<[User]>()
  public var users = [User]() { didSet { _users => users } }
  
  public let _messages = Signal<[JSQMessage]>()
  public var messages = [JSQMessage]()
  
  public let _pendingMessages = Signal<[JSQMessage]>()
  public var pendingMessages = [JSQMessage]()
}

public class IncomingMessage: Mappable {
  
  public let _message = Signal<String?>()
  public var message: String? { didSet { _message => message } }
  
  public let _friend_id = Signal<String?>()
  public var friend_id: String? { didSet { _friend_id => friend_id } }
  
  public let _friend_username = Signal<String?>()
  public var friend_username: String? { didSet { _friend_username => friend_username } }
 
  public let _createdAt = Signal<String?>()
  public var createdAt: String? { didSet { _createdAt => createdAt } }
  
  public init(data: AnyObject) {
    if let json = JSON(data).dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}

  required public init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  public func mapping(map: Map) {
    message         <- map["message"]
    friend_id       <- map["friend_id"]
    friend_username <- map["friend_username"]
    createdAt       <- map["createdAt"]
  }
  
  public func toJSQMessage() -> JSQMessage? {
    guard let friend_id = friend_id, let friend_username = friend_username, let message = message else { return nil }
    return JSQMessage(senderId: friend_id, displayName: friend_username, text: message)
  }
}

public class OutgoingMessage {
  
  public let _message = Signal<String?>()
  public var message: String? { didSet { _message => message } }
  
  public let _user_id = Signal<String?>()
  public var user_id: String? { didSet { _user_id => user_id } }
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
  public let _createdAt = Signal<String?>()
  public var createdAt: String? { didSet { _createdAt => createdAt } }
  
  public init(user_id: String, username: String, message: String) {
    self.message = message
    self.user_id = user_id
    self.username = username
    self.createdAt = NSDate().toISOString()
  }
  
  public func toJSQMessage() -> JSQMessage? {
    guard let user_id = user_id, let username = username, let message = message else { return nil }
    return JSQMessage(senderId: user_id, displayName: username, text: message)
  }
}
