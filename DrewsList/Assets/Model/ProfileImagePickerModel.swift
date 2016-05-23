//
//  ProfileImagePickerModel.swift
//  DrewsList
//
//  Created by Kevin Mowers on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals

public class ProfileImagePickerModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _fbProfileImageURL = Signal<String?>()
  public var fbProfileImageURL: String? { didSet { _fbProfileImageURL => fbProfileImageURL } }
  
}


