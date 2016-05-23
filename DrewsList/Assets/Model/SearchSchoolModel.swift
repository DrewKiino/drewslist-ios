//
//  SearchSchoolModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/24/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import ObjectMapper
import SwiftyJSON

public class SearchSchoolModel {
  
  private struct Singleton { static let searchSchoolModel = SearchSchoolModel() }
  public class func sharedInstance() -> SearchSchoolModel { return Singleton.searchSchoolModel }
  
  public let _searchString = Signal<String?>()
  public var searchString: String? { didSet { _searchString => searchString } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _schools = Signal<[School]>()
  public var schools: [School] = [] { didSet { _schools => schools } }
  
  public let _school = Signal<School?>()
  public var school: School? { didSet { _school => school } }
}

public class School: Mappable {
  
  public let __id = Signal<String?>()
  public var _id: String? { didSet { __id => _id } }
  
  public let _state = Signal<String?>()
  public var state: String? { didSet { _state => state } }
  
  public let _name = Signal<String?>()
  public var name: String? { didSet { _name => name } }
  
  public init() {}
  
  public init(json: JSON) {
    if let json = json.dictionaryObject {
      mapping(Map(mappingType: .FromJSON, JSONDictionary: json))
    }
  }
  
  public required init?(_ map: Map) {}
  
  public func mapping(map: Map) {
    _id             <- map["_id"]
    state           <- map["state"]
    name            <- map["name"]
  }
}