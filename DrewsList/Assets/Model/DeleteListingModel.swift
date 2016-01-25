//
//  DeleteListingModel.swift
//  DrewsList
//
//  Created by Starflyer on 1/17/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals


public class DeleteListingModel {
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet {_book => book } }
  
  public let _listing = Signal<Listing?>()
  public var listing: Listing? { didSet { _listing => listing } }

  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  

  
}
