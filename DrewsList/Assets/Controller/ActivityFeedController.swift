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
  
  public let model = ActivityFeedModel()
  
  private let socket = Sockets.sharedInstance()
  
  public let didGetActivityHistoryFromServer = Signal<Bool>()
  
  public init() {
    setupSelf()
    setupSockets()
    setupDataBinding()
  }
  
  public func viewDidAppear() {
    markActivitiesAsSeen()
    getActivityFeedFromServer()
  }
  
  private func setupSelf() {
    readRealmUser()
  }
  
  private func setupDataBinding() {
    UserController.sharedUser()._user.removeListener(self)
    UserController.sharedUser()._user.listen(self) { [weak self] user in
      self?.model.user = user
    }
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
      if let jsonArray = json["activities"].array where !jsonArray.isEmpty {
        
        // reset the badge count
        self?.model.badgeCount = 0
        
        self?.model.activities.removeAll(keepCapacity: false)
        
        for json in jsonArray {
          // add the activity results into the model
          self?.model.activities.append(Activity(json: json))
          
          // increment the badge count for each unread activity
          self?.model.badgeCount += (json["isSeen"].bool ?? false) ? 0 : 1
        }
        
        self?.didGetActivityHistoryFromServer.fire(true)
        
      } else {
        
        self?.didGetActivityHistoryFromServer.fire(false)
      }
    }
    
    socket.emit("activityFeed.getActivityHistory", [ "user_id": model.user?._id ?? "" ])
  }
  
  public func markActivitiesAsSeen() {
    socket.on("activityFeed.markActivitiesAsSeen.response") { [weak self] json in
    }
    
    socket.emit("activityFeed.markActivitiesAsSeen", [ "user_id": model.user?._id ?? "" ])
  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}