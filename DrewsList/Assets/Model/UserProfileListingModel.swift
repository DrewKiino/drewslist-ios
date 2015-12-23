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

public class UserProfileListingModel {
  
  public let _bookList = Signal<[Listing]>()
  public var bookList: [Listing] = [] { didSet { _bookList => bookList } }
}