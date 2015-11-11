//
//  NativeExtensions.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation

extension NSData {
  public func toJSONString() -> NSString? {
    let jsonString = NSString(data: self, encoding: NSUTF8StringEncoding)
    return jsonString
  }
}
