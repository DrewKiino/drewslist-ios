//
//  SearchListingModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/14/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation

public class SearchListingModel {
  
  private struct Singleton { static let model = SearchListingModel() }
  public class func sharedInstance() -> SearchListingModel { return Singleton.model }
}