//
//  ScannerController.swift
//  ISBN_Scanner_Prototype
//
//  Created by Andrew Aquino on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Signals
import SwiftyTimer
import Alamofire
import SwiftyJSON

public class ScannerController {
  
  public let model = ScannerModel.sharedInstance()
  
  private var throttleTimer: NSTimer?
  
  public init() {
    model._searchString.removeListener(self)
    model._searchString.listen(self) { [weak self ] string in
      self?.throttleTimer?.invalidate()
      self?.throttleTimer = NSTimer.after(1.0) { [weak self] in
        self?.searchBook()
      }
    }
  }
  
  public func getBookFromServer(isbn: String?) {
    guard let isbn = isbn where model.shouldRefrainFromCallingServer == false else { return }
    
    // refrain from doing a server call since we are going to do one right now
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, ServerUrl.Default.getValue()+"/book/search?query=\(isbn)")
    // then using the builder pattern, chain a response call after
    .response { [weak self] req, res, data, error in
      
      // unwrap error and check if it exists
      if let error = error {
        
        log.error(error)
        // use JSON library to jsonify the results ( NSData => JSON )
        // since the results is an array of objects, we get the first name
      } else if let data = data, let json = JSON(data: data).array?.first {
        self?.model.book = Book(json: json)
      }
      
      self?.model.shouldRefrainFromCallingServer = false
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
          
          var books: [Book]! = []
          
          for json in jsonArray { books.append(Book(json: json)) }
          
          self?.model.books = books
          
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
    
    return nil
  }
}