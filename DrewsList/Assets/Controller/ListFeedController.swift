//
//  ListFeedContrloler.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class ListFeedController {
  
  private let model = ListFeedModel()
  
  private var refrainTimer: NSTimer?
  
//  private let serverUrl = "http://drewslist-staging.herokuapp.com/listing"
  private let serverUrl = "http://localhost:1337/listing"
  
  public init() {
    getListingsFromServer(0)
  }
  
  public func getModel() -> ListFeedModel { return model }
  
  public func getListingsFromServer(skip: Int? = nil) {
    
    // lock the view
    model.shouldLockView = true
    
    Alamofire.request(.GET, skip != nil ? "\(serverUrl)?skip=\(skip!)" : serverUrl, encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data, let jsonArray: [JSON] = JSON(data: data).array {
        
        for json in jsonArray {
          let listing = Listing(json: json)
          self?.model.listings.append(listing)
        }
        
        // to safeguard against multiple server calls when the server has no more data
        // to send back, we use a timer to disable this controller's server calls
        if (jsonArray.count == 0) {
          self?.model.shouldRefrainFromCallingServer = true
          
          // create a throttler
          // this will disable this controllers server calls for 10 seconds
          self?.refrainTimer?.invalidate()
          self?.refrainTimer = nil
          self?.refrainTimer = NSTimer.after(10.0) { [weak self] in
            self?.model.shouldRefrainFromCallingServer = false
          }
        }
      }
      
      // after a response, unlock the view
      self?.model.shouldLockView = false
    }
  }
}