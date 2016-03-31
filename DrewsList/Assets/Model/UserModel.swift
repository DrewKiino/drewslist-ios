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
  
  public let _phone = Signal<Int?>()
  public var phone: Int? { didSet { _phone => phone } }
  
  public let _firstName = Signal<String?>()
  public var firstName: String? { didSet { _firstName => firstName } }
  
  public let _lastName = Signal<String?>()
  public var lastName: String? { didSet { _lastName => lastName } }
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
  public let _school = Signal<String?>()
  public var school: String? { didSet { _school => school } }
  
  public let _state = Signal<String?>()
  public var state: String? { didSet { _state => state } }
  
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
  
  public let _facebook_id = Signal<String?>()
  public var facebook_id: String? { didSet { _facebook_id => facebook_id } }
  
  public let _facebook_verified = Signal<String?>()
  public var facebook_verified: String? { didSet { _facebook_verified => facebook_verified } }
  
  public let _facebook_link = Signal<String?>()
  public var facebook_link: String? { didSet { _facebook_update_time => facebook_update_time } }
  
  public let _facebook_update_time = Signal<String?>()
  public var facebook_update_time: String? { didSet { _facebook_update_time => facebook_update_time } }
  
  public let _facebook_image = Signal<String?>()
  public var facebook_image: String? { didSet { _facebook_image => facebook_image } }
  
  public let _timezone = Signal<String?>()
  public var timezone: String? { didSet { _timezone => timezone } }
 
  public let _gender = Signal<String?>()
  public var gender: String? { didSet { _gender => gender } }
  
  public let _age_min = Signal<String?>()
  public var age_min: String? { didSet { _age_min => age_min } }
  
  public let _age_max = Signal<String?>()
  public var age_max: String? { didSet { _age_max => age_max } }
  
  public let _locale = Signal<String?>()
  public var locale: String? { didSet { _locale => locale } }
  
  // MARK: Permission attributes 
  
  public let _privatePhoneNumber = Signal<Bool>()
  public var privatePhoneNumber: Bool = false { didSet { _privatePhoneNumber => privatePhoneNumber } }
  
  // MARK: User Settings
  
  public let _hasSeenTermsAndPrivacy = Signal<Bool>()
  public var hasSeenTermsAndPrivacy: Bool = false { didSet { _hasSeenTermsAndPrivacy => hasSeenTermsAndPrivacy } }
  
  public let _hasSeenOnboardingView = Signal<Bool>()
  public var hasSeenOnboardingView: Bool = false { didSet { _hasSeenOnboardingView => hasSeenOnboardingView } }
 
  public init() {}
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    _id                     <- map["_id"]
    email                   <- map["email"]
    phone                   <- map["phone"]
    firstName               <- map["firstName"]
    lastName                <- map["lastName"]
    username                <- map["username"]
    school                  <- map["school"]
    imageUrl                <- map["image"]
    bgImage                 <- map["bgImage"]
    description             <- map["description"]
    deviceToken             <- map["deviceToken"]
    listings                <- map["listings"]
    
    // facebookk
    facebook_image          <- map["faceobook_image"]
    
    // user settings
    privatePhoneNumber      <- map["privatePhoneNumber"]
    hasSeenTermsAndPrivacy  <- map["hasSeenTermsAndPrivacy"]
    hasSeenOnboardingView   <- map["hasSeenOnboardingView"]
  }
  
  public func getName() -> String? {
    return username ?? "\(firstName ?? "") \(lastName ?? "")"
  }
  
  public func getPhoneNumberText() -> String? {
    if let phone = phone { return String(phone) }
    else { return nil }
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
  private struct Singleton {
    private static let _user = Signal<User?>()
    private static var user: User? {
      didSet {
        if let user = Singleton.user {
          do {
            let realm = try Realm()
            try realm.write() {
              realm.deleteAll()
              realm.add(RealmUser().setRealmUser(user), update: true)
            }
          } catch {
            log.warning("unable to perform Realm operations")
          }
        } else {
          try! Realm().write { try! Realm().deleteAll() }
        }
        Singleton._user => Singleton.user
      }
    }
    private static func currentUser() -> User? {
      if let user = Singleton.user { return user }
      else if let realmUser = try! Realm().objects(RealmUser.self).first { return realmUser.getUser() }
      else { return nil }
    }
  }
  public class func sharedUser() -> (_user: Signal<User?>, user: User?) { return (Singleton._user, Singleton.currentUser())}
  public class func unsetSharedUser() { try! Realm().write { try! Realm().deleteAll() } }
  public class func setSharedUser(user: User?) { Singleton.user = user }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public static var deviceToken: String?
  public static var hasSeenOnboarding: Bool = false
  public static var hasSeenTermsAndPrivacy: Bool = false
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
