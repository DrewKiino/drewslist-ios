//
//  UserProfileController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 11/7/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import SwiftyTimer

public class UserProfileController {
  
  private let model = UserProfileModel()
  private var view: UserProfileView?
  
  public func userViewWillAppear() {
    // init fixtures
    setupFixtures()
  }
  
  private func setupFixtures() {
    let dummyUser = User()
    dummyUser._id = "1234"
    dummyUser.firstName = "Harry"
    dummyUser.lastName = "Potter"
    dummyUser.username = "GriffindorLover"
    dummyUser.image = "http://orig06.deviantart.net/b682/f/2013/135/4/3/profile_picture_by_mellodydoll_stock-d65fbf8.jpg"
    dummyUser.bgImage = "http://www.mybulkleylakesnow.com/wp-content/uploads/2015/11/books-stock.jpg"
    
//    model.user_id = dummyUser._id
//    model.firstName = dummyUser.firstName
//    model.lastName = dummyUser.lastName
//    model.username = dummyUser.username
    
    let dummyBooks1 = [Book(), Book(), Book(), Book(), Book(), Book()]
    let dummyBooks2 = [Book(), Book(), Book(), Book(), Book()]
//    model.saleList = dummyBooks1
//    model.wishList = dummyBooks2
    
    dummyUser.saleList = dummyBooks1
    dummyUser.wishList = dummyBooks2
    
    model.user = dummyUser
  }
  
  public func getModel() -> UserProfileModel { return model }
}
