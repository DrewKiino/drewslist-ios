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
import RealmSwift

public class User: Mappable {
  
  public let __id = Signal<String?>()
  public var _id: String? { didSet { __id => _id } }
  
  public let _email = Signal<String?>()
  public var email: String? { didSet { _email => email } }
  
  public let _firstName = Signal<String?>()
  public var firstName: String? { didSet { _firstName => firstName } }
  
  public let _lastName = Signal<String?>()
  public var lastName: String? { didSet { _lastName => lastName } }
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
  public let _school = Signal<String?>()
  public var school: String? { didSet { _school => school } }
  
  public let _image = Signal<String?>()
  public var image: String? { didSet { _image => image } }
  
  public let _bgImage = Signal<String?>()
  public var bgImage : String? { didSet { _bgImage => bgImage } }

  public let _deviceToken = Signal<String?>()
  public var deviceToken: String? { didSet { _deviceToken => deviceToken } }
  
  public let _saleList = Signal<[Listing]>()
  public var saleList: [Listing] = [] { didSet { _saleList => saleList } }
  
  public let _wishList = Signal<[Listing]>()
  public var wishList: [Listing] = [] { didSet { _wishList => wishList } }
  
  public let _listings = Signal<[Listing]>()
  public var listings: [Listing] = [] { didSet { _wishList => wishList } }
 
  public init() {}
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    _id             <- map["_id"]
    email           <- map["email"]
    firstName       <- map["firstName"]
    lastName        <- map["lastName"]
    school          <- map["school"]
    username        <- map["username"]
    deviceToken     <- map["deviceToken"]
    image           <- map["image"]
    listings        <- map["listings"]
  }
  
  public func getName() -> String? {
    guard let firstName = firstName, let lastName = lastName else { return nil }
    return "\(firstName) \(lastName)"
  }
}

public class UserModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
}

public class RealmUser: Object {
  
  dynamic var _id: String?
  dynamic var email: String?
  dynamic var firstName: String?  
  dynamic var lastName: String?
  dynamic var username: String?
  dynamic var school: String?
  dynamic var image: String?
  
  public override static func primaryKey() -> String? {
    return "_id"
  }
  
  public func setRealmUser(user: User?) -> Self {
    guard let user = user else { return self }
    _id = user._id
    email = user.email
    firstName = user.firstName
    lastName = user.lastName
    username = user.username
    school = user.school
    image = user.image
    return self
  }
  
  public func getUser() -> User {
    let user = User()
    user._id = _id
    user.email = email
    user.firstName = firstName
    user.lastName = lastName
    user.username = username
    user.school = school
    user.image = image
    return user
  }
  
}
