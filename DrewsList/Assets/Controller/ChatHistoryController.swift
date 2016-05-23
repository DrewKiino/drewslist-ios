//
//  ChatHistoryController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import Signals

public class ChatHistoryController {
  
  private let socket = Sockets.sharedInstance()
  
  public let model = ChatHistoryModel()
  
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
      self?.readRealmUser()
      self?.loadChatHistoryFromServer()
    }
  }
  
  public func viewDidAppear() {
    loadChatHistoryFromServer()
  }
  
  private func setupDataBinding() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      if json["type"].string == "CHAT" {
        self?.readRealmUser()
        self?.loadChatHistoryFromServer() }
    }
    UserController.sharedUser()._user.removeListener(self)
    UserController.sharedUser()._user.listen(self) { [weak self] user in
      self?.model.user = user
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
        
        // sort the chat model in order of latest message
        // $0.0 represents the first chat model being compared
        // $0.1 represents teh second chat model being compared
        // this type of syntax is called 'inferred' syntax
        self?.model.chatModels.sortInPlace { return $0.0.messages.last?.date() > $0.1.messages.last?.date() }
        // tell the view to update its views
        self?.model.shouldRefreshViews = true
      }
    }
    
    socket.emit("chatHistory.getChatHistory", objects: [ "user_id": model.user?._id ?? "" ])
  }
  
  // MARK: Deprecated, using server for getting user's chat history now
//  public func loadChatHistory() {
//    model.chatModels = try! Realm().objects(RealmChatHistory.self).map { $0.getChatModel() }
//  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}