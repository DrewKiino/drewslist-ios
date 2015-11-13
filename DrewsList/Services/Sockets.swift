//
//  Sockets.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/12/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Socket_IO_Client_Swift
import Signals
import PromiseKit
import SwiftyJSON


public class Sockets {
  
  private struct Singleton { static let socket = Sockets() }
  public class func sharedInstance() -> Sockets { return Singleton.socket }
  
  public let socket = SocketIOClient(
//    socketURL: "http://localhost:1337",
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
        ]
      )
    ]
  )
  
  public let _session_id = Signal<String?>()
  public var session_id: String? = nil { didSet { _session_id => session_id } }
  
  public func connect(executeOnConnect: NormalCallback? = nil) {
    // subscribe to default streams
    socket.on("error") { data, socket in
      log.error(data)
    }
    socket.on("connect") { data, socket in
      log.info("connection established.")
      executeOnConnect?(data, socket)
    }
    socket.on("reconnect") { data, socket in
      log.debug(data)
    }
    socket.on("reconnectAttempt") { data, socket in
      log.debug(data)
    }
    socket.on("disconnect") { [unowned self] data, socket in
      log.info("disconnected from server.")
    }
    socket.on("connectCallback") { [unowned self] data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let response = json["response"].string {
          // set session id and publish
          self.session_id = response
          if  let session_id = self.session_id {
            log.info("session ID: \(session_id)")
          }
        } else if let error = json["error"].string {
          log.debug(error)
        }
      }
    }
    socket.connect()
  }
  
  public func disconnect() { socket.disconnect() }
  
  public func onConnect(execute: NormalCallback) {
    socket.on("connect", callback: execute)
  }
  
  public func isConnected() -> Bool {
    return socket.status.description == "Connected" ? true : false
  }
  
  public func on(event: String, execute: NormalCallback) {
    socket.on(event, callback: execute)
  }
  
  public func emit(event: String, _ object: [String: AnyObject], forceConnection: Bool = false) {
    if isConnected() {
      socket.emit(event, object)
    } else if forceConnection {
      connect() { data, socket in
        self.socket.emit(event, object)
      }
    }
  }
  
  public func emit(event: String, _ object: String, forceConnection: Bool = false) {
    if isConnected() {
      socket.emit(event, object)
    } else if forceConnection {
      connect() { data, socket in
        self.socket.emit(event, object)
      }
    }
  }
}