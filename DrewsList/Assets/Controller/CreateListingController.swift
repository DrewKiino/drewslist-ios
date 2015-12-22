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
  private let model = CreateListingModel()
  private let scannerController = ScannerController()
  
  private var refrainTimer: NSTimer?
  
  private let serverUrl = "http://drewslist-staging.herokuapp.com/book"
  //  private let serverUrl = "http://localhost:1337/book"
  
  // MARK: Initializers
  public init() {
   
    // fixtures
    getBookFromServer("9780547539638")
  }
   
  // MARK: Getters
  public func getModel() -> CreateListingModel { return model }
  
  public func saveListingToServer() {
    Alamofire.request(.POST, "", parameters: ["": ""] as [String: AnyObject], encoding: .JSON)
  }
  
  public func getBookFromServer(isbn: String?) {
    // unwrap isbn and make sure it exists, then make sure there are no prior server calls executed
    guard let isbn = isbn where model.shouldRefrainFromCallingServer == false else { return }
    // set to true to refrain from doing a server call since we are going to do one right now
    model.shouldRefrainFromCallingServer = true
    // make the request following the server's route pattern
    Alamofire.request(.GET, "http://drewslist-staging.herokuapp.com/book/search?query=\(isbn)")
    // then using the builder pattern, chain a 'response' call after
    .response { [weak self] req, res, data, error in
      // unwrap error and check if it exists
      if let error = error {
        log.error(error)
      // use JSON library to jsonify the results ( NSData => JSON )
      // since the results is an array of objects, and we are only interested in the first book,
      // we get the first result
      } else if let data = data, let json = JSON(data: data).array?.first {
        // using ObjectMapper we quickly convert the json data into an actual object we can use
        // then we set the model's book with the new book
        self?.model.book = Book(json: json)
      }
      // set refrain to false since we have finally gotten a response back
      self?.model.shouldRefrainFromCallingServer = false
    }
    // regardless of receiving any responses, if we even got any since server migth be down
    // we resume server calls after 30 seconds of inactivity
    // invalidate  the first timer set from the last call
    // then create a new one
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(30.0) { [weak self] in self?.model.shouldRefrainFromCallingServer = false }
  }

}