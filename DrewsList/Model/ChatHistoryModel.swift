//
//  ChatListModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import RealmSwift

public class ChatHistoryModel {
  
  public let _chat = Signal<[ChatModel]>()
  public var chat = [ChatModel]() { didSet { _chat => chat } }
  
  public init() {
    test()
  }
}

import PromiseKit

public func test() {
  log.debug("this will run")
  promise()
  .then { result in
    log.info(result)
  }
  .error { error in
    log.error(error)
  }
  log.debug("this will run after")
}

public func promise() -> Promise<String> {
  return Promise { fulfill, reject in
    // pretend this closure is going to take
    // 10 seconds to complete
    fulfill("this will run way after")
    // OR, somewhere along the computing,
    // an error occurs
//    reject(NSError(domain: "some error", code: 404, userInfo: nil))
  }
}