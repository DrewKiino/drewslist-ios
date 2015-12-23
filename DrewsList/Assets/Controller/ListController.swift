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
  private var refrainTimer: NSTimer?
  private let serverUrl = "http://drewslist-staging.herokuapp.com/listing"
  //  private let serverUrl = "http://localhost:1337/listing"
  
  public init() {}
  
  public func getListingFromServer(list_id: String?) {
    guard let list_id = list_id else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, serverUrl, parameters: [ "_id": list_id], encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        
        log.error(error)
        
        self?.model.serverCallbackFromFindListing = false
        
      } else if let data = data, let json: JSON! = JSON(data: data).array?.first {
        
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
  
  public func setListing(listing: Listing) { model.listing = listing }
  
  public func getModel() -> ListModel { return model }
}