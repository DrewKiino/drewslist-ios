//
//  SignUpModel.swift
//  DrewsList
//
//  Created by Starflyer on 12/6/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals



public class SignUpModel {
  
  public let _isValidForm = Signal<Bool>()
  
  public let _isValidFirstName = Signal<Bool?>()
  public let _firstName = Signal<String?>()
  public var firstName: String? { didSet { _email => email } }
  
  public let _isValidLastName = Signal<Bool?>()
  public let _lastName = Signal<String?>()
  public var lastName: String? { didSet { _email => email } }
  
  public let _isValidEmail  = Signal<Bool?>()
  public let _email = Signal<String?>()
  public var email: String? { didSet { _email => email } }
  
  public let _isValidPassword = Signal<Bool?>()
  public let _password = Signal<String?>()
  public var password: String? { didSet { _password => password } }

  public let _isValidRepassword = Signal<Bool?>()
  public let _repassword = Signal<String?>()
  public var repassword: String? { didSet { _repassword => repassword } }

  public let _isValidSchool = Signal<Bool?>()
  public let _school = Signal<String?>()
  public var school: String? { didSet { _school => school } }
  public let _state = Signal<String?>()
  public var state: String? { didSet { _state => state } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _serverError = Signal<Bool?>()
}