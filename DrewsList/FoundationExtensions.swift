//
//  FoundationExtensions.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/3/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import CoreImage
import MapKit 

extension String {
  var intValue: Int? {
    return Int(self)
  }
  var doubleValue: Double? {
    return Double(self)
  }
  var urlValue: URL? {
    return URL(string: self)
  }
}

extension UIFont {
  class func printNames() {
    let fontFamilyNames = UIFont.familyNames
    for familyName in fontFamilyNames {
      let names = UIFont.fontNames(forFamilyName: familyName)
      print(familyName)
      print(names)
    }
  }
}

extension Collection where Indices.Iterator.Element == Index {
  subscript(safe index: Index?) -> Generator.Element? {
    if let index = index { return indices.contains(index) ? self[index] : nil }
    return nil
  }
}

extension Array {
  func prune(where condition: @escaping (_ lhs: Element, _ rhs: Element) -> Bool) -> [Element] {
    var results = [Element]()
    forEach { element in
      let existingElements = results.filter {
        return condition(element, $0)
      }
      if existingElements.count == 0 {
        results.append(element)
      }
    }
    return results
  }
}

extension UIImage {
  func crop(_ dimension: CGFloat) -> UIImage? {
    guard let cgImage = self.cgImage else { return nil }
    let size = CGSize(width: dimension, height: dimension)
    let refWidth : CGFloat = CGFloat(cgImage.width)
    let refHeight : CGFloat = CGFloat(cgImage.height)
    let x = (refWidth - size.width) / 2
    let y = (refHeight - size.height) / 2
    let cropRect = CGRect(x: x, y: y, width: size.height, height: size.width)
    if let imageRef = self.cgImage?.cropping(to: cropRect) {
      return UIImage(cgImage: imageRef, scale: 0, orientation: self.imageOrientation)
    }
    return nil
  }
}

extension UIImageView {
  func blurImage() {
    DispatchQueue.global(qos: .background).async { [weak self] in
      if let image = self?.image {
        let context = CIContext(options: nil)
        let inputImage = CIImage(image: image)
        let originalOrientation = image.imageOrientation
        let originalScale = image.scale
        let filter = CIFilter(name: "CIGaussianBlur")
        filter?.setValue(inputImage, forKey: kCIInputImageKey)
        filter?.setValue(50.0, forKey: kCIInputRadiusKey)
        if
          let outputImage = filter?.outputImage, let extent = inputImage?.extent,
          let cgImage = context.createCGImage(outputImage, from: extent)
        {
          let image = UIImage(cgImage: cgImage, scale: originalScale, orientation: originalOrientation)
          DispatchQueue.main.async {
            self?.image =  image
          }
        }
      }
    }
  }
}





