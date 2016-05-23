//
//  SearchListingController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/14/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Signals

public class SearchListingController {
 
  public let model = SearchListingModel.sharedInstance()
  
  private var refrainTimer: NSTimer?
  private var throttleTimer: NSTimer?
  
  public let isLoadingDataFromServer = Signal<Bool>()
  public let didLoadDataFromServer = Signal<Bool>()
  
  public init() {
    model._searchString.removeAllListeners()
    model._searchString.listen(self) { [weak self ] string in
      self?.throttleTimer?.invalidate()
      self?.throttleTimer = NSTimer.after(1.0) { [weak self] in
        self?.searchSchool(string)
      }
    }
  }
  
  public func searchSchool(query: String?) {
    guard let queryString = createQueryString(checkForAcronyms(query)) where !model.shouldRefrainFromCallingServer else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    isLoadingDataFromServer => true
    
    Alamofire.request(.GET, queryString)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data, let jsonArray: [JSON] = JSON(data: data).array {
        
        self?.model.listings.removeAll(keepCapacity: false)
        
        for json in jsonArray {
          self?.model.listings.append(Listing(json: json))
        }
      }
      
      // create a throttler
      // this will disable this controllers server calls for 10 seconds
      self?.refrainTimer?.invalidate()
      self?.refrainTimer = nil
      self?.refrainTimer = NSTimer.after(0.2) { [weak self] in
        self?.model.shouldRefrainFromCallingServer = false
      }
      
      self?.didLoadDataFromServer.fire(true)
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
    guard let string = string where string.characters.count > 0 else {
      return nil
    }
    let queryString = String(string.componentsSeparatedByString(" ").reduce("") { "\($0)+\($1)" }.characters.dropFirst())
    return "\(ServerUrl.Default.getValue())/listing/search?query=\(queryString)&limit=10"
  }
  
  public func checkForAcronyms(query: String?) -> String? {
    guard let query = query?.lowercaseString else { return nil }
    switch query {
      case "csula", "calstatela", "calstate la", "cal state la": return "California State University-Los Angeles"
    default: return query
    }
  }
}