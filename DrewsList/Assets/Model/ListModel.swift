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
  
  public let _listing = Signal<Listing?>()
  public var listing: Listing? { didSet { _listing => listing } }
  
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
  
  public let _notes = Signal<String?>()
  public var notes: String? { didSet { _notes => notes } }
  
  public let _cover = Signal<String?>()
  public var cover: String? { didSet { _cover => cover } }
  
  public let _condition = Signal<String?>()
  public var condition: String? { didSet { _condition => condition } }
  
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
    _id           <- map["_id._id"]
    book          <- map["_id.book"]
    user          <- map["_id.user"]
    listType      <- map["_id.listType"]
    price         <- map["_id.price"]
    notes         <- map["_id.notes"]
    cover         <- map["_id.cover"]
    condition     <- map["_id.condition"]
    createdAt     <- map["_id.createdAt"]
    updatedAt     <- map["_id.updatedAt"]
    
    if (user      == nil) { user      <- map["user"] }
    if (price     == _id) { price     <- map["price"] }
    if (notes     == _id) { notes     <- map["notes"] }
    if (cover     == _id) { cover     <- map["cover"] }
    if (condition == _id) { condition <- map["condition"] }
    if (createdAt == _id) { createdAt <- map["createdAt"] }
    if (updatedAt == _id) { updatedAt <- map["updatedAt"] }
    
    highestLister <- map["highestLister"]
  }
}
