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

public class ChatController {
  
  // local url
  // http://localhost:1337
  
  // server url
  //  https://drewslist.herokuapp.com
  
  // MVC
  public let model = ChatModel()
  
  private let socket = SocketIOClient(
//      socketURL: "http://localhost:1337",
    socketURL: "https://drewslist.herokuapp.com",
    options: [
      .Log(false),
      .ForcePolling(false),
      .Cookies([
        NSHTTPCookie(properties: [
          NSHTTPCookieDomain: "http://localhost:1337",
          NSHTTPCookiePath: "/",
          NSHTTPCookieName: "key",
          NSHTTPCookieValue: "value",
          NSHTTPCookieSecure: true,
          NSHTTPCookieExpires: NSDate(timeIntervalSinceNow: 60)
        ])!
      ])
    ]
  )
  
  
  // pub/sub
  public let didSendMessage = Signal<Bool>()
  public let didReceiveMessage = Signal<Bool>()
  public let isSendingMessage = Signal<Bool>()
  
  public init() {
    setupFixtures()
    setupSockets()
    setupListeners()
  }
  
  private func setupListeners() {
    // have the controller listen for send message status
    // if 'didSend' is true, then the server has ressed back an 'OK'
    // else if it is false, then the server has ressed back an error
    didSendMessage.listen(self) { didSend in
    }
  }
  
  private func setupSockets() {
    
    // subscribe to default streams
    socket.on("error") { data, socket in
      log.error(data)
    }
    socket.on("connect") { data, socket in
      log.info("connection established.")
    }
    socket.on("reconnect") { data, socket in
      log.debug(data)
    }
    socket.on("reconnectAttempt") { data, socket in
      log.debug(data)
    }
    socket.on("disconnect") { [unowned self] data, socket in
      log.info("disconnected from server.")
      // negate the session id in the model
      self.model.session_id = nil
    }
    
    // subscribe to broadcasts done by the server
    socket.on("message") { [unowned self] data, socket in
      for object in data {
        guard let newMessage = IncomingMessage(data: object).toJSQMessage()
          else { return }
        log.verbose(newMessage.text)
        // append the broadcast to the model's messages array
        self.model.messages.append(newMessage)
        // broadcast to all listeners that a message was received
        self.didReceiveMessage => true
      }
    }
    

    // subscribe to the server chat framework's connect callback
    socket.on("connectCallback") { data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let response = json["response"].string {
          // set the session id of the model
          self.model.session_id = response
          if  let session_id = self.model.session_id {
            log.info("session ID: \(session_id)")
          }
        } else if let error = json["error"].string {
          log.debug(error)
        }
      }
    }
    
