//
//  DataStore.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import Firebase

class DataStore {
  var databaseReference: DatabaseReference?
  var storageReference: StorageReference?
  fileprivate var model: String?
  fileprivate var id: String?
  fileprivate var limit = 10
  init?(model: String?, id: String? = nil) {
    guard let model = model else { return nil }
    self.model = model
    self.id = id
    self.databaseReference = Database.database().reference().child(model)
    if let id = self.id {
      self.databaseReference = self.databaseReference?.child(id)
    }
    self.storageReference = Storage.storage().reference().child(model)
    if let id = self.id {
      self.storageReference = self.storageReference?.child(id)
    }
  }
  func set(json: [String: Any]?, completionHandler: ((Bool) -> ())? = nil) {
    if let json = json {
      databaseReference?.setValue(json) { (error, ref) in
        if let error = error {
          log.error(error)
        }
        completionHandler?(error == nil)
      }
    }
  }
  func get(_ completionHandler: @escaping ((_ json: [[String: Any]]) -> ())) {
    databaseReference?
    .observeSingleEvent(of: .value, with: { (snapshot) in
      if let value = snapshot.value as? [String: Any] {
        let array = value.flatMap({ key, value -> [String: Any]? in
          if var dict = value as? [String: Any] {
            dict["id"] = key
            return dict
          }
          return nil
        })
        completionHandler(array)
      }
    })
  }
  // https://howtofirebase.com/collection-queries-with-firebase-b95a0193745d
  func get(where key: String, equals value: String, _ completionHandler: @escaping ((_ json: [[String: Any]]) -> ())) {
    databaseReference?
    .queryOrdered(byChild: key)
    .queryEqual(toValue: value)
    .queryLimited(toFirst: 10)
    .observeSingleEvent(of: .value, with: { (snapshot) in
      if let value = snapshot.value as? [String: Any] {
        let array = value.flatMap({ key, value -> [String: Any]? in
          if var dict = value as? [String: Any] {
            dict["id"] = key
            return dict
          }
          return nil
        })
        completionHandler(array)
      }
    })
  }
  func get(where key: String, beginsWith value: String, _ completionHandler: @escaping ((_ json: [[String: Any]]) -> ())) {
    databaseReference?
      .queryOrdered(byChild: key)
      .queryStarting(atValue: value)
      .queryLimited(toFirst: 10)
      .observeSingleEvent(of: .value, with: { (snapshot) in
        if let value = snapshot.value as? [String: Any] {
          let array = value.flatMap({ key, value -> [String: Any]? in
            if var dict = value as? [String: Any] {
              dict["id"] = key
              return dict
            }
            return nil
          })
          completionHandler(array)
        }
      })
  }
}

class Model: ModelProtocol {
  var datastore: DataStore?
  var id: String? = User.localID
  var model: String!
  init(model: String?, id: String? = nil) {
    self.model = model
    self.id = id ?? self.id
    self.datastore = DataStore(model: self.model, id: self.id)
  }
}

protocol ModelProtocol {
  var datastore: DataStore? { get set }
  var id: String? { get set }
  var model: String! { get set }
}

