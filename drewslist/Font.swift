//
//  Font.swift
//  DrewsList
//
//  Created by Andrew Aquino on 9/19/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
  enum Weight {
    case bold
    case medium
    case light
  }
  class func dlFont(_ weight: UIFont.Weight = .medium, size: CGFloat = 12) -> UIFont? {
    switch weight {
    case .bold: return UIFont(name: "AvenirNextCondensed-Bold", size: size)
    case .medium: return UIFont(name: "AvenirNextCondensed-Medium", size: size)
    case .light: return UIFont(name: "AvenirNextCondensed-Light", size: size)
    }
  }
}
