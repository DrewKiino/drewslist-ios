//
//  DataManager.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/16/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import PromiseKit

class DataManager {
  static let shared = DataManager()
  class func setup() {
    LocationManager.shared.currentLocationSignal.subscribe(on: self) { (location) in
    }
    Listing.shared.listingsSignal.subscribe(on: self) { (listings) in
      Listing.shared.visibleListings = listings
      .flatMap({ listing -> Listing? in
        // make sure we only allow listings with images
        guard listing.media.first != nil else { return nil }
        if
          let location = LocationManager.shared.currentLocation,
          let long = listing.address?.longitude,
          let lat = listing.address?.latitude
        {
          var distance = CLLocation(latitude: lat, longitude: long).distance(from: location)
          // meters to miles rounde to nearest hundreths
          distance = round(distance * 100 * 0.000621371) / 100
          listing.distance = distance
        }
        return listing
      })
      .sorted(by: { lhs, rhs in
        if let lhsD = lhs.distance, let rhsD = rhs.distance {
          return lhsD < rhsD
        }
        return false
      })
    }
    fetch()
  }
  class func fetch() {
    if LocationManager.shared.currentAddress != nil { Listing.fetch() }
    LocationManager.shared.observe()
    .then { _ -> Promise<[Listing]> in Listing.fetch() }
    .then { _ -> () in LocationManager.shared.setGeoFireReference() }
    .catch { log.error($0) }
  }
}
