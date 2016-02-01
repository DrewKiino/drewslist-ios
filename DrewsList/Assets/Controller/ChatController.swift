//
//  ChatController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift
import Signals
import JSQMessagesViewController
import SwiftyJSON
import SwiftyTimer
import RealmSwift

public class ChatController {
  
  // local url
  // http://localhost:1337
  
  // server url
  //  https://drewslist.herokuapp.com
  
  // MVC
  public var model = ChatModel()
  
  public let socket = Sockets.sharedInstance()
  
  // pub/sub
  public let didSendMessage = Signal<Bool>()
  public let didReceiveMessage = Signal<Bool>()
  public let isSendingMessage = Signal<Bool>()
  public let didLoadMessagesFromRealm = Signal<Bool>()
  public let didLoadMessagesFromServer = Signal<Bool>()
  
  // variables
  private var unsubscribeBlock: (() -> Void)?
  
  public func viewDidLoad() {
  }
  
  public func viewDidAppear() {
    connectToServer()
    socket.isCurrentlyInChat = true
  }
  
  public func viewWillDisappear() {
    saveChatHistory()
    disconnectFromServer()
    socket.isCurrentlyInChat = false
  }
  
  public init() {
    setupSelf()
    setupDataBinding()
  }
  
  private func setupSelf() {
    model.session_id = socket.session_id
  }
  
  private func setupDataBinding() {
    model._user.removeAllListeners()
    model._user.listen(self) { [weak self] user in
      // on setup, download the user's avatar
      UIImageView.dl_setImageFromUrl(user?.imageUrl, size: CGSizeMake(24, 24), maskWithEllipse: true) { [weak self] image in
        self?.model.user_image = image
      }
    }
    model._friend.removeAllListeners()
    model._friend.listen(self) { [weak self] friend in
      // on setup, download the friend's avatar
      UIImageView.dl_setImageFromUrl(friend?.imageUrl, size: CGSizeMake(24, 24), maskWithEllipse: true) { [weak self] image in
        self?.model.friend_image = image
      }
    }
    socket._session_id.removeAllListeners()
    socket._session_id.listen(self) { [weak self] session_id in
      self?.model.session_id = session_id
    }
    // have the controller listen for send message status
    // if 'didSend' is true, then the server has ressed back an 'OK'
    // else if it is false, then the server has ressed back an error
    didSendMessage.removeAllListeners()
    didSendMessage.listen(self) { didSend in
    }
  }
  
