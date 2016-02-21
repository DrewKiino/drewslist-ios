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
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _listing = Signal<Listing?>()
  public var listing: Listing? { didSet { _listing => listing } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _serverCallbackFromFindListing = Signal<Bool>()
  public var serverCallbackFromFindListing: Bool = false { didSet { _serverCallbackFromFindListing => serverCallbackFromFindListing } }
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
  
  public let _price = Signal<Double?>()
  public var price: Double? { didSet { _price => price } }
  
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
  
  public func getPriceText() -> String? {
    if let price = price {
      let formatter = NSNumberFormatter()
      formatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
      return formatter.stringFromNumber(price)
    }
    else { return nil }
  }
  
  public func getConditionImage() -> UIImage? {
    guard let condition = condition else { return nil }
    switch condition {
      case "1": return UIImage(named: "Icon-Condition1")
      case "2": return UIImage(named: "Icon-Condition2")
      case "3": return UIImage(named: "Icon-Condition3")
    default: return nil
    }
  }
  
  public func getConditionText() -> String? {
    guard let condition = condition else { return nil }
    let isSelling = getListTypeText() == "Selling" ? true : false
    switch condition {
    case "1": return isSelling ? "\'Really Used\'" : "\'Any Use\'"
    case "2": return isSelling ? "\'Used\'" : "\'Usable\'"
    case "3": return isSelling ? "\'Barely Used\'" : "\'Not Used\'"
    default: return nil
    }
  }
  
  public func getListTypeText() -> String? {
    guard let listType = listType else { return nil }
    switch listType {
    case "buying": return "Buying"
      case "selling": return "Selling"
    default: return nil
    }
  }
  
  public func getListTypeText2() ->  String? {
    guard let listType = listType else { return nil }
    switch listType {
    case "buying": return "Buyer"
    case "selling": return "Seller"
    default: return nil
    }
  }
  
  
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
    _id           <- map["_id"]
    book          <- map["book"]
    user          <- map["user"]
    listType      <- map["listType"]
    price         <- map["price"]
    notes         <- map["notes"]
    cover         <- map["cover"]
    condition     <- map["condition"]
    createdAt     <- map["createdAt"]
    updatedAt     <- map["updatedAt"]
    
    log.debug(price)
    
//    if (user      == nil) { user      <- map["user"] }
//    if (book      == nil) { book      <- map["book"] }
//    if (listType  == _id) { listType  <- map["listType"] }
//    if (price     == _id) { price     <- map["price"] }
//    if (notes     == _id) { notes     <- map["notes"] }
//    if (cover     == _id) { cover     <- map["cover"] }
//    if (condition == _id) { condition <- map["condition"] }
//    if (createdAt == _id) { createdAt <- map["createdAt"] }
//    if (updatedAt == _id) { updatedAt <- map["updatedAt"] }
    
//    highestLister <- map["highestLister"]
  }
}
