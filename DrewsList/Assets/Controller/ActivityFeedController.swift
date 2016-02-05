//
//  ActivityFeedController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/10/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON
import Signals

public class ActivityFeedController {
  
  private struct Singleton { private static let _didUpdateChat = Signal<Bool>() }
  public class func shared_didUpdateChat() -> Signal<Bool> { return Singleton._didUpdateChat }
  
  public let model = ActivityFeedModel()
  
  private let socket = Sockets.sharedInstance()
  
  public init() {
    setupSelf()
    setupSockets()
  }
  
  public func viewDidAppear() {
    getActivityFeedFromServer()
  }
  
  private func setupSelf() {
    readRealmUser()
  }
  
  private func setupSockets() {
    socket.onConnect("activityFeedController") { [weak self] in
      self?.readRealmUser()
      self?.getActivityFeedFromServer()
    }
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      self?.readRealmUser()
      self?.getActivityFeedFromServer()
    }
  }
  
  public func getActivityFeedFromServer() {
    socket.on("activityFeed.getActivityHistory.response") { [weak self] json in
      if let jsonArray = json["activities"].array {
        
        self?.model.activities.removeAll(keepCapacity: false)
        
        for json in jsonArray {
          self?.model.activities.append(Activity(json: json))
        }
      }
    }
    
    socket.emit("activityFeed.getActivityHistory", [ "user_id": model.user?._id ?? "" ])
  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}