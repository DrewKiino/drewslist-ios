//
//  ListController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import Alamofire
import SwiftyJSON

public class ListController {
  
  private let model = ListModel()
//  private let serverUrl = "http://drewslist-staging.herokuapp.com/book"
  private let serverUrl = "http://localhost:1337/book"
  
  public init() {}
  
  public func get_Listing() -> Signal<Listing?> { return model._listing }
  public func getListing() -> Listing? { return model.listing }
  
  public func setListing(listing: Listing) { model.listing = listing }
}