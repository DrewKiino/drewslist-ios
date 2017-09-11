//
//  LocationManager.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/10/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import SwiftLocation
import PromiseKit
import MapKit
import Signals

class LocationManager {
  static let shared = LocationManager()
  var currentLocationSignal = Signal<CLLocation>()
  var currentLocation: CLLocation? {
    didSet {
      if let currentLocation = currentLocation {
        self.currentLocationSignal => currentLocation
      }
    }
  }
  func zipcode() -> Promise<String?> {
    return location()
    .then { location -> Promise<String?> in
      return Promise { fulfill, reject in
        if let location = location {
          Location.getPlacemark(forLocation: location, success: { (placemarks) in
            if let placemark = placemarks.first {
              fulfill(placemark.postalCode)
            }
          }, failure: { (error) in
            reject(error)
          })
        } else {
          fulfill(nil)
        }
      }
    }
  }
  @discardableResult
  func location(from zipcode: String?) -> Promise<CLLocation?> {
    return Promise { fulfill, reject in
      if let zipcode = zipcode {
      Location.getLocation(forAddress: zipcode, success: { (placemarks)in
          if let location = placemarks.first?.location {
            return fulfill(location)
          }
          fulfill(nil)
      }, failure: { (error)in
        log.error(error)
        reject(error)
      })
      } else {
        fulfill(nil)
      }
    }
  }
  @discardableResult
  func location() -> Promise<CLLocation?> {
    return Promise { fulfill, reject in
      Location.getLocation(accuracy: .room, frequency: .oneShot, success: { [weak self] (_, location) in
        self?.currentLocation = location
        fulfill(location)
      }, error: { (_, _, error) -> (Void) in
        reject(error)
      })
      .register( observer: .onAuthDidChange(.main, { (request, oldAuth, newAuth) in
        log.debug("Authorization moved from \(oldAuth) to \(newAuth)")
      }))
    }
  }
}
