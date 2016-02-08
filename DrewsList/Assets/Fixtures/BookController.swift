//
//  BookController.swift
//  DrewsList
//
//  Created by Steven Yang on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class BookController {
    
  public let model = BookModel()
  
  public func get_Book() -> Signal<Book?> { return model._book }
  
  public func getBook() -> Book? { return model.book }
}
