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
    
    // make the request following the server's route pattern
    DLHTTP.POST("/listing/destroy", parameters: [ "_id": list_id ]) { [weak self] json, error in
      if json != nil {
        self?.serverCallbackFromDeletelIsting.fire(true)
        UserProfileViewRefreshContent.fire()
        ListFeedViewRefreshContent.fire()
      }
    }
  }
  
  public func setListing(listing: Listing) { model.listing = listing }
  
  public func getModel() -> ListModel { return model }
}