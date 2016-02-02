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
  
  private let socket = Sockets.sharedInstance()
  
  public let model = ChatHistoryModel()
  private let _didUpdateChat = ActivityFeedController.shared_didUpdateChat()
  
  public init() {
    setupSelf()
    setupSockets()
    setupDataBinding()
  }
  
  private func setupSelf() {
    readRealmUser()
  }
  
  private func setupSockets() {
    socket.onConnect("ChatHistoryController") { [weak self] in
      self?.loadChatHistoryFromServer()
    }
  }
  
  public func viewDidAppear() {
    loadChatHistoryFromServer()
  }
  
  private func setupDataBinding() {
    _didUpdateChat.removeListener(self)
    _didUpdateChat.listen(self) { [weak self] bool in
    }
  }
  
  public func loadChatHistoryFromServer() {
    socket.on("chatHistory.getChatHistory.response") { [weak self] json in
      if let jsonArray = json.array {
        
        self?.model.chatModels.removeAll(keepCapacity: false)
        
        for json in jsonArray {
          
          let chatModel = ChatModel()
          
          if let users = json["users"].array {
            for user in users {
              let user = User(json: user["user"])
              
              if user._id != self?.model.user?._id {
                chatModel.friend = user
                chatModel.user = self?.model.user
                break
              }
            }
          }
          
          if let message = IncomingMessage(json: json["messages"].array?.last).toJSQMessage() {
            chatModel.messages.append(message)
          }
          
          if chatModel.user?.getName() != nil && chatModel.friend?.getName() != nil {
            self?.model.chatModels.append(chatModel)
          }
        }
      }
    }
    socket.emit("chatHistory.getChatHistory", [ "user_id": model.user?._id ?? "" ])
  }
  
  // MARK: Deprecated, using server for getting user's chat history now
//  public func loadChatHistory() {
//    model.chatModels = try! Realm().objects(RealmChatHistory.self).map { $0.getChatModel() }
//  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}