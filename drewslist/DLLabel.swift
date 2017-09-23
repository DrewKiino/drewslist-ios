//
//  DLLabel.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/16/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

class DLLabel: BasicLabel {
  enum Style {
    case title
    case subtitle
    case body
  }
  var style: DLLabel.Style = .body {
    didSet {
      switch style {
      case .title:
        font = UIFont(name: "AvenirNextCondensed-Bold", size: 40)
        minimumScaleFactor = 0.6
        break
      case .subtitle:
        font = UIFont(name: "AvenirNextCondensed-Medium", size: 12)
        minimumScaleFactor = 1.0
        break
      case .body:
        font = UIFont(name: "AvenirNextCondensed-Medium", size: 24)
        minimumScaleFactor = 0.5
        break
      }
    }
  }
  override func setup() {
    super.setup()
    textColor = .white
    numberOfLines = 0
    adjustsFontSizeToFitWidth = true
  }
  func set(style: DLLabel.Style) -> Self {
    self.style = style
    return self
  }
}

