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


public class Activity {
  
  public let _message = Signal<JSON?>()
  public var message: JSON? { didSet { _message => message } }
  
  public let _timestamp = Signal<String?>()
  public var timestamp: String? { didSet { _timestamp => timestamp } }
  
  public let _leftImage = Signal<String?>()
  public var leftImage: String? { didSet { _leftImage => leftImage } }

  public let _rightImage = Signal<String?>()
  public var rightImage: String? { didSet { _rightImage => rightImage } }
  
  public let _type = Signal<ActivityType>()
  public var type: ActivityType = .None { didSet { _type => type } }
  
  public convenience init(message: JSON?, timestamp: String?, type: String?, leftImage: String?, rightImage: String?) {
    self.init()
    
    self.message = message
    self.timestamp = timestamp
    self.type = ActivityType.getType(type)
    self.leftImage = leftImage
    self.rightImage = rightImage
  }
  
  public func getUser() -> User? {
    return User().set(_id: message?["friend_id"].string).set(username: message?["friend_username"].string).set(imageUrl: message?["friend_image"].string)
  }
  
  public func getMessage() -> NSMutableAttributedString? {
    switch type {
    case .Chat:
      return NSMutableAttributedString(string: (message?["message"].string ?? ""), attributes: [
        NSFontAttributeName: UIFont.asapRegular(12),
        NSForegroundColorAttributeName: UIColor.blackColor()
      ])
    case .None: break
    }
    return nil
  }
  
  public func getDetailedMessage(modifier: String? = nil) -> NSMutableAttributedString? {
    switch type {
    case .Chat:
      let attributedString = NSMutableAttributedString(string: (message?["friend_username"].string ?? ""), attributes: [
        NSFontAttributeName: UIFont.asapBold(12),
        NSForegroundColorAttributeName: UIColor.bareBlue()
      ])
      
      let attributedString2 = NSMutableAttributedString(string: " sent you a message: ", attributes: [
        NSFontAttributeName: UIFont.asapRegular(12),
        NSForegroundColorAttributeName: UIColor.blackColor()
      ])
      
      let attributedString3 = NSMutableAttributedString(string: " " + (message?["createdAt"].string?.toRelativeString() ?? "") + "\n", attributes: [
        NSFontAttributeName: UIFont.asapRegular(12),
        NSForegroundColorAttributeName: UIColor.sexyGray()
      ])
      
      attributedString.appendAttributedString(attributedString2)
      attributedString.appendAttributedString(attributedString3)
      if let message = getMessage() { attributedString.appendAttributedString(message) }
      
    return attributedString

    case .None: break
    }
    return nil
  }
}

public class RealmActivity: Object {
  
  dynamic var message: NSData?
  dynamic var timestamp: String?
  dynamic var leftImage: String?
  dynamic var rightImage: String?
  dynamic var type: String?

  public convenience init(activity: Activity?) {
    self.init()
    
    if let dictionary = activity?.message?.dictionaryObject { message = NSKeyedArchiver.archivedDataWithRootObject(dictionary) }
    
    timestamp = activity?.timestamp
    leftImage = activity?.leftImage
    rightImage = activity?.rightImage
    type = activity?.type.getValue()
    
//    log.debug(getMessage())
//    log.debug(leftImage)
//    log.debug(rightImage)
//    log.debug(type)
  }
  
  public func getMessage() -> JSON? {
    if let message = message, let dictionary = NSKeyedUnarchiver.unarchiveObjectWithData(message) as? [String: AnyObject]{ return JSON(dictionary) }
    else { return nil }
  }
  
  public func getType() -> ActivityType {
    return ActivityType.getType(type)
  }
  
  public func getActivity() -> Activity {
    return Activity(message: getMessage(), timestamp: timestamp, type: type, leftImage: leftImage, rightImage: rightImage)
  }
}












