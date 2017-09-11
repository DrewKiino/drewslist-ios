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

class User: Model, Mappable {
  var firstName: String?
  var lastName: String?
  func mapping(map: Map) {
    self.id <- map["id"]
    self.firstName <- map["firstName"]
    self.lastName <- map["lastName"]
  }
  required init?(map: Map) {
    super.init(model: "users")
  }
  init() {
    super.init(model: "users")
    let faker = Faker()
    self.firstName = faker.name.firstName().lowercased()
    self.lastName = faker.name.lastName().lowercased()
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
    //    return UUID().uuidString
    return UIDevice.current.identifierForVendor?.uuidString.description
  }
  static var shared: User = {
    let user = User(id: User.localID)
    return user
  }()
}

extension User {
  class func query(firstName: String) {
    DataStore(model: "users")?
    .get(where: "firstName", beginsWith: "Emma") { dict in
      let users = dict.flatMap({ User(JSON: $0) })
      .sorted(by: { lhs, rhs in (lhs.firstName ?? "") < (rhs.firstName ?? "" ) })
      for user in users {
        log.debug(user.toJSON())
      }
    }
  }
  class func fetch() {
  }
}


























