//
//  SignUpController.swift
//  DrewsList
//
//  Created by Starflyer on 12/6/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals
import RealmSwift
import Alamofire
import SwiftyJSON

public class SignUpController {
  
  public let userController = UserController()
  public let model =  SignUpModel()
  private var refrainTimer: NSTimer?

  
  public init() {}
  
  public func viewDidAppear() {
    model.school = SearchSchoolController.currentSelection()?.name
    model.state = SearchSchoolController.currentSelection()?.state
  }
  
  public func validateInputs() {
    
    let validFirstName = model.firstName?.isValidName()
    let validLastName = model.lastName?.isValidName()
    let validEmail = model.email?.isValidEmail()
    let validPhone = model.phone?.isValidPhoneNumber()
    let validPassword = model.password?.isValidPassword()
    let validRepassword = model.password != nil && model.repassword != nil && model.password! == model.repassword && model.repassword?.isValidPassword() == true
    let validSchool = model.school != nil && !model.school!.isEmpty && model.state != nil && !model.state!.isEmpty
    
    model._isValidFirstName.fire(validFirstName)
    model._isValidLastName.fire(validLastName)
    model._isValidEmail.fire(validEmail)
    model._isValidPhone.fire(validPhone)
    model._isValidPassword.fire(validPassword)
    model._isValidRepassword.fire(validRepassword)
    model._isValidSchool.fire(validSchool)
    
    model._isValidForm.fire(
      validFirstName == true &&
      validLastName == true &&
      validEmail == true &&
      validPhone == true &&
      validPassword == true &&
      validRepassword == true &&
      validSchool == true
    )
  }
  
  public func createNewUserInServer() {
    guard let firstName = model.firstName,
          let lastName = model.lastName,
          let email = model.email,
          let phone = model.phone,
          let password = model.password,
          let school = model.school,
          let state = model.state else
    { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    /*
    firstName,
    lastName,
    username,
    email,
    password,
    image,
    bgImage,
    description,
    */
    
    Alamofire.request(
      .POST,
      ServerUrl.Default.getValue() + "/user",
      parameters: [
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
        "password": password,
        "school": school,
        "state": state,
        "deviceToken": userController.readUserDefaults()?.deviceToken ?? ""
      ] as [String: AnyObject],
      encoding: .JSON
    )
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        
        log.error(error)
        self?.model._serverError.fire(true)
        
      } else if let data = data, let json: JSON! = JSON(data: data) {
        
        if json["errmsg"].string != nil || json["error"].string != nil {
          
          log.error(json)
          
//          self?.model._serverError.fire(true)
          
        } else {
          
          // create and  user object
          self?.model.user = User(json: json)
          // write user object to realm
          self?.overwriteRealmUser()
        }
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.model.shouldRefrainFromCallingServer = false
    }
    
    // create a throttler
    // this will disable this controllers server calls for 10 seconds
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      self?.model.shouldRefrainFromCallingServer = false
    }
  }
  
  // MARK: Realm Functions
  public func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  // this one deletes all prior users
  // we should only have one user in database, and that should be the current user
  public func overwriteRealmUser(){ try! Realm().write { try! Realm().deleteAll(); try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}