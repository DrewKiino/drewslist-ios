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
    }
    fetch()
  }
  class func fetch() {
    when(fulfilled: Listing.fetch(), LocationManager.shared.location())
    .then { (listings, location) -> () in
      Listing.shared.listings = Listing.shared.listings
      .flatMap({ listing -> Listing? in
        // make sure we only allow listings with images
        guard listing.media.first != nil else { return nil }
        if
          let location = location,
          let long = listing.longitude,
          let lat = listing.latitude
        {
          var distance = CLLocation(latitude: lat, longitude: long).distance(from: location)
          // meters to miles rounde to nearest hundreths
          distance = round(distance * 100 * 0.000621371) / 100
          listing.distance = distance
        } else if
          let currentLocation = location,
          let zipcode = listing.zipcode
        {
          LocationManager.shared.location(from: zipcode)
          .then { location -> () in
            if var distance = location?.distance(from: currentLocation) {
              // meters to miles rounde to nearest hundreths
              distance = round(distance * 100 * 0.000621371) / 100
              listing.distance = distance
            }
          }
          .catch { log.error($0) }
        }
        return listing
      })
    }
    .catch { log.error($0) }
  }
}
