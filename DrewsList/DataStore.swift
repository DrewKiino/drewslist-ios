//
//  DataStore.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

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
      var array: [[String: Any]] = []
      if let value = snapshot.value as? [String: Any] {
        array = value.flatMap({ key, value -> [String: Any]? in
          if var dict = value as? [String: Any] {
            dict["id"] = key
            return dict
          }
          return nil
        })
      }
      completionHandler(array)
    })
  }
  // https://howtofirebase.com/collection-queries-with-firebase-b95a0193745d
  func get(where key: String, equals value: String, _ completionHandler: @escaping ((_ json: [[String: Any]]) -> ())) {
    databaseReference?
    .queryOrdered(byChild: key)
    .queryEqual(toValue: value)
    .queryLimited(toFirst: 10)
    .observeSingleEvent(of: .value, with: { (snapshot) in
      var array: [[String: Any]] = []
      if let value = snapshot.value as? [String: Any] {
        array = value.flatMap({ key, value -> [String: Any]? in
          if var dict = value as? [String: Any] {
            dict["id"] = key
            return dict
          }
          return nil
        })
      }
      completionHandler(array)
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
  func get(in key: String, where subkey: String, beginsWith value: String, _ completionHandler: @escaping ((_ json: [[String: Any]]) -> ())) {
    databaseReference?
      .queryOrdered(byChild: key + "/" + subkey)
      .queryStarting(atValue: value)
      .queryLimited(toFirst: 5)
      .observeSingleEvent(of: .value, with: { (snapshot) in
        if let value = snapshot.value as? [String: Any] {
          var array = value.flatMap({ key, value -> [String: Any]? in return value as? [String: Any] })
          array.sort(by: { lhs, rhs -> Bool in
            log.debug(rhs)
            return true
          })
          completionHandler(array)
        }
      }, withCancel: { (error) in
        log.error(error)
      })
  }
}

class Model: ModelProtocol, Mappable {
  var datastore: DataStore?
  var id: String? = User.localID
  var model: String!
  init(model: String?, id: String? = nil) {
    self.model = model
    self.id = id ?? self.id
    self.datastore = DataStore(model: self.model, id: self.id)
  }
  required init?(map: Map) {
  }
  func mapping(map: Map) {
    self.id <- map["id"]
  }
  func child(key: String) -> Self {
    datastore?.databaseReference = datastore?.databaseReference?.child(key)
    return self
  }
  func lowercased<T: Model>() -> T? {
    var dict: [String: Any] = [:]
    self.toJSON().forEach({ (key, value) in
      dict[key] = (value as? String)?.lowercased() ?? value
    })
    return T(JSON: dict)
  }
  func alphanumeric<T: Model>() -> T? {
    var dict: [String: Any] = [:]
    self.toJSON().forEach({ (key, value) in
      if var value = value as? String {
        value = value
          .components(separatedBy: CharacterSet.alphanumerics.inverted)
          .flatMap({ $0.isEmpty ? nil : $0 })
          .reduce("", { (f, i) in "\(f) \(i)" })
        return dict[key] = value
      } 
      dict[key] = value
    })
    return T(JSON: dict)
  }
}

protocol ModelProtocol {
  var datastore: DataStore? { get set }
  var id: String? { get set }
  var model: String! { get set }
}

