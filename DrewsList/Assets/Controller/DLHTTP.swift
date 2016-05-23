//
//  DLHTTP.swift
//  DrewsList
//
//  Created by Andrew Aquino on 4/9/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public typealias DLHTTPResponseBlock = (json: JSON?, error: NSError?) -> Void

public class DLHTTP {
  
  public class func POST(endPoint: String, parameters: [ String: AnyObject ], responseBlock: DLHTTPResponseBlock) {
    Alamofire.request(.POST, ServerUrl.Default.getValue() + endPoint, parameters: parameters)
    .response { (req, res, data, error) in
      if let error = error {
        responseBlock(json: nil, error: error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        responseBlock(json: json, error: nil)
      }
    }
  }
  
  public class func GET(endPoint: String, parameters: [ String: AnyObject ]? = nil, responseBlock: DLHTTPResponseBlock) {
    Alamofire.request(.GET, ServerUrl.Default.getValue() + endPoint, parameters: parameters)
    .response { (req, res, data, error) in
      if let error = error {
        responseBlock(json: nil, error: error)
      } else if let data = data, let json: JSON! = JSON(data: data) {
        responseBlock(json: json, error: nil)
      }
    }
  }
}