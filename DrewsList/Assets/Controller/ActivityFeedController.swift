//
//  ActivityFeedController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/10/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation

public class ActivityFeedController {
  
  public let model = ActivityFeedModel()
  
  private let socket = Sockets.sharedInstance()
  
  public init() {
    setupSockets()
  }
  
  
  private func setupSockets() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      if let message = json["message"]["message"].string, let username = json["message"]["friend_username"].string where json["identifier"].string == "activity" && self?.socket.isCurrentlyInChat == false {
        self?.model.activity = "\(username): \(message)"
      }
    }
  }
}