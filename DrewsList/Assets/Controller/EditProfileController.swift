//
//  EditProfileController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation

public class EditProfileController {

  public let model = EditProfileModel()
  
  public func setUp() {
  
    let user = User()
    user.image = "https://www.google.com/url?sa=i&rct=j&q=&esrc=s&source=images&cd=&cad=rja&uact=8&ved=0ahUKEwinxvapkezJAhUMKyYKHR3CAskQjRwIBw&url=http%3A%2F%2Fengineering.unl.edu%2Fkayla-person%2F&psig=AFQjCNFJgRTV0bIR5OTWTumjJpDKdjFU5w&ust=1450759200227606"
    model.user = user
    
  
  }
  
  
}