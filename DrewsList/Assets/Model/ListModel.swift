//
//  ListModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import ObjectMapper
import SwiftyJSON

public class ListModel {
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
  
  public let _lister = Signal<User?>()
  public var lister: User? { didSet { _lister => lister } }
}

public class Listing: Mappable {
  
  public let __id = Signal<String?>()
  public var _id: String? { didSet { __id => _id } }
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _listType = Signal<String?>()
  public var listType: String? { didSet { _listType => listType } }
  
  public let _price = Signal<String?>()
  public var price: String? { didSet { _price => price } }
  
  public let _highestLister = Signal<Listing?>()
  public var highestLister: Listing? { didSet { _highestLister => highestLister } }
  
  public let _createdAt = Signal<String?>()
  public var createdAt: String? { didSet { _createdAt => createdAt } }

  public let _updatedAt = Signal<String?>()
  public var updatedAt: String? { didSet { _updatedAt => updatedAt } }
  
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
    book          <- map["_id.book"]
    user          <- map["_id.user"]
    listType      <- map["_id.listType"]
    price         <- map["_id.price"]
    createdAt     <- map["_id.createdAt"]
    updatedAt     <- map["_id.updatedAt"]
    user          <- map["user"]
    price         <- map["price"]
    highestLister <- map["highestLister"]
  }
}
