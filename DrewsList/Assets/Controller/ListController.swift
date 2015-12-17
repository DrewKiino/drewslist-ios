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
  
  public func getBookFromServer(book_id: String) {
    Alamofire.request(.GET, serverUrl, parameters: [ "_id": book_id ], encoding: .URL)
    .response { [weak self] req, res, data, error in
      if let error = error {
        
        log.error(error)
        
      } else if let data = data, let json: JSON! = JSON(data: data) {
        let book = Book(json: json)
        
//        self?.model.book = book
     }
    }
  }
  
  public func get_Listing() -> Signal<Listing?> { return model._listing }
  public func getListing() -> Listing? { return model.listing }
  
  public func setListing(listing: Listing) { model.listing = listing }
}