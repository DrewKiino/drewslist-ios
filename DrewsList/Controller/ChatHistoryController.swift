//
//  ChatHistoryController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation

public class ChatHistoryController {
  
  private let userController = UserController.sharedInstance()
  private let socket = Sockets.sharedInstance()
  
  public let model = ChatHistoryModel()
  
  public init() {
    setupDataBinding()
  }
  
  public func setupDataBinding() {
  }
}