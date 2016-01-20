//
//  Async.swift
//  Async
//
//  Created by Andrew Aquino on 1/19/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation

public class Async {
  
  public class func background(block: (() -> Void)) {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
//    dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0), block)
  }
  
  public class func main(block: () -> Void) {
    dispatch_async(dispatch_get_main_queue(), block)
  }
}
