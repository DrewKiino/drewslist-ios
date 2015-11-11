//
//  UserModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class User {
  
  public let _firstName = Signal<String?>()
  public var firstName: String?
  
  public let _lastName = Signal<String?>()
  public var lastName: String?
  
  public let _username = Signal<String?>()
  public var username: String?
  
  public let __id = Signal<String?>()
  public var _id: String?
}