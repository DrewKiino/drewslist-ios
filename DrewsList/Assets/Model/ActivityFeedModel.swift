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
import SwiftyJSON
import ObjectMapper
import CoreLocation

public enum ActivityType {
  
  case Chat
  case None
  
  public func getValue() -> String {
    switch self {
    case .Chat: return "CHAT"
    case .None: return "NONE"
    }
  }
  
  public static func getType(type: String?) -> ActivityType {
    switch type ?? "" {
    case "CHAT": return ActivityType.Chat
    default: return ActivityType.None
    }
  }
}

public class ActivityFeedModel {
  
  public let _activity = Signal<Activity?>()
  public var activity: Activity? { didSet { _activity => activity } }
  
  public let _activities = Signal<[Activity]>()
  public var activities: [Activity] = [] { didSet { _activity => activities.first; _activities => activities } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _badgeCount = Signal<Int>()
  public var badgeCount: Int = 0 { didSet { _badgeCount => badgeCount } }
}

public class Activity: Mappable {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _message = Signal<String?>()
  public var message: String? { didSet { _message => message } }
  
  public let _room_id = Signal<String?>()
  public var room_id: String? { didSet { _room_id => room_id } }
  
  public let _session_id = Signal<String?>()
  public var session_id: String? { didSet { _session_id => session_id } }

  public let _timestamp = Signal<String?>()
  public var timestamp: String? { didSet { _timestamp => timestamp } }
  
  public var leftImage: String? { get { return user?.imageUrl ?? "" } }

  public let _rightImage = Signal<String?>()
  public var rightImage: String? { didSet { _rightImage => rightImage } }
  
  public let _type = Signal<String?>()
  public var type: String? { didSet { _type => type } }
  
  public var isSeen: Bool = false
  
  // MARK: Location Message
  
  public let _latitude = Signal<Double?>()
  public var latitude: Double? { didSet { _latitude => latitude } }
  
  public let _longitude = Signal<Double?>()
  public var longitude: Double? { didSet { _longitude => longitude } }
  
  public var location: CLLocation? { get {
    if let latitude = latitude, let longitude = longitude {
      return CLLocation(latitude: latitude, longitude: longitude)
    }
    return nil
    }
  }
  
  public init() {}
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    user        <- map["user"]
    type        <- map["type"]
    message     <- map["message"]
    timestamp   <- map["timestamp"]
    session_id  <- map["session_id"]
    room_id     <- map["room_id"]
    isSeen      <- map["isSeen"]
    
    // MARK: location message data
    latitude    <- map["latitude"]
    longitude   <- map["longitude"]
  }
  
  public convenience init(message: String?, timestamp: String?, type: String?) {
    self.init()
    
    self.message = message
    self.timestamp = timestamp
    self.type = type
  }
  
  public func getMessage() -> NSMutableAttributedString? {
    switch ActivityType.getType(type) {
    case .Chat:
      return message == "USER_LOCATION" ? nil :
        NSMutableAttributedString(string: (message ?? ""), attributes: [
          NSFontAttributeName: UIFont.asapRegular(12),
          NSForegroundColorAttributeName: UIColor.blackColor()
        ])
    case .None: break
    }
    return nil
  }
  
  public func getDetailedMessage(modifier: String? = nil) -> NSMutableAttributedString? {
    switch ActivityType.getType(type) {
    case .Chat:
      
      let attributedString: NSMutableAttributedString! = NSMutableAttributedString(string: (user?.getName() ?? ""), attributes: [
        NSFontAttributeName: UIFont.asapBold(12),
        NSForegroundColorAttributeName: UIColor.bareBlue()
      ])
      
      // check if the message is a location message
      var attributedString2: NSMutableAttributedString!
      if message == "USER_LOCATION" {
        attributedString2 = NSMutableAttributedString(string: " sent you their location: ", attributes: [
          NSFontAttributeName: UIFont.asapRegular(12),
          NSForegroundColorAttributeName: UIColor.blackColor()
        ])
      // if not, then create a regular message alert
      } else {
        attributedString2 = NSMutableAttributedString(string: " sent you a message: ", attributes: [
          NSFontAttributeName: UIFont.asapRegular(12),
          NSForegroundColorAttributeName: UIColor.blackColor()
        ])
      }
      
      var string: String? = timestamp?.toRelativeString()
      var attributedString3: NSMutableAttributedString! = NSMutableAttributedString(string: "\(string?.characters.count > 7 ? "\n\(string ?? "") " : "\(string ?? "")\n")", attributes: [
        NSFontAttributeName: UIFont.asapRegular(12),
        NSForegroundColorAttributeName: UIColor.sexyGray()
      ])
      
      attributedString.appendAttributedString(attributedString2)
      attributedString.appendAttributedString(attributedString3)
      
      if let message = getMessage() { attributedString.appendAttributedString(message) }
      
      attributedString2 = nil
      attributedString3 = nil
      string = nil
      
    return attributedString

    case .None: break
    }
    return nil
  }
  
  public func isLocationActivity() -> Bool {
    return latitude != nil && longitude != nil && latitude != 0.0 && longitude != 0.0
  }
}













