//
//  AccountSettingsModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/21/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class AccountSettingsModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
}