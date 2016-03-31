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

public class ScannerController: NSObject {
  
  public let model = ScannerModel.sharedInstance()
  
  private var refrainTimer: NSTimer?
  private var throttleTimer: NSTimer?
  
  public override convenience init() {
    self.init()
    model._searchString.removeAllListeners()
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
      
      log.debug(req?.URLString)
      
      
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
    
    NSTimer.after(30.0) { [weak self] in self?.model.shouldRefrainFromCallingServer = false }
  }
  
  public func searchBook() {
    guard let queryString = createQueryString(model.searchString) where !model.shouldRefrainFromCallingServer else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, queryString)
      .response { [weak self] req, res, data, error in
        
        if let error = error {
          log.error(error)
        } else if let data = data, let jsonArray: [JSON] = JSON(data: data).array {
          
          var books: [Book]? = []
          
          for json in jsonArray { books?.append(Book(json: json)) }
          
          self?.model.books.removeAll(keepCapacity: false)
          self?.model.books = books!
          
          books = nil
        }
        
        // create a throttler
        // this will disable this controllers server calls for 10 seconds
        self?.refrainTimer?.invalidate()
        self?.refrainTimer = nil
        self?.refrainTimer = NSTimer.after(0.2) { [weak self] in
          self?.model.shouldRefrainFromCallingServer = false
        }
    }
    
    // create a throttler
    // this will disable this controllers server calls for 10 seconds
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      self?.model.shouldRefrainFromCallingServer = false
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