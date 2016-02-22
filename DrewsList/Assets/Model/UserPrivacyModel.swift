//
//  UserPrivacyModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/21/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals

public class UserPrivacyModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
}