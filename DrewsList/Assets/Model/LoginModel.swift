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
  
  public let _phone = Signal<String?>()
  public var phone: String? { didSet { _phone => phone } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _friends = Signal<[User]>()
  public var friends: [User] = [] { didSet { _friends => friends } }
  
  public let _serverError = Signal<Bool?>()
  
  public let _shouldLogout = Signal<Bool>()
  public var shouldLogout: Bool = false { didSet { _shouldLogout => shouldLogout } }
  
  public var isCurrentlyAuthenticatingUserWithFacebook: Bool = false
}