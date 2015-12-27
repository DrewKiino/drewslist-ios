//
//  CommunityModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class CommunityFeedModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
}