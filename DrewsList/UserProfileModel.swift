//
//  UserProfileModel.swift
//  DrewsList
//
//  Created by Kevin Mowers on 11/7/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals


public class UserProfileModel {
  
  public let _user_id = Signal<String?>()
  public var user_id: String?
  
  public let _firstName = Signal<String?>()
  public var firstName: String?
  
  public let _lastName = Signal<String?>()
  public var lastName: String?
  
  public let _username = Signal<String?>()
  public var username: String? { didSet { _username => username } }
  
  public let _image = Signal<UIImage?>()
  public var image: UIImage? { didSet { _image => image } }
  
  public let _saleList = Signal<[Book]>()
  public var saleList: [Book] = [] { didSet { _saleList => saleList } }
 
  public let _wishList = Signal<[Book]>()
  public var wishList: [Book] = [] { didSet { _wishList => wishList } }
  
  init (){
    let dummyUser = User()
    user_id = dummyUser.user_id
    firstName = dummyUser.firstName
    lastName = dummyUser.lastName
    username = dummyUser.username
    let dummyBooks = [Book(), Book(), Book(), Book()]
    saleList = dummyBooks
  }
}
