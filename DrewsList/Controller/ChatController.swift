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
  
  // MVC
  public let model = ChatModel()
  
  private let socket = SocketIOClient(
    socketURL: "localhost:1337",
    options: [
      .Log(false),
      .ForcePolling(false)
    ]
  )
  
  
  // pub/sub
  public let didSendMessage = Signal<Bool>()
  public let didReceiveMessage = Signal<Bool>()
  public let isSendingMessage = Signal<Bool>()
  
  public init() {
    setup()
    setupSockets()
  }
  
  private func setup() {
    // create user fixture
    let user = User()
    user.firstName = "Hank"
    user.lastName = "Hill"
    user._id = "56413a1512d4fb16616a8af0"
    
    model.user = User()
  }
  
  private func setupSockets() {
    
    // subscribe to broadcasts done by the server
    socket.on("message") { [unowned self] data, socket in
      for object in data {
        guard let newMessage = IncomingMessage(data: object).toJSQMessage()
          else { return }
        self.model.messages.append(newMessage)
        // broadcast to all listeners that a message was received
        self.didReceiveMessage => true
        log.verbose(newMessage.text)
      }
    }
    
    // subscribe to the server chat framework's messages callback
    socket.on("checkForMessagesCallback") { data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let messages = json["response"]["messages"].arrayObject {
          for object in messages {
            guard let newMessage = IncomingMessage(data: object).toJSQMessage()
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
    }
    
    // subscribe to the server chat framework's broadcast callback
    socket.on("broadcastCallback") { [unowned self] data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        
        // broadcast to listeners that the message sent was successful
        if let response = json["response"].string where response == "OK" {
          self.didSendMessage => true
          log.info(response)
          
          // broadcast to listenres that the message sent was unsuccessful
        } else if let error = json["error"].string {
          self.didSendMessage => false
          log.error(error)
        }
      }
    }
    
    // connect to server
    socket.connect()
    
    // subscribe to user's own room
    if let user = model.user, let _id = user._id {
      socket.emit("subscribe", _id)
    }
    
    NSTimer.after(1.0) { [unowned self] in
      self.socket.emit("subscribe", "56413a1512d4fb16616a8af0")
      
      let message: [String: AnyObject] = [
        "user_id": "56413a1512d4fb16616a8af0",
        "friend_id": "56413a2e12d4fb16616a8af3",
        "friend_username": "Barcelona",
        "message": "Hello, how are you?"
      ]
      
      self.socket.emit("broadcast", message)
    }
    
    NSTimer.after(3.0) { [unowned self] in
      self.socket.emit("subscribe", "56413a2e12d4fb16616a8af3")
      self.socket.emit("checkForMessages", "56413a2e12d4fb16616a8af3")
    }
    
    NSTimer.after(4.0) { [unowned self] in
      let message: [String: AnyObject] = [
        "user_id": "56413a2e12d4fb16616a8af3",
        "friend_id": "56413a1512d4fb16616a8af0",
        "friend_username": "Jynx",
        "message": "I'm fine thank you :)"
      ]
      self.socket.emit("broadcast", message)
    }
    
    NSTimer.after(10.0) { [unowned self] in
      self.socket.disconnect()
    }
  }
  
  public func didPressSendButton(text: String) {
    guard let message = createMessage(text) else { return }
    self.socket.emit("broadcast", message)
  }
  
  private func createMessage(text: String) -> JSQMessage? {
    guard let user = model.user,
          let _id = user._id,
          let username = user.username
          else { return nil }
    let newOutgoingMessage = OutgoingMessage(
      user_id: _id,
      username: username,
      message: text
    )
    return newOutgoingMessage.toJSQMessage()
  }
}