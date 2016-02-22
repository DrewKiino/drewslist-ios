//
//  PushModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 1/12/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals

public class PushModel {
  
  public let _authorizationStatus = Signal<Bool>()
  public var authorizationStatus: Bool = false { didSet { _authorizationStatus => authorizationStatus } }
}