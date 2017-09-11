//
//  Media.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/2/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import Firebase
import SDWebImage
import ObjectMapper
import PromiseKit

class Media: Model, Mappable {
  static var identifier: String! = "media"
  fileprivate var isCurrentlyUploading = false
  enum type: String {
    case image = "images"
  }
  // convenience vars
  var image: UIImage?
  // model vars
  var title: String?
  var imageURL: String?
  var index: Int?
  var type: String?
  func mapping(map: Map) {
    self.imageURL <- map["imageURL"]
    self.index <- map["index"]
    self.type <- map["type"]
  }
  init(image: UIImage?, index: Int?) {
    super.init(model: Media.identifier)
    self.image = image
    self.index = index
  }
  init(imageURL: String?, index: Int?) {
    super.init(model: Media.identifier)
    self.imageURL = imageURL
    self.index = index
  }
  init() {
    super.init(model: Media.identifier)
  }
  required init?(map: Map) {
    super.init(model: Media.identifier)
  }
  func set() {
    datastore?.set(json: self.toJSON())
  }
  func get() {
    datastore?.get({ (dict) in
      log.debug(dict)
    })
  }
  func download(name: String?, completionHandler: @escaping ((UIImage) -> ())) {
    guard let name = name else { return }
    log.debug("downloading image")
    let imageURL = name + ".jpeg"
    datastore?.storageReference?
      .child(imageURL)
      .downloadURL { (url, error) in
        if let error = error {
          log.error(error)
        } else if let url = url {
          SDWebImageDownloader.shared().downloadImage(
            with: url,
            options: [
              .useNSURLCache,
              .continueInBackground
            ], progress: { (current, max, url) in
          }, completed: { (image, data, error, success) in
            if let error = error {
              log.error(error)
            } else if let image = image {
              log.debug("image downloaded")
              completionHandler(image)
            }
          })
        }
    }
  }
  func upload() -> Promise<Media?> {
    return Promise { fulfill, reject in
      self.upload(image: self.image, title: self.title ?? index?.description) { imageURL in
        self.imageURL = imageURL
        fulfill(self)
      }
    }
  }
  func upload(completionHandler: ((String?) -> ())? = nil) {
    upload(image: self.image, title: self.title ?? index?.description, completionHandler: completionHandler)
  }
  func upload(image: UIImage?, title: String?, metadata: [String: String]? = nil, completionHandler: ((String?) -> ())? = nil) {
    guard
      !isCurrentlyUploading,
      let image = image?.crop(810),
      let title = title,
      let data = UIImagePNGRepresentation(image)
    else { return }
    isCurrentlyUploading = true
    let smd = StorageMetadata()
    smd.customMetadata = metadata
    smd.contentType = "image/jpeg"
    let reference = title + ".jpeg"
    log.debug("uploading image")
    datastore?.storageReference?
      .child(reference)
      .putData(data, metadata: smd) { [weak self] (metadata, error) in
//        let imageURL = metadata?.downloadURL()?.absoluteString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? reference
        let imageURL = reference
        if let error = error {
          log.error(error)
        } else {
          log.debug("image uploaded")
        }
        self?.isCurrentlyUploading = false
        completionHandler?(imageURL)
    }
  }
}
