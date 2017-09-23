//
//  Book.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import Firebase
import ObjectMapper

class Book: Model {
  static var identifier: String! = "book"
  static var pluralIdentifier: String! = "books"
  var title: String?
  var author: String?
  var imageURL: String?
  var isbn: String?
  override func mapping(map: Map) {
    super.mapping(map: map)
    self.title    <- map["title"]
    self.author   <- map["author"]
    self.imageURL <- map["imageURL"]
    self.isbn     <- map["isbn"]
  }
  init(title: String, author: String, imageURL: String?) {
    super.init(model: "books")
    self.title = title
    self.author = author
    self.imageURL = imageURL
  }
  init() {
    super.init(model: Book.pluralIdentifier)
  }
  init(id: String?) {
    super.init(model: Book.pluralIdentifier, id: id)
  }
  required init?(map: Map) {
    super.init(model: Book.pluralIdentifier)
  }
  func set() {
    datastore?.set(json: self.toJSON())
  }
  func get() {
    datastore?.get({ (dict) in
      log.debug(dict)
    })
  }
  class func fetch() {
    DataStore(model: "books")?.get({ (dict) in
      log.debug(dict)
    })
  }
  class func fetch(title: String) {
  }
}

extension Book {
  static var shared: Book = {
    let book = Book(id: User.localID)
    return book
  }()
}













