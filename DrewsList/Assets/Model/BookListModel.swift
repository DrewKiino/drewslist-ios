//
//  BookListModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/6/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class BookListModel {
  
  public let _bookList = Signal<[Listing]>()
  public var bookList: [Listing] = [] { didSet { _bookList => bookList } }
  
  public let _selectedBook = Signal<Book?>()
  public var selectedBook: Book? { didSet { _selectedBook => selectedBook } }
  
  public let _selectedListing = Signal<Listing?>()
  public var selectedListing: Listing? { didSet { _selectedListing => selectedListing } }
}