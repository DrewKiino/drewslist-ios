//
//  ActivityFeedModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/10/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals
import RealmSwift

public class ActivityFeedModel {
  
  public let _activity = Signal<Activity?>()
  public var activity: Activity? { didSet { _activity => activity } }
  
  public let _activities = Signal<[Activity]>()
  public var activities: [Activity] = [] { didSet { _activity => activities.first; _activities => activities } }
}

public class Activity: Object {
  
  public let _message = Signal<String?>()
  public var message: String? { didSet { _message => message } }
  
  public let _timestamp = Signal<String?>()
  public var timestamp: String? { didSet { _timestamp => timestamp } }
  
  public let _leftImage = Signal<String?>()
  public var leftImage: String? { didSet { _leftImage => leftImage } }

  public let _rightImage = Signal<String?>()
  public var rightImage: String? { didSet { _rightImage => rightImage } }
  
  public convenience init(message: String?, timestamp: String?, leftImage: String?, rightImage: String?) {
    self.init()
    self.message = message
    self.timestamp = timestamp
    self.leftImage = leftImage
    self.rightImage = rightImage
  }
}