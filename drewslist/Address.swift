//
//  Address.swift
//  DrewsList
//
//  Created by Andrew Aquino on 9/17/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import SwiftLocation
import PromiseKit
import MapKit
import Signals
import ObjectMapper

class Address: Model {
  static var identifier: String! = "address"
  var zipcode: String?
  var country: String?
  var city: String?
  var state: String?
  var countryCode: String?
  var subAdminArea: String?
  var subLocality: String?
  var longitude: Double?
  var latitude: Double?
  // conv vars
  var location: CLLocation?
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.zipcode <- map["zipcode"]
    self.country <- map["country"]
    self.city <- map["city"]
    self.state <- map["state"]
    self.countryCode <- map["countryCode"]
    self.subAdminArea <- map["subAdminArea"]
    self.subLocality <- map["subLocality"]
    self.longitude <- map["longitude"]
    self.latitude <- map["latitude"]
    // apply lowercase to all keys
    self.zipcode = self.zipcode?.lowercased()
    self.country = self.country?.lowercased()
    self.city = self.city?.lowercased()
    self.state = self.state?.lowercased()
    self.countryCode = self.countryCode?.lowercased()
    self.subAdminArea = self.subAdminArea?.lowercased()
    self.subLocality = self.subLocality?.lowercased()
  }
  init() {
    super.init(model: Address.identifier)
  }
  required init?(map: Map) {
    super.init(map: map)
  }
  init(address dict: [String: Any]?) {
    super.init(model: Address.identifier)
    self.zipcode = dict?["ZIP"] as? String
    self.country = dict?["Country"] as? String
    self.city = dict?["City"] as? String
    self.state = dict?["State"] as? String
    self.countryCode = dict?["CountryCode"] as? String
    self.subAdminArea = dict?["SubAdministrativeArea"] as? String
    self.subLocality = dict?["SubLocality"] as? String
  }
}
