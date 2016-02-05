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
  
  public let _isCurrentlySendingMessage = Signal<Bool>()
  public var isCurrentlySendingMessage: Bool = false { didSet { _isCurrentlySendingMessage => isCurrentlySendingMessage } }
  
  public let _session_id = Signal<String?>()
  public var session_id: String? { didSet { _session_id => session_id } }
  
  public var room_id: String? { get { return [(user?._id ?? ""), (friend?._id ?? "")].sort().reduce(nil) { ($0 ?? "") + "+" + $1 ?? "" } } }
  
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
  
  
  public let _mostRecentTimestamp = Signal<String?>()
  public var mostRecentTimestamp: String? { didSet { _mostRecentTimestamp => mostRecentTimestamp } }
  
  public func set(user user: User?) -> Self {
    self.user = user
    return self
  }
  
  public func set(friend friend: User?) -> Self {
    self.friend = friend
    return self
  }
  
  public func set(messages messages: [JSQMessage]) -> Self {
    self.messages = messages
    return self
  }
  
  public func set(pendingMessages pendingMessages: [JSQMessage]) -> Self {
    self.pendingMessages = pendingMessages
    return self
  }
  
  public func set(mostRecentTimestamp mostRecentTimestamp: String?) -> Self {
    self.mostRecentTimestamp = mostRecentTimestamp
    return self
  }
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
  
  public init(json: JSON?) {
    if let json = json?.dictionaryObject {
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
    guard let friend_id = friend_id, let friend_username = friend_username, let message = message, let date = createdAt?.toDateFromISO8601() else { return nil }
    return JSQMessage(senderId: friend_id, senderDisplayName: friend_username, date: date, text: message)
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
  }
  
  public func toJSQMessage() -> JSQMessage? {
    guard let user_id = user_id, let username = username, let message = message else { return nil }
    return JSQMessage(senderId: user_id, senderDisplayName: username, date: NSDate(), text: message)
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
      "user_image": user_image ?? "",
      "friend_id": friend_id,
      // friend image is optional
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
  dynamic var mostRecentTimestamp: String? = ""
  dynamic var messagesData: NSData?
  dynamic var pendingMessagesData: NSData?
  dynamic var user: RealmUser?
  dynamic var friend: RealmUser?
  
  public convenience init(messages: [JSQMessage], pendingMessages: [JSQMessage], room_id: String?, user: User?, friend: User?, mostRecentTimestamp: String?) {
    self.init()
    if let message = messages.last { self.messagesData = NSKeyedArchiver.archivedDataWithRootObject([message]) }
    if let message = pendingMessages.last { self.pendingMessagesData = NSKeyedArchiver.archivedDataWithRootObject([message]) }
    self.room_id = room_id
    self.user = RealmUser().setRealmUser(user)
    self.friend = RealmUser().setRealmUser(friend)
    self.mostRecentTimestamp = mostRecentTimestamp
  }
  
  public func append(message: JSQMessage?) -> Self {
    if let message = message {
      var messages = getMessages()
      messages.append(message)
      self.messagesData = NSKeyedArchiver.archivedDataWithRootObject(messages)
    }
    return self
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
  
  public func getChatModel() -> ChatModel {
    return ChatModel().set(messages: getMessages()).set(pendingMessages: getPendingMessages()).set(user: user?.getUser()).set(friend: friend?.getUser()).set(mostRecentTimestamp: mostRecentTimestamp)
  }
}

