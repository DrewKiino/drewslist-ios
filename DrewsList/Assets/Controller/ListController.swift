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
  
  private var model: ListModel = ListModel()
  private var refrainTimer: NSTimer?
  
  public let serverCallbackFromDeletelIsting = Signal<Bool>()
  
  public init() {}
  
  public func getListingFromServer(list_id: String?) {
    guard let list_id = list_id else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, "\(ServerUrl.Default.getValue())/listing", parameters: [ "_id": list_id ] as [ String: AnyObject ], encoding: .URL)
    .response { [weak self] req, res, data, error in
      if let error = error {
        
        log.error(error)
        
        self?.model.serverCallbackFromFindListing = false
        
      } else if let data = data, let json = JSON(data: data).array?.first {
        
        self?.model.listing = Listing(json: json)

        self?.model.serverCallbackFromFindListing = true
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.refrainTimer = NSTimer.after(3.0) { [weak self] in
        self?.model.shouldRefrainFromCallingServer = false
      }
    }
  }
  
  // MARK: Server Methods
  
  public func deleteListingFromServer() {
    
    // unwrap isbn and make sure it exists, then make sure there are no prior server calls executed
    guard let list_id = model.listing?._id else { return }
    
    // set to true to refrain from doing a server call since we are going to do one right now
    model.shouldRefrainFromCallingServer = true
    
    // make the request following the server's route pattern
    Alamofire.request(.DELETE, "\(ServerUrl.Default.getValue())/listing/\(list_id)")
    // then using the builder pattern, chain a 'response' call after
    .response { [weak self] req, res, data, error in
      
      // unwrap error and check if it exists
      if let error = error {
        log.error(error)
        // use JSON library to jsonify the results ( NSData => JSON )
        // since the results is an array of objects, and we are only interested in the first book,
        // we get the first result
        self?.serverCallbackFromDeletelIsting.fire(false)
        
      } else if let data = data, let json: JSON! = JSON(data: data) {
        // using ObjectMapper we quickly convert the json data into an actual object we can use
        // then we set the model's book with the new book
        self?.serverCallbackFromDeletelIsting.fire(true)
        
      } else {
        self?.serverCallbackFromDeletelIsting.fire(false)
      }
    }
  }
  
  public func setListing(listing: Listing) { model.listing = listing }
  
  public func getModel() -> ListModel { return model }
}