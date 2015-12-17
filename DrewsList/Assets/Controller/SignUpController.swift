//
//  SignUpController.swift
//  DrewsList
//
//  Created by Starflyer on 12/6/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Alamofire
import Signals
import SwiftyJSON

public class SignUpController {
  
  public let model =  SignUpModel()
  
  private let serverURL = "http://drewslist-staging.herokuapp.com/user"
  
  public func signupButtonPressed() {
    

    guard let firstName = model.firstName,
          let lastName = model.lastName,
          let Email = model.email,
          let Password = model.password
    
      else {return}
    
    let postObject: [String: AnyObject] = [
      
      
    "firstName": firstName,
    "lastName": lastName,
    "Email": Email,
    "Password": Password
      
    ]
    
    Alamofire.request(.POST, serverURL, parameters: postObject, encoding: . JSON)
      .response { req, res, data, error in
        if let error = error {
          log.error(error)
          
        }else if let data = data,  let json: JSON! = JSON(data: data) {
          
          
        }
    }
    
    
  }
  
  
  public func NextButtonPressed () {
    
  }

  public func get_firstName() -> Signal<String?> {return model._firstName}
  public func getfirstName() -> String? {return model.firstName}
  
  public func get_lastName() -> Signal<String?> {return model._lastName}
  public func getlastName() -> String? {return model.lastName}
  
  public func get_Email() -> Signal<String?> {return model._email}
  public func getEmail() -> String? {return model.email}
  
  public func get_Password() -> Signal<String?> {return model._password}
  public func getPassword() -> String? {return model.password}
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}