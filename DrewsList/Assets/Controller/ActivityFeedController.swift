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
      // parse the message sent from the server
      
      // check if the message is a chat
      if let message = json["message"]["message"].string, let username = json["message"]["friend_username"].string where json["identifier"].string == "CHAT" && self?.socket.isCurrentlyInChat == false {
        self?.model.activity = "\(username): \(message)"
        
      // else check if the message is a transfer request
      } else if let message = json["message"]["message"].string, let username = json["message"]["friend_username"].string where json["identifier"].string == "TRANSFER_REQUEST" {
          self?.model.activity = "\(username): \(message)"
        
      // else check if the message is a alert saying that you have a potential buyer/seller 'match'
      } else if let message = json["message"]["message"].string, let username = json["message"]["friend_username"].string where json["identifier"].string == "LIST_MATCH" {
        self?.model.activity = "\(username): \(message)"
      }
    }
  }
}