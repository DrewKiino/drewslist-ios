//
//  Whirlpool.swift
//  Whirlpool
//
//  Created by Andrew Aquino on 6/4/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Tide
import SwiftDate
import Async
import SwiftyTimer

// Whirlpool Chat Framework
public struct Whirlpool {
  // The model schema for Whirlpool's MVC design
}

// utility extensions

extension NSDate {
  
  public func toSimpleString(dateStyle: NSDateFormatterStyle = .ShortStyle, timeStyle: NSDateFormatterStyle = .ShortStyle) -> String? {
    if self >= NSDate() - 60.seconds {
      return "Just Now"
    } else if let dateString = toString(
      dateStyle: dateStyle,
      timeStyle: timeStyle,
      inRegion: DateRegion(),
      relative: true
    ) {
      if isInToday() {
        return dateString.stringByReplacingOccurrencesOfString("Today, ", withString: "")
      } else {
        return dateString.stringByReplacingOccurrencesOfString(", ", withString: " ")
      }
    }
    return nil
  }
}








