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
  
  public let __id = Signal<String?>()
  public var _id: String? { didSet { __id => _id } }
  
  public let _firstName = Signal<String?>()
  public var firstName: String? { didSet { _firstName => firstName } }
  
  public let _lastName = Signal<String?>()
  public var lastName: String? { didSet { _lastName => lastName } }
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
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
  
  public init() {}
  
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
    image           <- map["image"]
    saleList        <- map["saleList"]
    wishList        <- map["wishList"]
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

public class Listing: Mappable {
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _listing = Signal<Listing?>()
  public var listing: Listing? { didSet { _listing => listing } }
  
  public let _price = Signal<String?>()
  public var price: String? { didSet { _price => price } }
  
  public init() {}
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    // in this case, _id is a book from the server
    // after being populated by mongoose
    book          <- map["_id"]
    user          <- map["user"]
    listing       <- map["listing"]
    price         <- map["price"]
  }
}
