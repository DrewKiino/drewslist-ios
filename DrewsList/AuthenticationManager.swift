//
//  AuthenticationManager.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import FirebaseAuth

public class AuthenticationManager {
  
  private static let auth = FIRAuth.auth()
  
  public static var currentUser: FIRUser?
  
  public class func signUp(email: String, password: String, completion: FIRAuthResultCallback) {
    auth?.createUserWithEmail(email, password: password) { user, error in
      AuthenticationManager.currentUser = user
      completion(user, error)
    }
  }
  
  public class func signIn(email: String, password: String, completion: FIRAuthResultCallback) {
    auth?.signInWithEmail(email, password: password) { user, error in
      AuthenticationManager.currentUser = user
      completion(user, error)
    }
  }

  public class func signInAnonymously(completion: FIRAuthResultCallback) {
    auth?.signInAnonymouslyWithCompletion() { user, error in
      AuthenticationManager.currentUser = user
      completion(user, error)
    }
  }
}