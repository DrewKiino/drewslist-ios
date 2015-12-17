//
//  BookListController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/6/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class BookListController {
  
  public let model = BookListModel()
  
  public func get_selectedBook() -> Signal<Book?> { return model._selectedBook }
  public func get_selectedListing() -> Signal<Listing?> { return model._selectedListing }
}
