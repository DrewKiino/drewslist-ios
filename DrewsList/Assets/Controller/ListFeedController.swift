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
import RealmSwift

public class ListFeedController {
  
  private let model = ListFeedModel()
  
  private var refrainTimer: NSTimer?
  
  private let serverUrl = ServerUrl.Staging.getValue() + "/listing"
  
  public init() {}
  
  public func getModel() -> ListFeedModel { return model }
  
  public func getListingsFromServer(skip: Int? = nil, listType: String? = nil) {
    if model.shouldRefrainFromCallingServer == true { return }
    
    if skip == 0 { model.listings.removeAll(keepCapacity: false) }
    
    // lock the view
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, skip != nil ? listType != nil ? "\(serverUrl)?skip=\(skip!)&listType=\(listType!)" : "\(serverUrl)?skip=\(skip!)" : serverUrl, encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data, let jsonArray: [JSON] = JSON(data: data).array {
        
        // for each listing in the JSON response, append it to the listings array
        // in the list feed model
        for json in jsonArray { self?.model.listings.append(Listing(json: json)) }
      }
      
      
      // to safeguard against multiple server calls when the server has no more data
      // to send back, we use a timer to disable this controller's server calls
      self?.model.shouldRefrainFromCallingServer = true
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.refrainTimer = NSTimer.after(1.0) { [weak self] in
        self?.model.shouldRefrainFromCallingServer = false
      }
    }
    
    // create a throttler
    // this will disable this controllers server calls for 10 seconds
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(10.0) { [weak self] in
      self?.model.shouldRefrainFromCallingServer = false
    }
  }
}