//
//  ViewModel.swift
//  Swifty
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 Flowers Designs. All rights reserved.
//

import Foundation
import UIKit
import Signals


public class LoginModel {
  
  public let _isValidEmail  = Signal<Bool?>()
  public let _email = Signal<String?>()
  public var email: String? { didSet { _email => email } }
  
  public let _isValidPassword = Signal<Bool?>()
  public let _password = Signal<String?>()
  public var password: String? { didSet { _password => password } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _serverError = Signal<Bool?>()
  
}