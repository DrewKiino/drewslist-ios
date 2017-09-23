//
//  ImageManager.swift
//  DrewsList
//
//  Created by Andrew Aquino on 9/5/17.
//  Copyright © 2017 Science Mobile. All rights reserved.
//
import Foundation
import SDWebImage
import PromiseKit

class ImageManager {
  fileprivate static let downloaderOptions: SDWebImageDownloaderOptions = [
    .continueInBackground,
    .scaleDownLargeImages,
    .lowPriority,
    ]
  fileprivate static let options: SDWebImageOptions = [
    .continueInBackground,
    .highPriority,
    .scaleDownLargeImages,
    .retryFailed,
    ]
  class func fetch(imageURL url: URL?, completionHandler: ((UIImage?) -> Void)?) {
    guard let url = url else { return }
    if let image = SDImageCache.shared().imageFromDiskCache(forKey: url.absoluteString) {
      completionHandler?(image)
    } else {
      SDWebImageDownloader.shared().downloadImage(
        with: url,
        options: self.downloaderOptions,
        progress: nil, completed: { image, _, error, _ in
          if let error = error { log.error(error) }
          SDImageCache.shared().store(image, forKey: url.absoluteString, toDisk: true, completion: nil)
          completionHandler?(image)
        }
      )
    }
  }
  @discardableResult
  class func fetch(imageURL url: URL?) -> Promise<UIImage?>? {
    guard let url = url else { return nil }
    return Promise { fulfill, reject in
      self.fetch(imageURL: url) { (image) in
        fulfill(image)
      }
    }
  }
  @discardableResult
  class func fetch(imageURLS urls: [URL]?) -> Promise<[UIImage?]>? {
    guard let urls = urls else { return nil }
    let promises = urls.flatMap({ self.fetch(imageURL: $0) })
    return when(fulfilled: promises)
  }
  class func clearCache() {
    SDImageCache.shared().clearDisk(onCompletion: nil)
  }
}

extension UIImageView {
  // convenience function to download images using our wrapper
  func set(imageFromURL url: URL, completionHandler: ((UIImage?) -> ())? = nil) {
    if let image = SDImageCache.shared().imageFromDiskCache(forKey: url.absoluteString) {
      self.image = image
      completionHandler?(image)
    } else {
      sd_setImage(with: url, placeholderImage: image, options: ImageManager.options, completed: { image, error, _, url in
        if let error = error { log.error(error) }
        SDImageCache.shared().store(image, forKey: url?.absoluteString, toDisk: true, completion: nil)
        completionHandler?(image)
      })
    }
  }
}
