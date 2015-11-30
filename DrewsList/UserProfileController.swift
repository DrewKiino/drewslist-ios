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
    //getUserFromServer(model.user_id!)
    loadView()
    loadUserImage()
    loadUsername()
    
    NSTimer.after(3.0) { [weak self] in
      self?.model.username = "NewUser"
    }
  }
  
//  private func getUserFromServer(user_id: String) {
//    server.getUser(user_id)
//    .then { user in
//      self.view?.profileImg = UIimage user.profileUrl
//      
//    }
//    .catch { error in
//      print(error)
//    }
//  }
  
  
  public func getModel() -> UserProfileModel { return model }
  
  public func loadView(){
  }
  
  public func loadUserImage(){
  }
  
  public func loadUsername(){
  }
  
  public func populateSalesList(){
  
  }
  
  public func populateWishList(){
  
  }
  
  
}