  private func setupSockets() {
    
    // subscribe to the server chat framework's connect callback
    socket.on("subscribe.response") { json in
      
      if let response = json["response"].string {
        log.info("joined room: \(response)")
      } else if let error = json["error"].string {
        log.debug(error)
      }
    }
    
    socket.on("unsubscribe.response") { [weak self] json in
      
      if let response = json["response"].string {
        log.info("left room: \(response)")
      } else if let error = json["error"].string {
        log.debug(error)
      }
      
      self?.unsubscribeBlock?()
      self?.unsubscribeBlock = nil
    }
    
    // subscribe to the server chat framework's broadcast callback
    socket.on("chat.broadcast.response") { [unowned self] json in
      // broadcast to listenres that the message sent was unsuccessful
      if let error = json["error"].string {
        self.didSendMessage => false
        log.error(error)
        
      // print any warnings
      } else if let warning = json["warning"].string {
        log.warning(warning)
        
      // broadcast to listeners that the message sent was successful
      } else if let response = json["response"].string {
        
        if !self.model.pendingMessages.isEmpty {
          self.model.pendingMessages.removeLast()
          self.didSendMessage => true
        }
        
        log.debug(response)
      }
    }
    
    // subscribe to broadcasts done by the server
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      guard let newMessage = IncomingMessage(json: json["message"]).toJSQMessage() where json["identifier"].string == self?.model.room_id else { return }
      // append the broadcast to the model's messages array
      self?.model.messages.append(newMessage)
      // broadcast to all listeners that a message was received
      self?.didReceiveMessage.fire(true)
    }
  }
  
  public func didPressSendButton(text: String) {
    guard let message = createOutgoingMessage(text),
          let jsqMessage = message.toJSQMessage(),
          let json = message.toJSON()
          where !text.isEmpty && socket.isConnected() == true
          else { return }
    
    model.pendingMessages.append(jsqMessage)
    
    socket.emit("broadcast", json)
  }

  private func createOutgoingMessage(text: String) -> OutgoingMessage? {
    
//    log.debug(model.user)
//    log.debug(model.user?._id)
//    log.debug(model.user?.getName())
//    log.debug(model.friend)
//    log.debug(model.friend?._id)
//    log.debug(model.friend?.getName())
//    log.debug(model.session_id)
//    log.debug(model.room_id)
    
    guard let user = model.user,
          let _id = user._id,
          let name = user.getName(),
          let friend = model.friend,
          let friend_id = friend._id,
          let friendName = friend.getName(),
          let session_id = model.session_id,
          let room_id = model.room_id
          else { return nil }
    
    return OutgoingMessage(
      user_id: _id,
      username: name,
      user_image: model.user?.imageUrl ?? "",
      friend_id: friend_id,
      friend_username: friendName,
      message: text,
      session_id: session_id,
      room_id: room_id
    )
  }
  
  public func subscribe() {
    guard let room_id = model.room_id, let user_id = model.user?._id else { return }
    
    socket.emit(
      "subscribe",
      [
        "room_id": room_id,
        "user_id": user_id
      ]
    )
  }
  
  public func unsubscribe(completionHandler: () -> Void) {
    guard let room_id = model.room_id, let user_id = model.user?._id else { return }
    
    socket.emit(
      "unsubscribe",
      [
        "room_id": room_id,
        "user_id": user_id
      ]
    )
    
    unsubscribeBlock = completionHandler
  }
  
  public func setOnlineStatus(user_id: String, online: Bool) {
    socket.emit(
      "setOnlineStatus",
      [
        "online": online,
        "user_id": user_id
      ]
    )
  }
  
  public func connectToServer() {
//    socket.connect { [weak self] in
//      self?.setupSockets()
//      self?.subscribe()
//    }
    // setup sockets
    setupSockets()
    // subscribe user to chat room
    subscribe()
    // get message history
    getChatHistoryFromServer()
  }
  
  public func disconnectFromServer() {
    
    unsubscribe { [weak self] in
//      self?.socket.disconnect()
      // set flag
    }
  }
  
  public func getChatHistoryFromServer() {
    
    model.messages.removeAll(keepCapacity: false)
    
    // subscribe to the server chat framework's messages callback
    socket.on("chat.getChatHistory.response") { [weak self] json in
      
      json["messages"].array?.forEach { [weak self] json in if let message = IncomingMessage(json: json).toJSQMessage() { self?.model.messages.insert(message, atIndex: 0) } }
      
      self?.loadChatHistory()
      
      self?.didLoadMessagesFromServer.fire(true)
    }
    
    socket.emit("chat.getChatHistory", [
      "user_id": model.friend?._id ?? "",
      "room_id": model.room_id ?? "",
      "skip": 0,
      "paging": 10
    ])
  }
  
  public func loadChatHistory() {
    if let room_id = model.room_id {
      
      let chatHistory = try! Realm().objectForPrimaryKey(RealmChatHistory.self, key: room_id)
      if let message = chatHistory?.getMessages().first where model.messages.count > 0 { model.messages[model.messages.count - 1] = message }
      
      didLoadMessagesFromRealm => true
    }
  }
  
  public func saveChatHistory() {
    if model.messages.isEmpty { return }
    let realm = try! Realm()
    realm.beginWrite()
    realm.add(RealmChatHistory(messages: model.messages, pendingMessages: model.pendingMessages, room_id: model.room_id, user: model.user, friend: model.friend), update: true)
    try! realm.commitWrite()
  }
}