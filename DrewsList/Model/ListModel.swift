//
//  ListModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class ListModel {
  
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
}