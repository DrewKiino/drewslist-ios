//
//  SignUpModel.swift
//  DrewsList
//
//  Created by Starflyer on 12/6/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
public class SignUpModel {
  
  public let _firstName = Signal<String?>()
  public var firstName: String? { didSet { _firstName => firstName } }
  
  public let _lastName = Signal<String?>()
  public var lastName: String? { didSet { _lastName => lastName } }
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
  public let _email = Signal<String?>()
  public var email: String? { didSet { _email => email } }
  
  public let _password = Signal<String?>()
  public var password: String? { didSet { _password => password } }
  
}