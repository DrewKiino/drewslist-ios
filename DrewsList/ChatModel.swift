//
//  ChatModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation

public class ChatModel {
  
  public var messages: [Message] = []
}

public class Message {
  
  public var text: String?
  
  public init(text: String) {
    self.text = text
  }
}