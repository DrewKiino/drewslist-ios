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
      
    model.user_id = dummyUser._id
    model.firstName = dummyUser.firstName
    model.lastName = dummyUser.lastName
    model.username = dummyUser.username
    
    let dummyBooks1 = [Book(), Book(), Book(), Book()]
    let dummyBooks2 = [Book(), Book(), Book()]
    model.saleList = dummyBooks1
    model.wishList = dummyBooks2
  }
  
  public func getModel() -> UserProfileModel { return model }
}
