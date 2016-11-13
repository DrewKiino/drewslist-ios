//
//  FirebaseManager.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import Signals

public class FireBaseManager {
  
  public static let updateMapData = Signal<()>()
  
  private static let manager = FireBaseManager()
  public class func sharedInstance() -> FireBaseManager { return manager }
  
  public static let dbRef = FIRDatabase.database().reference()
  
  public static var listeners: [String: [String: AnyObject]] = Dictionary<String,[String:AnyObject]>()
  
  // MARK: CRUD
  public class func publish(user_id: String?, dictionary: [String: AnyObject]?, completionHandler: ((error: NSError?) -> Void)? = nil) {
    if let dictionary = dictionary, user_id = user_id ?? AuthenticationManager.currentUser?.uid {
      let parameters: [String: AnyObject] = dictionary
      dbRef.child("users").child(user_id).updateChildValues(parameters) { error, reference in
        completionHandler?(error: error)
      }
    }
  }
  
  public class func removeListener(user_id: String?) {
    if let user_id = user_id ?? AuthenticationManager.currentUser?.uid {
      listeners.removeValueForKey(user_id)
    }
  }
  
  public class func listen(user_id: String?, completionHandler: (dictionary: [String: AnyObject]) -> Void) {
    if let user_id = user_id ?? AuthenticationManager.currentUser?.uid where listeners[user_id] == nil {
      // initialize the listener
      listeners[user_id] = [:]
      // begin listeing
      dbRef.child("users").child(user_id).observeEventType(.Value, withBlock: { snapshot in
        var dictionary: [String: AnyObject] = [:]
        snapshot.children.allObjects.forEach { object in
          if let object = object as? FIRDataSnapshot {
            
            // strings
            if let value = object.value as? String { dictionary.updateValue(value, forKey: object.key) }
            else  if let value = object.value as? [String] { dictionary.updateValue(value, forKey: object.key) }
              
              // numbers
            else if let value = object.value as? Int { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? [Int] { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? Float { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? [Float] { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? Double { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? [Double] { dictionary.updateValue(value, forKey: object.key) }
              
              // booleans
            else if let value = object.value as? Bool { dictionary.updateValue(value, forKey: object.key) }
              
              // dictionaries
            else if let value = object.value as? [String: AnyObject] { dictionary.updateValue(value, forKey: object.key) }
          }
        }
        
        // save listener
        FireBaseManager.listeners.updateValue(dictionary, forKey: user_id)
        
        completionHandler(dictionary: dictionary)
      })
    }
  }
  
  public class func listenOnce(user_id: String?, completionHandler: (dictionary: [String: AnyObject]) -> Void) {
    if let user_id = user_id ?? AuthenticationManager.currentUser?.uid {
      dbRef.child("users").child(user_id).observeSingleEventOfType(.Value, withBlock: { snapshot in
        var dictionary: [String: AnyObject] = [:]
        snapshot.children.allObjects.forEach { object in
          if let object = object as? FIRDataSnapshot {
            
            // strings
            if let value = object.value as? String { dictionary.updateValue(value, forKey: object.key) }
            else  if let value = object.value as? [String] { dictionary.updateValue(value, forKey: object.key) }
              
              // numbers
            else if let value = object.value as? Int { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? [Int] { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? Float { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? [Float] { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? Double { dictionary.updateValue(value, forKey: object.key) }
            else if let value = object.value as? [Double] { dictionary.updateValue(value, forKey: object.key) }
              
              // booleans
            else if let value = object.value as? Bool { dictionary.updateValue(value, forKey: object.key) }
              
              // dictionaries
            else if let value = object.value as? [String: AnyObject] { dictionary.updateValue(value, forKey: object.key) }
          }
        }
        completionHandler(dictionary: dictionary)
      })
    }
  }
}