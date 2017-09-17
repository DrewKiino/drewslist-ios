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
        break
      case .subtitle:
        font = UIFont(name: "AvenirNextCondensed-Medium", size: 12)
        break
      case .body:
        font = UIFont(name: "AvenirNextCondensed-Medium", size: 24)
        break
      }
    }
  }
  override func setup() {
    super.setup()
    textColor = .white
    numberOfLines = 0
  }
  func set(style: DLLabel.Style) -> Self {
    self.style = style
    return self
  }
}

