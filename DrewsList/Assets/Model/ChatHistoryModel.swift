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
  
  public let _chatModels = Signal<[ChatModel]>()
  public var chatModels = [ChatModel]() { didSet { _chatModels => chatModels } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _shouldRefreshViews = Signal<Bool>()
  public var shouldRefreshViews: Bool = false { didSet { _shouldRefreshViews => shouldRefreshViews } }
  
  public init() {}
}
