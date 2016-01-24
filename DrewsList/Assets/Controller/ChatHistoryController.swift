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
  private let AFModel = ActivityFeedModel.sharedInstance()
  
  public init() {
    setupDataBinding()
    setupSockets()
  }
  
  public func viewDidAppear() {
    let chatModel = ChatModel()
    chatModel.user = User().set(firstName: "Melanie", lastName: "Iglesias").set(imageUrl: "http://orig06.deviantart.net/b682/f/2013/135/4/3/profile_picture_by_mellodydoll_stock-d65fbf8.jpg")
    chatModel.friend = User().set(firstName: "Bobby", lastName: "Hill").set(imageUrl: "http://img08.deviantart.net/9d6c/i/2012/253/4/d/2012_id_by_density_stock-d5e8sph.jpg")
    model.chatModels.append(chatModel)
  }
  
  public func setupDataBinding() {
    AFModel._activity.removeListener(self)
    AFModel._activity.listen(self) { activity in
    }
  }
  
  private func setupSockets() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
      if let message = json["message"].dictionaryObject where json["identifier"].string == "activity" && self?.socket.isCurrentlyInChat == false {
        
      }
    }
  }
}