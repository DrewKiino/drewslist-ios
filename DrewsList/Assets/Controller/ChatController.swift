//
//  ChatController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import SocketIOClientSwift
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
  
  public let locationController = LocationController.sharedInstance()
  
  // MARK : PUB/SUB
  
  // subscription
  public let willRequestSubscription = Signal<Bool>()
  public let didReceiveSubscriptionResponse = Signal<Bool>()
  
  // message
  public let didSendMessage = Signal<Bool>()
  public let didReceiveMessage = Signal<Bool>()
  public let isSendingMessage = Signal<Bool>()
  
  // message history
  public let didRequestLoadingMessagesFromServer = Signal<Bool>()
  public let didLoadMessagesFromServer = Signal<Bool>()
  public var didPullToRefresh: Bool = false
  
  // variables
  private var unsubscribeBlock: (() -> Void)?
  
  public func viewDidLoad() {
  }
  
  public func viewDidAppear() {
    connectToServer()
  }
  
  public func viewWillDisappear() {
    disconnectFromServer()
  }
  
  public init() {
    setupSelf()
    setupSockets()
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
    socket.onConnect("ChatController") { [weak self] in
      self?.connectToServer()
    }
  }
  
  public func didPressSendButton(text: String) {
    guard let message = createOutgoingMessage(text),
          let json = message.toJSON()
          where !text.isEmpty && socket.isConnected() == true
          else { return }
    
    isSendingMessage => true
    
    socket.emit("broadcast", json)
    
    // set the listing to nil to indicate that the user has already sent which listing he has
    // viewed to the other user
    model.listing = nil
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
    .set(listing: model.listing)
  }
  
  public func didPressSendLocation() {
    locationController.getCurrentLocation() { [weak self] location in
      guard   let message = self?.createOutgoingLocationMessage(location),
              let json = message.toJSON()
      else { return }
      
      self?.isSendingMessage.fire(true)
      
      self?.socket.emit("broadcast", json)
    }
  }
  
  private func createOutgoingLocationMessage(location: CLLocation?) -> OutgoingMessage? {
    return createOutgoingMessage("USER_LOCATION")?.set(location)
  }
  
  public func subscribe() {
    guard let room_id = model.room_id, let user_id = model.user?._id else { return }
    
    willRequestSubscription => true
    
    socket.emit(
      "chat.subscribe",
      [
        "room_id": room_id,
        "user_id": user_id
      ]
    )
  }
  
  public func unsubscribe(completionHandler: () -> Void) {
    guard let room_id = model.room_id, let user_id = model.user?._id else { return }
    
    socket.emit(
      "chat.unsubscribe",
      [
        "room_id": room_id,
        "user_id": user_id
      ]
    )
    
    unsubscribeBlock = completionHandler
  }
  
  public func connectToServer() {
    
    // subscribe to the server chat framework's connect callback
    socket.on("chat.subscribe.response") { [weak self] json in
      
      if let response = json["response"].string {
        log.info("joined room: \(response)")
      } else if let error = json["error"].string {
        log.debug(error)
      }
      
      self?.didReceiveSubscriptionResponse.fire(true)
    }
    
    socket.on("chat.unsubscribe.response") { [weak self] json in
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
        
        self.didSendMessage => true
        
        // broadcast to listeners that the message sent was successful
      } else if let response = json["response"].string {
        self.didSendMessage => true
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
    
    // subscribe user to chat room
    subscribe()
    // get message history
    getChatHistoryFromServer(model.messages.count, paging: 10)
    // publish to all subscribers that the user is in chat view
    socket.isCurrentlyInChat = true
  }
  
  public func disconnectFromServer(execute: (() -> Void)? = nil) {
    // unsubsribe user from chat room
    unsubscribe { [weak self] in
      execute?()
    }
    // publish to all subscribers that the user is no longer in chat view
    socket.isCurrentlyInChat = false
  }
  
  public func getChatHistoryFromServer(skip: Int = 0, paging: Int = 10) {
    
    didRequestLoadingMessagesFromServer => true
    
//    model.messages.removeAll(keepCapacity: false)
    
    // subscribe to the server chat framework's messages callback
    socket.on("chat.getChatHistory.response") { [weak self] json in
      
      if let error = json["error"].string {
        self?.didLoadMessagesFromServer.fire(false)
        return log.error(error)
        
      } else if json["messages"].array?.isEmpty == true {
        self?.didLoadMessagesFromServer.fire(false)
        return
        
      } else {
        
        json["messages"].array?.forEach { [weak self] json in
          if let message = IncomingMessage(json: json).toJSQMessage() { self?.model.messages.insert(message, atIndex: 0) }
        }
        
        // get teh time stamp of the most recent message
        self?.model.mostRecentTimestamp = json["messages"].array?.first?["createdAt"].string
        
        self?.didLoadMessagesFromServer.fire(true)
      }
    }
    
    socket.emit("chat.getChatHistory", [
      "user_id": model.friend?._id ?? "",
      "room_id": model.room_id ?? "",
      "skip": skip,
      "paging": paging
    ])
  }
  
  public func routeToLocation(location: CLLocation?, host: String? = nil, callback: () -> Void) {
    locationController.routeToLocation(location, host: host) { callback() }
  }
}