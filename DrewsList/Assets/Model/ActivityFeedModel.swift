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
  
  public let _activity = Signal<String?>()
  public var activity: String? { didSet { _activity => activity } }
  
  public let _activities = Signal<[Activity]>()
  public var activities: [Activity] = [] { didSet { _activities => activities } }
}

public class Activity: Object {
  
  public let _activity = Signal<String?>()
  public var activity: String? { didSet { _activity => activity } }
  
  public let _timestamp = Signal<String?>()
  public var timestamp: String? { didSet { _timestamp => timestamp } }
  
  public let _leftImage = Signal<String?>()
  public var leftImage: String? { didSet { _leftImage => leftImage } }

  public let _rightImage = Signal<String?>()
  public var rightImage: String? { didSet { _rightImage => rightImage } }
  
  public convenience init(activity: String?, timestamp: String?, leftImage: String?, rightImage: String?) {
    self.init()
    self.activity = activity
    self.timestamp = timestamp
    self.leftImage = leftImage
    self.rightImage = rightImage
  }
}