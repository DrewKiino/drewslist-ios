//
//  SearchSchoolController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/24/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import RealmSwift

public class SearchSchoolController {
  
  public let model = SearchSchoolModel.sharedInstance()
  
  public class func currentSelection() -> School? { return SearchSchoolController().model.school }
  
  private let serverUrl = "https://nearbycolleges.info/api/autocomplete"
  private var refrainTimer: NSTimer?
  private var throttleTimer: NSTimer?
  
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
    guard let queryString = createQueryString(query) where !model.shouldRefrainFromCallingServer else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, queryString)
    .response { [weak self] req, res, data, error in
      
      if let error = error {
        log.error(error)
      } else if let data = data, let jsonArray: [JSON] = JSON(data: data)["result"].array {
        var schools: [School] = []
        for json in jsonArray {
          schools.append(School(json: json))
        }
        self?.model.schools.removeAll(keepCapacity: false)
        self?.model.schools = schools
        schools.removeAll(keepCapacity: false)
      }
      
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
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      self?.model.shouldRefrainFromCallingServer = false
    }
  }
  
  private func createQueryString(string: String?) -> String? {
    guard let string = string where string.characters.count > 0 else {
      model.schools.removeAll(keepCapacity: false)
      return nil
    }
    let queryString = String(string.componentsSeparatedByString(" ").reduce("") { "\($0)+\($1)" }.characters.dropFirst())
    return "\(serverUrl)?q=\(queryString)&limit=100"
  }
}












