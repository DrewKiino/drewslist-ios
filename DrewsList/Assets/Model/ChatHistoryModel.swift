//
//  ChatListModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class ChatHistoryModel {
  
  public let _chat = Signal<[ChatModel]>()
  public var chat = [ChatModel]() { didSet { _chat => chat } }
  
  public init() {
  }
}
