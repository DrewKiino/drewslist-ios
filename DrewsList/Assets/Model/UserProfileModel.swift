//
//  UserProfileModel.swift
//  DrewsList
//
//  Created by Kevin Mowers on 11/7/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals


public class UserProfileModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
}
