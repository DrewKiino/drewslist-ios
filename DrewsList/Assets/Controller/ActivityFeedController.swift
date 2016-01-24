//
//  ActivityFeedController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/10/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation

public class ActivityFeedController {
  
  public let model = ActivityFeedModel.sharedInstance()
  
  private let socket = Sockets.sharedInstance()
  
  public init() {
    setupSockets()
  }
  
  private func setupSockets() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      // check if the message is a chat
      if json["type"].string == "CHAT" && self?.socket.isCurrentlyInChat == false {
        self?.model.activities.insert(Activity(
          message: json["message"],
          timestamp: json["message"]["createdAt"].string,
          type: json["type"].string,
          leftImage: json["message"]["friend_image"].string,
          rightImage: nil
        ), atIndex: 0)
      // else check if the message is a alert saying that you have a potential buyer/seller 'match'
      } else if let message = json["message"]["message"].string, let username = json["message"]["friend_username"].string where json["type"].string == "LIST_MATCH" {
//        self?.model.activity = "\(username): \(message)"
      }
    }
  }
}