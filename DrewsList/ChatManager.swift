//
//  MessageManager.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import Firebase
import FirebaseStorage
import Signals

public class ChatManager {
  
  private static let manager = ChatManager()
  public class func sharedInstance() -> ChatManager { return manager }
  
  public static let dbRef = FIRDatabase.database().reference()
  
  public static var listeners: [String: [String: AnyObject]] = Dictionary<String,[String:AnyObject]>()
  
  public class func publish(user_id: String? = nil, dictionary: [String: AnyObject]?, completionHandler: ((error: NSError?) -> Void)? = nil) {
    if let dictionary = dictionary, user_id = user_id ?? AuthenticationManager.currentUser?.uid {
      let parameters: [String: AnyObject] = dictionary
      dbRef.child("users").child(user_id).updateChildValues(parameters) { error, reference in
        completionHandler?(error: error)
      }
    }
  }
  
  public class func removeListener(user_id: String? = nil) {
    if let user_id = user_id ?? AuthenticationManager.currentUser?.uid {
      listeners.removeValueForKey(user_id)
    }
  }
  
  public class func fetch(user_id: String? = nil, limit: UInt = 10, skip: Int = 0, invertSort: Bool = false, completionHandler: (messages: [ChatView.Models.Message]) -> Void) {
    if let user_id = user_id ?? AuthenticationManager.currentUser?.uid {
      let dbRef = ChatManager.dbRef.child("users").child(user_id).child("messages")
      dbRef.observeSingleEventOfType(.Value, withBlock: { [weak dbRef] snapshot in
        let messageCount = Int(snapshot.childrenCount)
        let index = messageCount - skip - Int(limit)
        let limit = index < 0 ? UInt(Int(limit) + index) : limit
        if limit == 0 { return completionHandler(messages: []) } // we have reached the end of the message history
        let startingIndex = max(index, 0).description
        dbRef?.queryOrderedByKey().queryStartingAtValue(startingIndex).queryLimitedToFirst(limit).observeSingleEventOfType(.Value, withBlock: { snapshot in
          let messages = snapshot.toDictionary().flatMap({ key, value -> ChatView.Models.Message? in
            if let
              item = value as? [String: AnyObject],
              text = item["text"] as? String,
              username = item["username"] as? String,
              userImageUrl = item["userImageUrl"] as? String,
              timestamp = item["timestamp"] as? String,
              message_id = item["message_id"] as? String
            {
              let message = ChatView.Models.Message(text: text, username: username, userImageUrl: userImageUrl, timestamp: timestamp, message_id: message_id)
              return message
            } else {
              return nil
            }
          }).sort({ item1, item2 -> Bool in
            if let id1 = item1.message_id?.toInt(), id2 = item2.message_id?.toInt() {
              return invertSort ? id1 > id2 : id1 < id2
            } else {
              return false
            }
          })
          completionHandler(messages: messages)
        })
      })
    }
  }
  
  public class func appendMessage(user_id: String? = nil, index: Int, message: [String: AnyObject]) {
    if let user_id = user_id ?? AuthenticationManager.currentUser?.uid {
      let dbRef = ChatManager.dbRef.child("users").child(user_id).child("messages")
      dbRef.observeSingleEventOfType(.Value, withBlock: { [weak dbRef] snapshot in
        let messageCount = Int(snapshot.childrenCount)
        var dictionary = message
        dictionary["message_id"] = messageCount.description
        dbRef?.child(messageCount.description).updateChildValues(dictionary) { error, reference in
        }
      })
    }
  }
}
















