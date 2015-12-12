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
  
  
  public let _bookList = Signal<[Book]>()
  public var bookList: [Book] = [] { didSet { _bookList => bookList } }
  
}