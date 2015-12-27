//
//  SearchUserModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/25/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class SearchUserModel {
  
  private struct Singleton {
    private static let searchUserModel = SearchUserModel()
  }
  
  public class func sharedInstance() -> SearchUserModel { return Singleton.searchUserModel }
  
  public let _searchString = Signal<String?>()
  public var searchString: String? { didSet { _searchString => searchString } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _users = Signal<[User]>()
  public var users: [User] = [] { didSet { _users => users } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
}