//
//  EditListingModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class EditListingModel {
  
  public let _listing = Signal<Listing?>()
  public var listing: Listing? { didSet { _listing => listing } }
  
}