//
//  ViewController.swift
//  Swifty
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 Flowers Designs. All rights reserved.
//

import Foundation
import Alamofire
import Signals
import SwiftyJSON

public class LoginController {
  
  public let model = LoginModel()
  
  private let serverUrl = "http://drewslist-staging.herokuapp.com/user"
  
  public func loginButtonPressed() {
    
    // fixtures
    model.firstName = "Andrew"
    model.lastName = "Aquino"
    model.username = "hello"
    model.email = "mary@jane.com"
    model.password = "@Hello1234"
    
    guard let firstName = model.firstName,
          let lastName = model.lastName,
          let email = model.email,
          let password = model.password
    else { return }
    
    let postObject: [String: AnyObject] = [
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      // note to self take out username
      "username": model.username!
    ]
    
    Alamofire.request(.POST, serverUrl, parameters: postObject, encoding: .JSON)
    .response { req, res, data, error in
      if let error = error {
        // error exists
        log.error(error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
      }
    }
    
  }
  
  public func signupButtonPressed() {
    
  }

  
  public func get_Username() -> Signal<String?> { return model._username }
  public func getUsername() -> String? { return model.username }
  
  public func get_Email() -> Signal<String?> { return model._email }
  public func getEmail() -> String? { return model.email }
  
  public func get_Password() -> Signal<String?> { return model._password }
  public func getPassword() -> String? { return model.password }
  
}