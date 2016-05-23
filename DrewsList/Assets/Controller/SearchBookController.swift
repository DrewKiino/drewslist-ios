//
//  SearchBookController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON
import Signals

public class SearchBookController {
  
  public let model = SearchBookModel.sharedInstance()
  
  private var throttleTimer: NSTimer?
  
  public init() {
    model._searchString.removeAllListeners()
    model._searchString.listen(self) { [weak self ] string in
      self?.throttleTimer?.invalidate()
      self?.throttleTimer = NSTimer.after(1.0) { [weak self] in
        self?.searchBook()
      }
    }
  }
  
  public func searchBook() {
    if let queryString = createQueryString(model.searchString) {
      
      log.debug("query string: \(queryString)")
      
      model.showRequestActivity => true
      
      Alamofire.request(.GET, queryString)
      .response { [weak self] req, res, data, error in
        
        if let error = error {
          log.error(error)
        } else if let data = data, let jsonArray: [JSON] = JSON(data: data).array {
          
          log.debug("books found: \(jsonArray.count)")
          
          var books: [Book]? = []
          
          for json in jsonArray { books?.append(Book(json: json)) }
          
          self?.model.books = books!
          
          books = nil
        }
        
        self?.model.showRequestActivity.fire(false)
      }
    }
  }
  
  private func createQueryString(string: String?) -> String? {
    if let string = string where string.characters.count > 0 {
      
      if model.lastSearchString == string { return nil }
      
      model.lastSearchString = string
      
      var queryString = String(string.componentsSeparatedByString(" ").reduce("") { "\($0)+\($1)" }.characters.dropFirst())
      
      if queryString.hasSuffix("+") { queryString = String(queryString.characters.dropLast())         }
      
      return "\(ServerUrl.Default.getValue())/book/search?query=\(queryString)"
    }
    
    model.books.removeAll(keepCapacity: false)
    
    return nil
  }
}