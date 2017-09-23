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
import ObjectMapper
import Firebase
import Pantry

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
  var currentAddress: Address? {
    get {
      if let json = UserDefaults.standard.value(forKey: "CURRENT_ADDRESS") as? [String: Any] {
        return Address(JSON: json)
      }
      return nil
    }
    set(new) {
      if let new = new {
        UserDefaults.standard.set(new.toJSON(), forKey: "CURRENT_ADDRESS")
      }
    }
  }
  /*
   {
     "Street" : "I-280 N",
     "ZIP" : "94062",
     "Country" : "United States",
     "City" : "Menlo Park",
     "State" : "CA",
     "Name" : "I-280 N",
     "SubAdministrativeArea" : "San Mateo",
     "Thoroughfare" : "I-280 N",
     "FormattedAddressLines" : [
       "I-280 N",
       "Menlo Park, CA  94062",
       "United States"
     ],
     "CountryCode" : "US",
     "SubLocality" : "Sharon Heights"
   }
 */
  func address(from location: CLLocation?) -> Promise<Address?> {
    return Promise { fulfill, reject in
      guard let location = location else { return fulfill(nil) }
      Location.getPlacemark(forLocation: location, success: { (placemarks) in
        if let dict = placemarks.first?.addressDictionary as? [String: Any] {
          let address: Address? = Address(address: dict).lowercased()
          address?.longitude = location.coordinate.longitude
          address?.latitude = location.coordinate.latitude
          address?.location = location
          return fulfill(address)
        }
        fulfill(nil)
      }, failure: { (error) in
        reject(error)
      })
    }
  }
  @discardableResult
  func address(from string: String?) -> Promise<Address?> {
    guard let string = string else { return Promise(value: nil) }
    return Promise { fulfill, reject in
      Location.getLocation(forAddress: string, success: { [weak self] (placemarks)in
        self?.address(from: placemarks.first?.location)
        .then { address -> () in
          fulfill(address)
        }
        .catch { reject($0) }
      }, failure: { (error)in
        reject(error)
      })
    }
  }
  private var geocoderRequest: LocationRequest?
  private var geocoderRequestThrottler: Timer?
  private var geocoderResponseThrottler: Timer?
  @discardableResult
  func observe() -> Promise<CLLocation?> {
    return Promise { fulfill, reject in
      log.debug("observing current location")
      Location.displayHeadingCalibration = false
      self.geocoderRequest = Location.getLocation(
        accuracy: .room,
        frequency: .continuous,
        success: { [weak self] (_, location) in
          self?.geocoderRequest?.pause()
          self?.geocoderRequestThrottler?.invalidate()
          self?.geocoderRequestThrottler = Timer.after(3.0) {
            self?.geocoderRequest?.resume()
          }
          self?.geocoderResponseThrottler?.invalidate()
          self?.geocoderResponseThrottler = Timer.after(0.1) {
            log.debug("converting current location to address")
            self?.currentLocation = location
            self?.address(from: location)
            .then { address -> () in
              self?.currentAddress = address
              fulfill(location)
            }
            .catch { error in
              log.error(error)
              fulfill(location)
            }
          }
        },
        error: { (_, _, error) -> (Void) in
          reject(error)
        }
      )
      self.geocoderRequest?.register( observer: .onAuthDidChange(.main, { (request, oldAuth, newAuth) in
      }))
    }
  }
  func setGeoFireReference(for address: Address? = nil, completionHandler: ((Bool) -> ())? = nil) {
    guard let city = address?.city ?? self.currentAddress?.city
    else { completionHandler?(false); return }
    log.debug("setting geofire reference for \(city)")
    self.address(from: city)
    .then { address -> () in
      guard let location = address?.location 
      else { completionHandler?(false); return }
      let dbRef = Database.database().reference().child("geofire").child("cities")
      GeoFire(firebaseRef: dbRef).setLocation(location, forKey: city) { error in
        if let error = error {
          log.error(error)
          completionHandler?(false)
        } else {
          completionHandler?(true)
        }
      }
    }
    .catch { log.error($0) }
  }
  private var cities: [String: CLLocation] = [:]
  private var query: GFRegionQuery?
  private var queryEnteredResponseThottler: Timer?
  private var cityQueryTimer: Timer?
  func observe(citiesWithinDistanceOfMiles miles: Double, completionHandler: (([String: CLLocation]) -> ())? = nil) {
    cityQueryTimer?.invalidate()
    Timer.every(3.0) { [weak self] in
      guard let this = self, let location = this.currentLocation else { return }
      this.cities.removeAll()
      this.query?.removeAllObservers()
      let radius = round(miles * 1609.344 * 100) / 100
      let region = MKCoordinateRegionMakeWithDistance(location.coordinate, radius, radius)
      let dbRef = Database.database().reference().child("geofire").child("cities")
      this.query = GeoFire(firebaseRef: dbRef).query(with: region)
      this.query?.observe(.keyEntered) { [weak self] (city, location) in
        guard let city = city else { return }
        self?.cities[city] = location
        self?.queryEnteredResponseThottler?.invalidate()
        self?.queryEnteredResponseThottler = Timer.after(1.0) { [weak self] in
          if let cities = self?.cities {
            completionHandler?(cities)
          }
        }
      }
    }
  }
}













