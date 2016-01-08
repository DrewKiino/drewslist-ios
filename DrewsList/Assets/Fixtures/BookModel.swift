//
//  BookModel.swift
//  DrewsList
//
//  Created by Steven Yang on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import ObjectMapper
import SwiftyJSON

public class Book: Mappable {
    
  public let __id = Signal<String?>()
  public var _id: String? { didSet { __id => _id } }
  
  public let _google_id = Signal<String?>()
  public var google_id: String? { didSet { _google_id => google_id } }
  
  public let _title = Signal<String?>()
  public var title: String? { didSet { _title => title } }
  
  public let _subtitle = Signal<String?>()
  public var subtitle: String? { didSet { _subtitle => subtitle } }
  
  public let _authors = Signal<[Author]>()
  public var authors: [Author] = [] { didSet { _authors => authors } }
  
  public let _publisher = Signal<String?>()
  public var publisher: String? { didSet { _publisher => publisher } }
  
  public let _publishedDate = Signal<String?>()
  public var publishedDate: String? { didSet { _publishedDate => publishedDate } }
  
  public let _description = Signal<String?>()
  public var description: String? { didSet { _description => description } }
  
  public let _ISBN10 = Signal<String?>()
  public var ISBN10: String? { didSet { _ISBN10 => ISBN10 } }
  
  public let _ISBN13 = Signal<String?>()
  public var ISBN13: String? { didSet { _ISBN13 => ISBN13 } }
  
  public let _pageCount = Signal<Int?>()
  public var pageCount: Int? { didSet { _pageCount => pageCount } }
  
  public let _categories = Signal<String?>()
  public var categories: String? { didSet { _categories => categories } }
  
  public let _averageRating = Signal<Double?>()
  public var averageRating: Double? { didSet { _averageRating => averageRating } }
  
  public let _maturityRating = Signal<String?>()
  public var maturityRating: String? { didSet { _maturityRating => maturityRating } }
  
  public let _language = Signal<String?>()
  public var language: String? { didSet { _language => language } }
  
  public let _edition = Signal<String?>()
  public var edition: String? { didSet { _edition => edition } }
  
  public let _listPrice = Signal<String?>()
  public var listPrice: String? { didSet { _listPrice => listPrice } }
  
  public let _retailPrice = Signal<String?>()
  public var retailPrice: String? { didSet { _retailPrice => retailPrice } }
  
  public let _smallImage = Signal<String?>()
  public var smallImage: String? { didSet { _smallImage => smallImage } }
  
  public let _mediumImage = Signal<String?>()
  public var mediumImage: String? { didSet { _mediumImage => mediumImage } }
  
  public let _largeImage = Signal<String?>()
  public var largeImage: String? { didSet { _largeImage => largeImage } }

  // buyer
  public let _bestBuyer = Signal<User?>()
  public var bestBuyer: User? { didSet { _bestBuyer => bestBuyer } }
  
  public let _bestBuyerListing = Signal<String?>()
  public var bestBuyerListing: String? { didSet { _bestBuyerListing => bestBuyerListing } }
  
  // seller
  public let _bestSeller = Signal<User?>()
  public var bestSeller: User? { didSet { _bestSeller => bestSeller } }
  
  public let _bestSellerListing = Signal<String?>()
  public var bestSellerListing: String? { didSet { _bestSellerListing => bestSellerListing } }
  
  
  public init() {}
  
  public init(_id: String?) { self._id = _id }
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    _id             <- map["_id"]
    google_id       <- map["google_id"]
    title           <- map["title"]
    subtitle        <- map["subtitle"]
    authors         <- map["authors"]
    publisher       <- map["publisher"]
    publishedDate   <- map["publishedDate"]
    description     <- map["description"]
    edition         <- map["edition"]
    ISBN10          <- map["ISBN_10"]
    ISBN13          <- map["ISBN_13"]
    pageCount       <- map["pageCount"]
    categories      <- map["categories"]
    averageRating   <- map["averageRating"]
    maturityRating  <- map["maturityRating"]
    language        <- map["language"]
    listPrice       <- map["listPrice.amount"]
    retailPrice     <- map["retailPrice.amount"]
    smallImage      <- map["smallImage"]
    mediumImage     <- map["mediumImage"]
    largeImage      <- map["largeImage"]
  }
  
  public func hasImageUrl() -> Bool {
    return (largeImage ?? mediumImage ?? smallImage ?? nil) != nil ?  true : false
  }
  
  public func getImageUrl() -> String? {
    return largeImage ?? mediumImage ?? smallImage ?? nil
  }
}

public class Author: Mappable {
  
  public let _name = Signal<String?>()
  public var name: String? { didSet { _name => name } }
  
  public init(name: String) { self.name = name }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    name            <- map["name"]
  }
}

public class BookModel {
    
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
  
}