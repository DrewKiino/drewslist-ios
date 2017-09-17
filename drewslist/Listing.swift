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

class Listing: Model, Mappable {
  static var identifier: String! = "listings"
  class shared {}
  // model vars
  var userID: String? = User.localID
  var book: Book? = Book()
  var media: [Media] = []
  var contactNumber: String?
  var zipcode: String?
  var longitude: Double?
  var latitude: Double?
  // conv vars
  var distance: Double?
  func mapping(map: Map) {
    self.userID <- map["userID"]
    self.book <- map["book"]
    self.media <- map["media"]
    self.contactNumber <- map["contactNumber"]
    self.zipcode <- map["zipcode"]
    self.media <- map["media"]
    self.longitude <- map["longitude"]
    self.latitude <- map["latitude"]
  }
  init(title: String, author: String, imageURL: String?) {
    super.init(model: Listing.identifier, id: UUID().uuidString)
  }
  init() {
    super.init(model: Listing.identifier, id: UUID().uuidString)
  }
  init(id: String?) {
    super.init(model: Listing.identifier, id: id)
  }
  required init?(map: Map) {
    super.init(model: Listing.identifier, id: UUID().uuidString)
  }
  func list(completionHandler: ((Bool) -> ())? = nil) {
    datastore?.set(json: self.toJSON(), completionHandler: completionHandler)
  }
  func get() {
    datastore?.get({ (dict) in
      log.debug(dict)
    })
  }
  @discardableResult
  class func fetch() -> Promise<[Listing]> {
    return Promise { fulfill, reject in
      DataStore(model: Listing.identifier)?.get({ (dict) in
        let listings = dict.flatMap({ Listing(JSON: $0) })
        Listing.shared.listings = listings
        fulfill(listings)
      })
    }
  }
}

extension Listing.shared {
  static var listings: [Listing] = [] {
    didSet { Listing.shared.listingsSignal => listings }
  }
  static let listingsSignal = Signal<[Listing]>()
}
