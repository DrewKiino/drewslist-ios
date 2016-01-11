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
  }

}