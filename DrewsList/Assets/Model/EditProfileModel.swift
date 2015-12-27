//
//  EditProfileModel.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class EditProfileModel {
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _profileImage = Signal<UIImage?>()
  public var profileImage: UIImage? { didSet { _profileImage => profileImage } }
  
}

