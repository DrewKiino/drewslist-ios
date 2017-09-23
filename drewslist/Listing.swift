//
//  Listing.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/9/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import ObjectMapper
import PromiseKit
import Signals
import Firebase

class Listing: Model {
  static var identifier: String! = "listing"
  static var pluralIdentifier: String! = "listings"
  class shared {}
  // model vars
  var book: Book? = Book()
  var user: User? = User()
  var address: Address? = Address()
  var media: [Media] = []
  // conv vars
  var distance: Double?
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.user <- map["user"]
    self.book <- map["book"]
    self.address <- map["address"]
    self.media <- map["media"]
  }
  init() {
    super.init(model: Listing.pluralIdentifier, id: UUID().uuidString)
  }
  required init?(map: Map) {
    super.init(model: Listing.pluralIdentifier, id: UUID().uuidString)
  }
  @discardableResult
  class func fetch() -> Promise<[Listing]> {
    return Promise { fulfill, reject in
      guard
        let address = LocationManager.shared.currentAddress,
        let countryCode = address.countryCode,
        let state = address.state,
        let city = address.city
      else { return fulfill([]) }
      log.debug("fetching listings within \(city)")
      let date = Date()
      let reference = Database.database().reference().child(Listing.pluralIdentifier)
      .child(countryCode).child(state).child(city)
      reference.observeSingleEvent(of: .value, with: { (snapshot) in
        var array: [[String: Any]] = []
        if let value = snapshot.value as? [String: Any] {
          array = value.flatMap({ key, value -> [String: Any]? in
            return value as? [String: Any]
          })
        }
        let listings = array.flatMap({ Listing(JSON: $0) })
        let duration = round(Date().timeIntervalSince(date) * 100) / 100
        log.debug(duration.description + "s")
        Listing.shared.listings = listings
        fulfill(listings)
      })
    }
  }
  @discardableResult
  class func fetch(inBook key: String?, value: String?) -> Promise<[Listing]> {
    return Promise { fulfill, reject in
      guard let key = key, let value = value else { return fulfill([]) }
      DataStore(model: Listing.pluralIdentifier)?.get(in: Book.identifier, where: key, beginsWith: value, { (dict) in
        let listings = dict.flatMap({ Listing(JSON: $0) })
        fulfill(listings)
      })
    }
  }
  @discardableResult
  class func fetch(inAddress key: String?, value: String?) -> Promise<[Listing]> {
    return Promise { fulfill, reject in
      guard let key = key, let value = value else { return fulfill([]) }
      DataStore(model: Listing.pluralIdentifier)?.get(in: Address.identifier, where: key, beginsWith: value, { (dict) in
        let listings = dict.flatMap({ Listing(JSON: $0) })
        fulfill(listings)
      })
    }
  }
  var reference: DatabaseReference? {
    if
      let countryCode = self.address?.countryCode,
      let state = self.address?.state,
      let city = self.address?.city,
      let model = self.model,
      let listingID = self.id
    {
      return Database.database().reference().child(model).child(countryCode).child(state).child(city).child(listingID)
    }
    return nil
  }
  func list(completionHandler: ((Bool) -> ())? = nil) {
    LocationManager.shared.setGeoFireReference(for: self.address) { success in
      guard success else { completionHandler?(false); return }
      self.reference?.setValue(self.toJSON()) { (error, _) in
        if let error = error {
          log.error(error)
          completionHandler?(false)
        } else {
          completionHandler?(true)
        }
      }
    }
  }
}

extension Listing.shared {
  static var listings: [Listing] = [] {
    didSet { Listing.shared.listingsSignal => listings }
  }
  static let listingsSignal = Signal<[Listing]>()
  static var visibleListings: [Listing] = [] {
    didSet { Listing.shared.visibleListingsSignal => visibleListings }
  }
  static let visibleListingsSignal = Signal<[Listing]>()
}
