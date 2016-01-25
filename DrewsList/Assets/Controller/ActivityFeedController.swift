//
//  ActivityFeedController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/10/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Signals

public class ActivityFeedController {
  
  private struct Singleton { private static let _didUpdateChat = Signal<Bool>() }
  public class func shared_didUpdateChat() -> Signal<Bool> { return Singleton._didUpdateChat }
  
  public let model = ActivityFeedModel()
  
  private let socket = Sockets.sharedInstance()
  
  public let _didUpdateChat = Singleton._didUpdateChat
  
  public init() {
    setupSockets()
  }
  
  private func setupSockets() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      // check if the message is a chat
      if json["type"].string == "CHAT" {
        
        // append to the list of activities
        self?.model.activities.insert(Activity(
          message: json["message"],
          timestamp: json["message"]["createdAt"].string,
          type: json["type"].string,
          leftImage: json["message"]["friend_image"].string,
          rightImage: nil
        ), atIndex: 0)
        
        // if the user is not already in chat, update the chat history
        if self?.socket.isCurrentlyInChat == false  {
          // update chat history
          self?.updateChat(json)
          // publish to other subscribers that the AFController has updated a chat
          self?._didUpdateChat.fire(true)
        }
        
      // else check if the message is a alert saying that you have a potential buyer/seller 'match'
      } else if let message = json["message"]["message"].string, let username = json["message"]["friend_username"].string where json["type"].string == "LIST_MATCH" {
//        self?.model.activity = "\(username): \(message)"
      }
    }
  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
  
  public func updateChat(json: JSON?) {
    guard let room_id = json?["message"]["room_id"].string else { return }
    let realm = try! Realm()
    let chatHistory = realm.objectForPrimaryKey(RealmChatHistory.self, key: room_id)
    realm.beginWrite()
    chatHistory?.append(IncomingMessage(json: json?["message"]).toJSQMessage())
    try! realm.commitWrite()
  }
}