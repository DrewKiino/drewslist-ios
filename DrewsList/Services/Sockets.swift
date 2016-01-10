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
import Alamofire

public enum ServerUrl {
  case Local
  case Staging
  public func getValue() -> String {
    switch self {
    case .Local: return "http://localhost:1337"
    case .Staging: return "https://drewslist-staging.herokuapp.com"
    }
  }
}

public class Sockets {
  
  private struct Singleton {
    static let socket = Sockets()
    static var _sessionCount = 0
    static var sessionCount: Int { get { return _sessionCount++ } }
  }
  
  public class func sharedInstance() -> Sockets { return Singleton.socket }
  public class func getSessionCount() -> Int { return Singleton.sessionCount }
  
  public let _session_id = Signal<String?>()
  public var session_id: String? = nil { didSet { _session_id => session_id } }
  public let socket = Sockets.new()
  
  private var disconnectHandler: (() -> Void)? = nil
  
  public func connect(execute: (() -> Void)? = nil) {
    // reset all handlers
    socket.removeAllHandlers()
    // subscribe to default streams
    socket.on("message") { data, socket in
      log.debug(data)
    }
    socket.on("error") { data, socket in
      log.error(data)
    }
    socket.on("connect") { data, socket in
      log.info("connection established.")
      execute?()
    }
    socket.on("reconnect") { data, socket in
      log.debug(data)
    }
    socket.on("reconnectAttempt") { data, socket in
      log.debug(data)
    }
    socket.on("disconnect") { [weak self] data, socket in
      log.info("disconnected from server.")
      self?.socket.removeAllHandlers()
      self?.disconnectHandler?()
      self?.disconnectHandler = nil
    }
    socket.on("connectCallback") { [weak self] data, socket in
      guard let jsonArray = JSON(data).array else { return }
      for json in jsonArray {
        if let response = json["response"].string {
          
          // set session id and publish
          self?.session_id = response
          
          if let session_id = self?.session_id {
            log.info("session ID: \(session_id)")
          }
          
        } else if let error = json["error"].string {
          log.debug(error)
        }
      }
    }
    socket.on("dataReady") { data, socket in
      log.debug(data)
    }
    socket.connect()
  }
  
  public class func new() -> SocketIOClient {
    let socket = SocketIOClient(
      socketURL: ServerUrl.Local.getValue(),
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
            ])!
          ]
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
    socket.disconnect()
  }
  
  public func onConnect(execute: () -> Void) {
    socket.on("connect") { data, socket in
      execute()
    }
  }
  
  public func isConnected() -> Bool {
    return socket.status.description == "Connected" ? true : false
  }
  
  public func on(event: String, execute: (JSON -> Void)) {
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
}