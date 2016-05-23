//
//  SearchListingModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/14/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals

public class SearchListingModel {
  
  private struct Singleton { static let model = SearchListingModel() }
  public class func sharedInstance() -> SearchListingModel { return Singleton.model }
  
  public let _searchString = Signal<String?>()
  public var searchString: String? { didSet { _searchString => searchString } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _listings = Signal<[Listing]>()
  public var listings: [Listing] = [] { didSet { _listings => listings } }
  
  public let _listing = Signal<Listing?>()
  public var listing: Listing? { didSet { _listing => listing } }
}