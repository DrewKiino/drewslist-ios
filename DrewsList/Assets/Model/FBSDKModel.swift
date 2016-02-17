//
//  FBSDKModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/8/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals

public class FBSDKModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _friends = Signal<[User]>()
  public var friends: [User] = [] { didSet { _friends => friends } }
}