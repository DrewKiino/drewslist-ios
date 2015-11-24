//
//  ChatHistoryController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import JSQMessagesViewController

public class ChatHistoryController {
  
  private let socket = Sockets.sharedInstance()
  
  public let model = ChatHistoryModel()
  
  public init() {
    setupFixtures()
  }
  
  public func get_Chat() -> Signal<[ChatModel]> {
    return model._chat
  }

  public func getChat() -> [ChatModel] {
    return model.chat
  }
  
  public func setupFixtures() {
    let chatmodel = ChatModel()
    
    chatmodel.user = UserController.userFixtures()
    chatmodel.friend = UserController.friendFixtures()
    chatmodel.book = "Calculus 7th Edition"
    chatmodel.messages.append(JSQMessage(senderId: "1234", displayName: "Lisa", text: "Thanks for the sale! I'll rate you in a bit"))
    
    model.chat.append(chatmodel)
    
    let chatmodel2 = ChatModel()
    
    chatmodel2.user = UserController.friendFixtures()
    chatmodel2.friend = UserController.userFixtures()
    chatmodel2.book = "Flowers for Algernon"
    chatmodel2.messages.append(JSQMessage(senderId: "1234", displayName: "Bobby", text: "Are you willing to sell the calculus book??? I brought a couple hundred dollars today if your willing to sell it to me."))
    
    model.chat.append(chatmodel2)
  }
}