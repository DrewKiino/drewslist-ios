//
//  ListFeedModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class ListFeedModel {
  
  public let _listings = Signal<[Listing]>()
  public var listings: [Listing] = [] { didSet { _listings => listings } }
  
  public let _listType = Signal<String?>()
  public var listType: String? { didSet { _listType => listType  } }
  
  public let _shouldLockView = Signal<Bool>()
  public var shouldLockView: Bool = false { didSet { _shouldLockView => shouldLockView } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
}