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
import RealmSwift

public class CreateListingController {
    
  // MARK: Properties
  private let model = CreateListingModel()
  private let scannerController = ScannerController()
  
  private var refrainTimer: NSTimer?
  
  // MARK: Initializers
  public init() {
    readRealmUser()
    setDefaultListing()
    // fixtures
//    getBookFromServer("9780547539638")
  }
  
  public func setDefaultListing() {
    // create default listing in case user has not changed any inputs
    model.listing?.listType = "buying"
    model.listing?.cover = "hardcover"
    model.listing?.condition = "2"
    model.listing?.price = "1.00"
    model.listing?.notes = ""
  }
  
  // MARK: Getters
  public func getModel() -> CreateListingModel { return model }
  
  // MARK: Realm Functions
  
  public func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
  
  // MARK: Server Methods
  
  public func uploadListingToServer() {
    // unwrap isbn and make sure it exists, then make sure there are no prior server calls executed
    guard let user_id = model.user?._id,
          let book_id = model.book?._id,
          let price = model.listing?.price,
          let listType = model.listing?.listType,
          let condition = model.listing?.condition,
          let cover = model.listing?.cover,
          let notes = model.listing?.notes
          where model.shouldRefrainFromCallingServer == false else
    { return }
    // set to true to refrain from doing a server call since we are going to do one right now
    model.shouldRefrainFromCallingServer = true
    // make the request following the server's route pattern
    Alamofire.request(
      .POST,
      "\(ServerUrl.Local.getValue())/user/listBook",
      parameters: [
        "user_id": user_id,
        "book_id": book_id,
        "price": Float(price) ?? 1.00,
        "listType": listType,
        "condition": Int(condition) ?? 2,
        "cover": cover,
        "notes": notes
      ] as [String: AnyObject],
      encoding: .JSON
    )
    // then using the builder pattern, chain a 'response' call after
    .response { [weak self] req, res, data, error in
      // unwrap error and check if it exists
      if let error = error {
        log.error(error)
        // use JSON library to jsonify the results ( NSData => JSON )
        // since the results is an array of objects, and we are only interested in the first book,
        // we get the first result
        self?.model.serverCallbackFromUploadlIsting = false
        
      } else if let data = data, let json: JSON! = JSON(data: data) {
        log.debug(json)
        // using ObjectMapper we quickly convert the json data into an actual object we can use
        // then we set the model's book with the new book
        self?.model.serverCallbackFromUploadlIsting = true
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