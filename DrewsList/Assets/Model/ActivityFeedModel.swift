//
//  ActivityFeedModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/10/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals

public class ActivityFeedModel {
  
  public let _activity = Signal<String?>()
  public var activity: String? { didSet { _activity => activity } }
  
}