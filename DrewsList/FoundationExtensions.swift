//
//  FoundationExtensions.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/3/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation

extension String {
  var intValue: Int? {
    return Int(self)
  }
  var doubleValue: Double? {
    return Double(self)
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



