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
import RealmSwift

public class ChatModel: NSObject {
  
  public let _session_id = Signal<String?>()
  public var session_id: String? { didSet { _session_id => session_id } }
  
  public var room_id: String? {
    get {
      guard let user_id = user?._id, let friend_id = friend?._id
        else { return nil }
      return user_id + friend_id
    }
  }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _user_image = Signal<UIImage?>()
  public var user_image: UIImage? { didSet { _user_image => user_image } }
  
  public let _friend = Signal<User?>()
  public var friend: User? { didSet { _friend => friend } }
  
  public let _friend_image = Signal<UIImage?>()
  public var friend_image: UIImage? { didSet { _friend_image => friend_image } }

  public let _messages = Signal<[JSQMessage]>()
  public var messages = [JSQMessage]() { didSet { _messages => messages } }
  
  public let _pendingMessages = Signal<[JSQMessage]>()
  public var pendingMessages = [JSQMessage]() { didSet { _pendingMessages => pendingMessages } }
  
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
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
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
  
  public let _user_image = Signal<String?>()
  public var user_image: String? { didSet { _user_image => user_image } }
  
  public let _friend_id = Signal<String?>()
  public var friend_id: String? { didSet { _friend_id => friend_id } }

  public let _friend_username = Signal<String?>()
  public var friend_username: String? { didSet { _friend_username => friend_username } }
  
  public let _room_id = Signal<String?>()
  public var room_id: String? { didSet { _room_id => room_id } }
  
  public let _session_id = Signal<String?>()
  public var session_id: String? { didSet { _session_id => session_id } }
  
  public let _createdAt = Signal<String?>()
  public var createdAt: String? { didSet { _createdAt => createdAt } }
  
  
  public init(
    user_id: String,
    username: String,
    user_image: String,
    friend_id: String,
    friend_username: String,
    message: String,
    session_id: String,
    room_id: String
  ) {
    self.user_id = user_id
    self.username = username
    self.user_image = user_image
    self.friend_id = friend_id
    self.friend_username = friend_username
    self.message = message
    self.session_id = session_id
    self.room_id = room_id
    self.createdAt = NSDate().toString(.ISO8601)
  }
  
  public func toJSQMessage() -> JSQMessage? {
    guard let user_id = user_id, let username = username, let message = message else { return nil }
    return JSQMessage(senderId: user_id, displayName: username, text: message)
  }
  
  public func toJSON() -> [String: AnyObject]? {
    guard let user_id = user_id,
          let username = username,
          let friend_id = friend_id,
          let friend_username = friend_username,
          let session_id = session_id,
          let room_id = room_id,
          let message = message
          else { return nil }
    
    let json: [String: AnyObject] = [
      "user_id": user_id,
      "username": username,
      "friend_id": friend_id,
      // friend image is optional
      "user_image": user_image ?? "",
      "friend_username": friend_username,
      "session_id": session_id,
      "room_id": room_id,
      "message": message
    ]
    
    return json
  }
  
  public func set(text: String) -> Self {
    message = text
    return self
  }
}

public class RealmChatHistory: Object {
  
  dynamic var room_id: String? = ""
  dynamic var messagesData: NSData?
  dynamic var pendingMessagesData: NSData?
  
  public convenience init(messages: [JSQMessage], pendingMessages: [JSQMessage], room_id: String?) {
    self.init()
    self.messagesData = NSKeyedArchiver.archivedDataWithRootObject(messages)
    self.pendingMessagesData = NSKeyedArchiver.archivedDataWithRootObject(pendingMessages)
    self.room_id = room_id
  }
  
  public func getMessages() -> [JSQMessage] {
    if let messagesData = messagesData, let messages = NSKeyedUnarchiver.unarchiveObjectWithData(messagesData) as? [JSQMessage] { return messages }
    else { return [] }
  }
  
  public func getPendingMessages() -> [JSQMessage] {
    if let pendingMessagesData = pendingMessagesData , let pendingMessages = NSKeyedUnarchiver.unarchiveObjectWithData(pendingMessagesData) as? [JSQMessage] { return pendingMessages }
    else { return [] }
  }
  
  public override static func primaryKey() -> String? {
    return "room_id"
  }
}

