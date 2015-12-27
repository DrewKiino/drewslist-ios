//
//  AcctSettingModel.swift
//  DrewsList
//
//  Created by Starflyer on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class AccountSettingsModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }

  
  
}