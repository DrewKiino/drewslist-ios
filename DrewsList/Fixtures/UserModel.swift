//
//  UserModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import ObjectMapper
import SwiftyJSON

public class User: Mappable {
  
  public let _firstName = Signal<String?>()
  public var firstName: String? { didSet { _firstName => firstName } }
  
  public let _lastName = Signal<String?>()
  public var lastName: String? { didSet { _lastName => lastName } }
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
  public let __id = Signal<String?>()
  public var _id: String? { didSet { __id => _id } }
  
  public let _deviceToken = Signal<String?>()
  public var deviceToken: String? { didSet { _deviceToken => deviceToken } }
  
  public init() {}
  
  public init(_id: String, firstName: String, lastName: String, username: String) {
    self.username
    self.firstName = firstName
    self.lastName = lastName
    self.username = username
  }
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    firstName       <- map["firstName"]
    lastName        <- map["lastName"]
    username        <- map["username"]
    _id             <- map["_id"]
    deviceToken     <- map["deviceToken"]
  }
}

public class UserModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
}
