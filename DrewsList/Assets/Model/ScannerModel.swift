//
//  ScannerModel.swift
//  ISBN_Scanner_Prototype
//
//  Created by Andrew Aquino on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class ScannerModel {
  
  private struct Singleton {
    private static let scannerModel = ScannerModel()
  }
  
  public class func sharedInstance() -> ScannerModel { return Singleton.scannerModel }
  
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
  
  public let _shouldHideBorder = Signal<Bool>()
  public var shouldHideBorder: Bool = false { didSet { _shouldHideBorder => shouldHideBorder } }
}