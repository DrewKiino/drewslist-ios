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

public class ChatController {
  
  // local url
  // http://localhost:1337
  
  // server url
  //  https://drewslist.herokuapp.com
  
  // MVC
  public let model = ChatModel()
  
  public let socket = Sockets.sharedInstance()
  
  // pub/sub
  public let didSendMessage = Signal<Bool>()
  public let didReceiveMessage = Signal<Bool>()
  public let isSendingMessage = Signal<Bool>()
  
  // variables
  private var unsubscribeBlock: (() -> Void)?
  
  public init() {
    setupDataBinding()
  }
  
  private func setupDataBinding() {
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
    }
    
    socket.on("setOnlineStatusCallback") { json in
      if let response = json["response"].bool {
        log.info("online status set to: \(response)")
      } else if let error = json["error"].string {
        log.debug(error)
      }
    }
    
    socket.on("disconnect") { [unowned self] json in
      // negate the session id in the model
      self.model.session_id = nil
    }
    
    // subscribe to broadcasts done by the server
    socket.on("message") { [unowned self] json in
      guard let newMessage = IncomingMessage(json: json).toJSQMessage() else { return }
      log.verbose(newMessage.text)
      // append the broadcast to the model's messages array
      self.model.messages.append(newMessage)
      // broadcast to all listeners that a message was received
      self.didReceiveMessage => true
    }
    
    // subscribe to the server chat framework's messages callback
    socket.on("checkForMessagesCallback") { json in
      if let messages = json["response"].array {
        for message in messages {
          guard let newMessage = IncomingMessage(json: message).toJSQMessage()
            else { return }
          self.model.messages.append(newMessage)
          // broadcast to all listeners that a message was received
          self.didReceiveMessage => true
          log.verbose(newMessage.text)
        }
      } else if let error = json["error"].string {
        log.debug(error)
      }
    }
    
    // subscribe to the server chat framework's broadcast callback
    socket.on("broadcastCallback") { [unowned self] json in
      // broadcast to listenres that the message sent was unsuccessful
      if let error = json["error"].string {
        self.didSendMessage => false
        log.error(error)
      // broadcast to listeners that the message sent was successful
      } else if let response = json["response"].string {
        if !self.model.pendingMessages.isEmpty {
          self.model.pendingMessages.removeLast()
          self.didSendMessage => true
          log.info(response)
        }
      }
    }
  }
  
  public func didPressSendButton(text: String) {
    guard let message = createOutgoingMessage(text),
          let jsqMessage = message.toJSQMessage(),
          let json = message.toJSON()
          where !text.isEmpty
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
    socket.connect { [weak self] in
      self?.setupSockets()
      self?.subscribe()
    }
  }
  
  public func disconnectFromServer() {
    unsubscribe { [weak self] in
      self?.socket.disconnect()
      self?.unsubscribeBlock = nil
    }
  }
}