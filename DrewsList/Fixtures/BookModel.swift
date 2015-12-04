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
    
    public let _title = Signal<String?>()
    public var title: String? { didSet { _title => title } }
    
    public let _subtitle = Signal<String?>()
    public var subtitle: String? { didSet { _subtitle => subtitle } }
    
    public let _authors = Signal<String?>()
    public var authors: String? { didSet { _authors => authors } }
    
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
    
    public let _pageCount = Signal<String?>()
    public var pageCount: String? { didSet { _pageCount => pageCount } }
    
    public let _categories = Signal<String?>()
    public var categories: String? { didSet { _categories => categories } }
    
    public let _averageRating = Signal<String?>()
    public var averageRating: String? { didSet { _averageRating => averageRating } }
    
    public let _maturityRating = Signal<String?>()
    public var maturityRating: String? { didSet { _maturityRating => maturityRating } }
    
    public let _language = Signal<String?>()
    public var language: String? { didSet { _language => language } }
    
    public let _listPrice = Signal<String?>()
    public var listPrice: String? { didSet { _listPrice => listPrice } }
    
    public let _retailPrice = Signal<String?>()
    public var retailPrice: String? { didSet { _retailPrice => retailPrice } }
    
    public let _smallImage = Signal<String?>()
    public var smallImage: String? { didSet { _smallImage => smallImage } }
    
    public init() {
        
    }
    
    public init(json: JSON) {
        if let json = json.dictionaryObject {
            mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
        }
    }
    
    public required init?(_ map: Map) {
    
    }
    
    public func mapping(map: Map) {
        _id             <- map["google_id"]
        title           <- map["title"]
        subtitle        <- map["subtitle"]
        authors         <- map["authors"]
        publisher       <- map["publisher"]
        publishedDate   <- map["publishedDate"]
        description     <- map["description"]
        ISBN10          <- map["ISBN10"]
        ISBN13          <- map["ISBN13"]
        pageCount       <- map["pageCount"]
        categories      <- map["categories"]
        averageRating   <- map["averageRating"]
        maturityRating  <- map["maturityRating"]
        language        <- map["language"]
        listPrice       <- map["listPrice.amount"]
        retailPrice     <- map["retailPrice.amount"]
        smallImage      <- map["smallImage"]
        
    }
    
}

public class BookModel {
    
    public let _book = Signal<Book?>()
    public var book: Book? { didSet { _book => book } }
    
}