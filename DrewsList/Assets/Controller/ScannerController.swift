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
  
  private let model = ScannerModel()

  public func getBookFromServer(isbn: String?) {
    guard let isbn = isbn where model.shouldRefrainFromCallingServer == false else { return }
    
    // refrain from doing a server call since we are going to do one right now
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, "http://drewslist-staging.herokuapp.com/book/search?query=\(isbn)")
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
    
    NSTimer.after(30.0) { [weak self] in self?.model.shouldRefrainFromCallingServer = false }
  }
  
  // MARK: Getter
  
  public func getModel() -> ScannerModel { return model }
  
  public func get_ShouldHideBorder() -> Signal<Bool> { return model._shouldHideBorder }
  
  public func get_Book() -> Signal<Book?> { return model._book }
}