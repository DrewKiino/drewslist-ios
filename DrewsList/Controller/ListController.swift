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
  
  public func get_Book() -> Signal<Book?> { return model._book }
  
  public func getBook() -> Book? { return model.book }
  
  public init() {
    getBookFromServer("566e4e0595fef95c3c21a431")
  }
  
  public func getBookFromServer(book_id: String) {
    Alamofire.request(.GET, serverUrl, parameters: [ "_id": book_id ], encoding: .URL)
    .response { req, res, data, error in
      if let data = data, let json: JSON! = JSON(data: data) {
        let book = Book(json: json)
        log.debug(book.authors.first?.name)
      }
    }
  }
}