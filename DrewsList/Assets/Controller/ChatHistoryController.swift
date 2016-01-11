//
//  ChatHistoryController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation

public class ChatHistoryController {
  
  private let socket = Sockets.sharedInstance()
  
  public let model = ChatHistoryModel()
  
  public init() {
    setupDataBinding()
    setupSockets()
  }
  
  public func setupDataBinding() {
  }
  
  
  private func setupSockets() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      if let message = json["message"].dictionaryObject where json["identifier"].string == "activity" && self?.socket.isCurrentlyInChat == false {
        
      }
    }
  }
}