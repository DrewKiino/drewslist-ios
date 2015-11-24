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
import Toucan
import RealmSwift
import Async

public class ChatModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _friend = Signal<User?>()
  public var friend: User? { didSet { _friend => friend } }
  
  public let _messages = Signal<[JSQMessage]>()
  public var messages = [JSQMessage]() { didSet { _messages => messages } }
  
  public let _pendingMessages = Signal<[JSQMessage]>()
  public var pendingMessages = [JSQMessage]() { didSet { _pendingMessages => pendingMessages } }
  
  public let _book = Signal<String?>()
  public var book: String? { didSet { _book => book } }
  
  public var room_id: String? {
    get {
      guard let user_id = user?._id, let friend_id = friend?._id else { return nil }
      return user_id + "+" + friend_id
    }
  }
  
  public func save() {
    Async.background { [weak self] in
      do {
        guard let room_id = self?.room_id,
              let messages = self?.messages
        else { return }
        let object = SavedMessages()
        object._id = room_id
        object.data = NSKeyedArchiver.archivedDataWithRootObject(messages)
        let realm = try Realm()
        realm.beginWrite()
        realm.add(object, update: true)
        try realm.commitWrite()
      } catch {
        return
      }
    }
  }
  
  public func load(callback: () -> Void) {
    Async.background { [weak self] in
      do {
        guard let room_id = self?.room_id,
              let messages = try Realm().objectForPrimaryKey(SavedMessages.self, key: room_id)?.getMessages()
          else { return }
        // only load the last 20 messages
        self?.messages = messages.suffix(20).map { $0 as JSQMessage }
        Async.main {
          callback()
        }
      } catch { return }
    }
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
    guard let friend_id = friend_id, let friend_username = friend_username, let message = message, let createdAt = createdAt else { return nil }
    return JSQMessage(senderId: friend_id, senderDisplayName: friend_username, date: createdAt.toDate(format: .ISO8601), text: message)
  }
}

public class OutgoingMessage {
  
  public let _message = Signal<String?>()
  public var message: String? { didSet { _message => message } }
  
  public let _user_id = Signal<String?>()
  public var user_id: String? { didSet { _user_id => user_id } }
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
  public let _friend_id = Signal<String?>()
  public var friend_id: String? { didSet { _friend_id => friend_id } }
  
  public let _friend_username = Signal<String?>()
  public var friend_username: String? { didSet { _friend_username => friend_username } }
  
  public let _room_id = Signal<String?>()
  public var room_id: String? { didSet { _room_id => room_id } }
  
  public let _createdAt = Signal<String?>()
  public var createdAt: String? { didSet { _createdAt => createdAt } }
  
  public init(
    user_id: String,
    username: String,
    friend_id: String,
    friend_username: String,
    message: String,
    room_id: String
  ) {
    self.user_id = user_id
    self.username = username
    self.friend_id = friend_id
    self.friend_username = friend_username
    self.message = message
    self.room_id = room_id
    self.createdAt = NSDate().toISOString()
  }
  
  public func toJSQMessage() -> JSQMessage? {
    guard let user_id = user_id, let username = username, let message = message, let createdAt = createdAt else { return nil }
    return JSQMessage(senderId: user_id, senderDisplayName: username, date: createdAt.toDate(format: .ISO8601), text: message)
  }
  
  public func toJSON() -> [String: AnyObject]? {
    guard let user_id = user_id,
          let username = username,
          let friend_id = friend_id,
          let friend_username = friend_username,
          let room_id = room_id,
          let message = message
          else { return nil }
    
    let json: [String: AnyObject] = [
      "user_id": user_id,
      "username": username,
      "friend_id": friend_id,
      "friend_username": friend_username,
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

public class MessageAvatar: NSObject, JSQMessageAvatarImageDataSource {
  
  private let avatarSize: CGSize = CGSizeMake(48, 48)
  public var avatar: String?
  
  public init(avatar: String) {
    super.init()
    self.avatar = avatar
  }
  
  /**
   *  @return The avatar image for a regular display state.
   *
   *  @discussion You may return `nil` from this method while the image is being downloaded.
   */
  @available(iOS 2.0, *)
  public func avatarImage() -> UIImage! {
    return Toucan(image: UIImage(named: avatar!)!)
      .resizeByCropping(avatarSize)
      .maskWithEllipse().image
  }
  
  /**
   *  @return The avatar image for a highlighted display state.
   *
   *  @discussion You may return `nil` from this method if this does not apply.
   */
  @objc
  @available(iOS 2.0, *)
  public func avatarHighlightedImage() -> UIImage! {
    return Toucan(image: UIImage(named: avatar!)!)
      .resizeByCropping(avatarSize)
      .maskWithEllipse().image
  }
  
  /**
   *  @return A placeholder avatar image to be displayed if avatarImage is not yet available, or `nil`.
   *  For example, if avatarImage needs to be downloaded, this placeholder image
   *  will be used until avatarImage is not `nil`.
   *
   *  @discussion If you do not need support for a placeholder image, that is, your images
   *  are stored locally on the device, then you may simply return the same value as avatarImage here.
   *
   *  @warning You must not return `nil` from this method.
   */
  @available(iOS 2.0, *)
  public func avatarPlaceholderImage() -> UIImage! {
    return Toucan(image: UIImage(named: avatar!)!)
      .resizeByCropping(avatarSize)
      .maskWithEllipse().image
  }
}


public class SavedMessages: Object {
  
  public dynamic var _id: String?
  
  public dynamic var data: NSData? = nil
  
  public func getMessages() -> [JSQMessage]? {
    guard let data = data,
          let messages = NSKeyedUnarchiver.unarchiveObjectWithData(data) as? [JSQMessage]
    else { return nil }
    return messages
  }
  
  public override static func primaryKey() -> String? {
    return "_id"
  }
}













