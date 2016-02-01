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
  
  public let _didUpdateChat = Singleton._didUpdateChat
  
  public init() {
    setupSelf()
    setupSockets()
  }
  
  private func setupSelf() {
  }
  
  private func setupSockets() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      // check if the message is a chat
      if json["type"].string == "CHAT" {
        
        // append to the list of activities
        self?.model.activities.insert(Activity(
          message: json["message"],
          timestamp: json["message"]["createdAt"].string,
          type: json["type"].string,
          leftImage: json["message"]["friend_image"].string,
          rightImage: nil
        ), atIndex: 0)
        
        // save current state of activity
        self?.saveActivityFeed()
        
      // else check if the message is a alert saying that you have a potential buyer/seller 'match'
      } else if let message = json["message"]["message"].string, let username = json["message"]["friend_username"].string where json["type"].string == "LIST_MATCH" {
//        self?.model.activity = "\(username): \(message)"
      }
    }
  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
  
  public func saveActivityFeed() {
    if model.activities.isEmpty { return }
    let realm = try! Realm()
    realm.beginWrite()
    // erase the database of activities
    realm.delete(realm.objects(RealmActivity.self))
    // for each activity in the model's activity array, add it to realm
    for var i = 0; i < model.activities.count; i++ {
      // break out of the loop if 20 activites have already been added to realm
      if i == 20 { break }
      realm.add(RealmActivity(activity: model.activities[i]))
    }
    try! realm.commitWrite()
  }
  
  public func loadActivityFeed() {
    // load the activities
    if let activities: [Activity]! = (try! Realm().objects(RealmActivity.self).map { $0.getActivity() }) where activities?.isEmpty == false {
      model.activities = activities
   }
  }
}