//
//  LocationModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals
import CoreLocation

public class LocationModel {
  
  public let _userLocation = Signal<CLLocation?>()
  public var userLocation: CLLocation? { didSet { _userLocation => userLocation } }
}