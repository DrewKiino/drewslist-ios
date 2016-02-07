//
//  Sockets.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/12/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import SocketIOClientSwift
import Signals
import PromiseKit
import SwiftyJSON
import Alamofire
import RealmSwift

public class Sockets {
  
  private struct Singleton {
    static let socket = Sockets()
    static var _sessionCount = 0
    static var sessionCount: Int { get { return _sessionCount++ } }
  }
  
  public class func sharedInstance() -> Sockets { return Singleton.socket }
  public class func getSessionCount() -> Int { return Singleton.sessionCount }
  
  // MARK: Realm Functions
  
  private var user: User?
  
  private func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { user = realmUser.getUser() } }
  private func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.user), update: true) } }
  
  // MARK: Socket Functions
  
  public let _session_id = Signal<String?>()
  public var session_id: String? = nil { didSet { _session_id => session_id } }
  public let socket = Sockets.new()
  public var isCurrentlyInChat: Bool = false
  
  public var connectExecutionArray: [String: () -> Void]?
  public var reconnectExecutionArray: [String: () -> Void]?
  
  public let _message = Signal<JSON>()
  
  private var disconnectHandler: (() -> Void)? = nil
  
  public func connect(execute: (() -> Void)? = nil) {
    // reset all handlers
    socket.removeAllHandlers()
    // subscribe to default streams
    socket.on("error") { data, socket in
      log.error(data)
    }
    socket.on("connect") { [weak self] data, socket in
      log.info("connection established.")
      
      execute?()
      
      if let executions = self?.connectExecutionArray?.values {
        for execute in executions {
          execute()
        }
      }
    }
    socket.on("reconnect") { data, socket in
    }
    socket.on("reconnectAttempt") { [weak self] data, socket in
      log.info("attempting to reconnect.")
      if let executions = self?.reconnectExecutionArray?.values {
        for execute in executions {
          execute()
        }
      }
    }
    socket.on("disconnect") { [weak self] data, socket in
      log.info("disconnected from server.")
      self?.socket.removeAllHandlers()
      self?.disconnectHandler?()
      self?.disconnectHandler = nil
    }
    socket.on("connect.response") { [weak self] data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let response = json["response"].string {
          
          // set session id and publish
          self?.session_id = response
          
          if let session_id = self?.session_id {
            log.info("session ID: \(session_id)")
          }
          
          self?.setOnlineStatus(true)
          
        } else if let error = json["error"].string {
          log.debug(error)
        }
      }
    }
    socket.on("dataReady") { data, socket in
      log.debug(data)
    }
    socket.on("setOnlineStatus.response") { [weak self] data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let response = json["response"].bool {
          if let user_id = self?.user?._id where response == true {
            log.info("\(user_id): ONLINE")
          } else if let user_id = self?.user?._id where response == false {
            log.info("\(user_id): OFFLINE")
          }
        }
      }
    }
    socket.on("message") { [weak self] data, socket in
      if let json = JSON(data).array?.first { self?._message.fire(json) }
    }
    socket.connect()
  }
  
  public class func new() -> SocketIOClient {
    
    let socket = SocketIOClient(
      socketURL: NSURL(string: ServerUrl.Default.getValue()) ?? NSURL(),
      options: [
        .Log(false),
        .ForcePolling(false),
        .Cookies([
          NSHTTPCookie(properties: [
            NSHTTPCookieDomain: UIDevice.currentDevice().identifierForVendor!.UUIDString,
            NSHTTPCookiePath: "",
            NSHTTPCookieName: "client",
            NSHTTPCookieValue: UIDevice.currentDevice().identifierForVendor!.UUIDString,
            NSHTTPCookieSecure: true,
            NSHTTPCookieExpires: NSDate(timeIntervalSinceNow: 60)
          ])!]
        )
      ]
    )
    return socket
  }
  
  public class func request(event: String, parameters: AnyObject...) -> Promise<JSON> {
    return Promise { fulfill, reject in
      let tempSocket = Sockets.new()
      tempSocket.on(event + ".response") { data, socket in
        if let jsonArray = JSON(data).array, let json = jsonArray.first {
          fulfill(json)
        }
        tempSocket.disconnect()
      }
      tempSocket.on("connect") { data, socket in
        tempSocket.emit(event, parameters)
      }
      tempSocket.on(event + ".error") { data, socket in
        if let jsonArray = JSON(data).array, let error = jsonArray.first?["error"].string {
          reject(NSError(domain: error, code: 404, userInfo: nil))
        }
        log.error(data)
        tempSocket.disconnect()
      }
      tempSocket.connect()
    }
  }

  public func disconnect(execute: (() -> Void)? = nil) {
    disconnectHandler = execute
    socket.removeAllHandlers()
    socket.disconnect()
  }
  
  public func onConnect(host: String, execute: () -> Void) {
    if connectExecutionArray != nil {
      connectExecutionArray?.updateValue(execute, forKey: host)
    } else {
      connectExecutionArray = [host: execute]
    }
  }
  
  public func onReconnectAttempt(host: String, execute: () -> Void) {
    if reconnectExecutionArray != nil {
      reconnectExecutionArray?.updateValue(execute, forKey: host)
    } else {
      reconnectExecutionArray = [host: execute]
    }
  }
  
  public func isConnected() -> Bool {
    return socket.status.description == "Connected" ? true : false
  }
  
  public func off(event: String) {
    socket.off(event)
  }
  
  public func on(event: String, execute: (JSON -> Void)) {
    socket.off(event)
    socket.on(event) { data, socket in
      if let json = JSON(data).array?.first { execute(json) }
    }
  }
  
  public func emit(event: String, _ object: [String: AnyObject], forceConnection: Bool = false) {
    if isConnected() {
      socket.emit(event, object)
    } else if forceConnection {
      connect() { [unowned self] in self.socket.emit(event, object) }
    }
  }
  
  public func emit(event: String, _ object: String, forceConnection: Bool = false) {
    if isConnected() {
      socket.emit(event, object)
    } else if forceConnection {
      connect() { [unowned self] in self.socket.emit(event, object) }
    }
  }
  
  public func setOnlineStatus(bool: Bool) {
    // if user is already logged in
    // set online status to
    readRealmUser()
    
    if let user = user, let user_id = user._id {
      socket.emit("setOnlineStatus", [
        "user_id": user_id,
        "online": bool
      ])
    }
  }
}