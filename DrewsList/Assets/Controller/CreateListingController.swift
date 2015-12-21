//
//  CreateListingController.swift
//  DrewsList
//
//  Created by Steven Yang on 11/29/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Signals

public class CreateListingController {
    
  // MARK: Properties
  private var isbn: String?
  private let model = CreateListingModel()
  private let scannerController = ScannerController()
  
  // MARK: Initializers
  public init() {}
   
  // MARK: Getters
  public func getISBN() -> String? { return isbn }
  
  public func getModel() -> CreateListingModel { return model }
}