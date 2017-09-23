//
//  User.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper
import Fakery

class User: Model {
  var contactNumber: String?
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.contactNumber <- map["contactNumber"]
  }
  required init?(map: Map) {
    super.init(model: "users")
  }
  init() {
    super.init(model: "users")
  }
  init(id: String?) {
    super.init(model: "users", id: id)
  }
  func save() {
    datastore?.set(json: self.toJSON())
  }
  func get() {
  }
}

extension User {
  static var localID: String? {
    return UIDevice.current.identifierForVendor?.uuidString.description
  }
  static var shared: User = {
    let user = User(id: User.localID)
    return user
  }()
}



























