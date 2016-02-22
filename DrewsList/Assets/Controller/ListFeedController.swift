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
import Signals

public class ListFeedController {
  
  private let model = ListFeedModel()
  
  private var refrainTimer: NSTimer?
  
  private let serverUrl = ServerUrl.Default.getValue() + "/listing"
  
  public let shouldRefreshViews = Signal<Bool>()
  
  public init() {
    readRealmUser()
  }
  
  public func getModel() -> ListFeedModel { return model }
  
  public func getListingsFromServer(skip: Int? = nil, listType: String? = nil, clearListings: Bool) {
    if model.shouldRefrainFromCallingServer == true { return }
    
    if clearListings { model.listings.removeAll(keepCapacity: false) }
    
    // lock the view
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, "\(serverUrl)?skip=\(skip ?? 0)&listType=\(listType ?? model.listType ?? "All")", encoding: .URL)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data where JSON(data: data).array?.isEmpty == true {
        self?.shouldRefreshViews.fire(false)
      } else if let data = data, let jsonArray: [JSON] = JSON(data: data).array {
        
        // for each listing in the JSON response, append it to the listings array
        // in the list feed model
        for json in jsonArray {
//          log.debug(json)
          self?.model.listings.append(Listing(json: json))
        }
        
        self?.shouldRefreshViews.fire(true)
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
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}