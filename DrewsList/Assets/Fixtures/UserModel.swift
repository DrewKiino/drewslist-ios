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
import Async

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
  
  public let _imageUrl = Signal<String?>()
  public var imageUrl: String? { didSet { _imageUrl => imageUrl } }
  
  public let _image = Signal<UIImage?>()
  public var image: UIImage? { didSet { _image => image } }
  
  public let _bgImage = Signal<String?>()
  public var bgImage : String? { didSet { _bgImage => bgImage } }
  
  public let _description = Signal<String?>()
  public var description: String? { didSet { _description => description } }

  public let _deviceToken = Signal<String?>()
  public var deviceToken: String? { didSet { _deviceToken => deviceToken } }
  
  public let _saleList = Signal<[Listing]>()
  public var saleList: [Listing] = [] { didSet { _saleList => saleList } }
  
  public let _wishList = Signal<[Listing]>()
  public var wishList: [Listing] = [] { didSet { _wishList => wishList } }
  
  public let _listings = Signal<[Listing]>()
  public var listings: [Listing] = [] { didSet { _wishList => wishList } }
  
  // MARK: Facebook user attributes
 
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
    username        <- map["username"]
    school          <- map["school"]
    imageUrl        <- map["image"]
    bgImage         <- map["bgImage"]
    description     <- map["description"]
    deviceToken     <- map["deviceToken"]
    listings        <- map["listings"]
  }
  
  public func getName() -> String? {
    return username ?? "\(firstName ?? "") \(lastName ?? "")"
  }
  
  public func set(deviceToken deviceToken: String?) -> Self {
    self.deviceToken = deviceToken
    return self
  }
  
  public func set(_id _id: String?) -> Self {
    self._id = _id
    return self
  }
  
  public func set(username username: String?) -> Self {
    self.username = username
    return self
  }
  
  public func set(firstName firstName: String?, lastName: String?) -> Self {
    self.firstName = firstName
    self.lastName = lastName
    return self
  }
  
  public func set(imageUrl imageUrl: String?) -> Self {
    self.imageUrl = imageUrl
    return self
  }
}

public class UserModel {
  
  // a singleton class of a user
  // this class is reserved for the main User that is logged in for
  // all other controllers to access
  private struct Singleton { private static let _user = Signal<User?>(); private static var user: User? { didSet { Singleton._user => Singleton.user } } }
  public class func sharedUser() -> (_user: Signal<User?>, user: User?) { return (Singleton._user, Singleton.user) }
  public class func setSharedUser(user: User?) { if let user = user { Singleton.user = user } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
}


public class UserDefaults: Object {
  
  dynamic var _id: String?
  
  // onboarding
  dynamic var didShowOnboarding: Bool = false
  
  // school selection
  dynamic var school: String?
  dynamic var state: String?
  
  // device token
  dynamic var deviceToken: String?
  
  public override static func primaryKey() -> String? {
    return "_id"
  }
}

public class RealmUser: Object {
  
  dynamic var _id: String?
  dynamic var email: String?
  dynamic var firstName: String?  
  dynamic var lastName: String?
  dynamic var username: String?
  dynamic var school: String?
  dynamic var imageUrl: String?
  dynamic var deviceToken: String?
  
  dynamic var image: NSData?
  
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
    imageUrl = user.imageUrl
    deviceToken = user.deviceToken
    
    if let image = user.image { self.image = UIImagePNGRepresentation(image) }
    
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
    user.imageUrl = imageUrl
    user.deviceToken = deviceToken
    
    if let data = image { user.image = UIImage(data: data) }
    
    return user
  }
}