    // subscribe to the server chat framework's messages callback
    socket.on("subscribeCallback") { data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let response = json["response"].string {
          log.info("successfully subscribed to: \(response)")
        } else if let error = json["error"].string {
          log.debug(error)
        }
      }
    }
    
    socket.on("setOnlineStatusCallback") { data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let response = json["response"].bool {
          log.info("successfully set online status to: \(response)")
        } else if let error = json["error"].string {
          log.debug(error)
        }
      }
    }
    
    // subscribe to the server chat framework's messages callback
    socket.on("checkForMessagesCallback") { data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let messages = json["response"].arrayObject {
          for object in messages {
            guard let newMessage = IncomingMessage(data: object).toJSQMessage()
              else { return }
            self.model.messages.append(newMessage)
            log.debug(newMessage.senderId)
            // broadcast to all listeners that a message was received
            self.didReceiveMessage => true
            log.verbose(newMessage.text)
          }
        } else if let error = json["error"].string {
          log.debug(error)
        }
      }
    }
    
    // subscribe to the server chat framework's broadcast callback
    socket.on("broadcastCallback") { [unowned self] data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        
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
    
    // connect to server
    socket.connect()
  }
  
  public func didPressSendButton(text: String) {
    guard let message = createOutgoingMessage(text),
          let jsqMessage = message.toJSQMessage(),
          let json = message.toJSON()
          else { return }
    
    model.pendingMessages.append(jsqMessage)
    
    socket.emit("broadcast", json)
  }
  
  private func setupFixtures() {
    // create user fixture
    let user = User()
    user.username = "Jynx"
//    user._id = "56413a2e12d4fb16616a8af3"
        user._id = "56413a1512d4fb16616a8af0"
    model.user = user
    
    let friend = User()
    friend.username = "Graves"
//    friend._id = "56413a1512d4fb16616a8af0"
        friend._id = "56413a2e12d4fb16616a8af3"
    model.friend = friend
    
    model._session_id.listenOnce(self) { [unowned self] session_id in
      
      guard let session_id = session_id,
        let room_id = self.model.room_id
        else { return }
      
      // message template sent by friend
      let message = OutgoingMessage(
        user_id: "56413a1512d4fb16616a8af0",
        username: "Graves",
        friend_id: "56413a2e12d4fb16616a8af3",
        friend_username: "Jynx",
        message: "Hello, how are you?",
        session_id: session_id,
        room_id: room_id
      )
      
     self.goOnlineAndSubscribe()
//      self.simulateChat(friendMessageTemplate: message)
//      self.simulateFriendNoteOnlineButGoesOnlineLater(friendMessageTemplate: message)
    }
  }
  
  private func createOutgoingMessage(text: String) -> OutgoingMessage? {
    guard let user = model.user,
          let _id = user._id,
          let username = user.username,
          let friend = model.friend,
          let friend_id = friend._id,
          let friend_username = friend.username,
          let session_id = model.session_id,
          let room_id = model.room_id
          else { return nil }
    
    let newOutgoingMessage = OutgoingMessage(
      user_id: _id,
      username: username,
      friend_id: friend_id,
      friend_username: friend_username,
      message: text,
      session_id: session_id,
      room_id: room_id
    )
    
    return newOutgoingMessage
  }
  
  private func simulateChat(friendMessageTemplate message: OutgoingMessage) {
    model.user?._id = "56413a2e12d4fb16616a8af3"
    model.friend?._id = "56413a1512d4fb16616a8af0"
    // begin chat simulation
    NSTimer.after(1.0) { [unowned self] in
      self.socket.emit(
        "subscribe",
        [
          "user_id": self.model.user!._id!,
          "room_id": self.model.room_id!
        ]
      )
      self.socket.emit(
        "setOnlineStatus",
        [
          "online": true,
          "user_id": self.model.user!._id!
        ]
      )
      self.socket.emit(
        "subscribe",
        [
          "user_id": self.model.friend!._id!,
          "room_id": self.model.room_id!
        ]
      )
      self.socket.emit(
        "setOnlineStatus",
        [
          "online": true,
          "user_id": self.model.friend!._id!
        ]
      )
      guard let json = message.toJSON() else { return }
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(4.0) { [unowned self] in
      self.didPressSendButton("I'm fine, thank you :)")
    }
    
    NSTimer.after(6.0) { [unowned self] in
      guard let json = message.set( "That's great to hear! This simulation is awesome huh?").toJSON() else { return }
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(7.0) { [unowned self] in
      self.didPressSendButton("yeah it is!")
    }
    
    NSTimer.after(7.1) { [unowned self] in
      self.didPressSendButton("get some sleep lol")
    }
    
    NSTimer.after(8.0) { [unowned self] in
      guard let json = message.set("haha, I should huh.").toJSON() else { return }
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(8.8) { [unowned self] in
      self.didPressSendButton("haha, goodnight!")
    }
    
    NSTimer.after(8.8) { [unowned self] in
      guard let json = message.set("wait! lets keep talking!!").toJSON() else { return }
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(9.1) { [unowned self] in
      self.didPressSendButton("okay!")
    }
    
    NSTimer.after(9.4) { [unowned self] in
      guard let json = message.set("just kidding :P, i just said that so I can write this really long message that will test the view's bubble box and make this view scrollable haha, but what's actually really crazy is how I'm able to type this in like 0.1 seconds, think about that for a second, just kidding my response is hardcoded lol.").toJSON() else { return }
      
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(9.8) { [unowned self] in
      self.didPressSendButton("haha good one!")
    }
    
    // end simulation and disconnect from server
    NSTimer.after(15.0) { [unowned self] in
      self.socket.disconnect()
    }
  }
  
  private func simulateFriendNoteOnlineButGoesOnlineLater(friendMessageTemplate message: OutgoingMessage) {
    model.user?._id = "56413a2e12d4fb16616a8af3"
    model.friend?._id = "56413a1512d4fb16616a8af0"
    
    NSTimer.after(1.0) { [unowned self] in
      guard let json = message.set( "Hey are you home?").toJSON() else { return }
      self.socket.emit(
        "setOnlineStatus",
        [
          "online": true,
          "user_id": "56413a1512d4fb16616a8af0"
        ]
      )
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(2.0) { [unowned self] in
      guard let json = message.set( "Yo answer me!").toJSON() else { return }
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(4.0) { [unowned self] in
      guard let json = message.set( "whatever, just wanted to let you know I stole the car and I'm going to havasu.").toJSON() else { return }
      self.socket.emit("broadcast", json)
    }
    
    NSTimer.after(5.0) { [unowned self] in
      self.socket.emit(
        "subscribe",
        [
          "user_id": self.model.user!._id!,
          "room_id": self.model.room_id!
        ]
      )
    }
  
    NSTimer.after(6.0) { [unowned self] in
      self.socket.emit("checkForMessages", "56413a2e12d4fb16616a8af3")
    }
    
    NSTimer.after(8.0) { [unowned self] in
      self.didPressSendButton("wtf.")
    }
    
    // end simulation and disconnect from server
    NSTimer.after(15.0) { [unowned self] in
      self.socket.disconnect()
    }
  }
  
  private func goOnlineAndSubscribe() {
    socket.emit(
      "setOnlineStatus",
      [
        "online": true,
        "user_id": self.model.user!._id!
      ]
    )
    socket.emit(
      "subscribe",
      [
        "user_id": self.model.user!._id!,
        "room_id": self.model.room_id!
      ]
    )
    socket.emit("checkForMessages", self.model.user!._id!)
  }
}