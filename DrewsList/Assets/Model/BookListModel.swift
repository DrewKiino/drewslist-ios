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
  
  public let _selectedLister = Signal<(User?, Book?)>()
  public var selectedLister: (User?, Book?) { didSet { _selectedBook => selectedBook } }
}