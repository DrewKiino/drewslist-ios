//
//  SearchBookModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class SearchBookModel {
  
  private struct Singleton {
    private static let searchBookModel = SearchBookModel()
  }
  
  public class func sharedInstance() -> SearchBookModel { return Singleton.searchBookModel }
  
  public var showRequestActivity = Signal<Bool>()
  
  public let _searchString = Signal<String?>()
  public var searchString: String? { didSet { _searchString => searchString } }
  
  public var lastSearchString: String? 
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _books = Signal<[Book]>()
  public var books: [Book] = [] { didSet { _books => books } }
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
}