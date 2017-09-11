//
//  HeaderView.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/3/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

class HeaderView: BasicView {
  static let shared = HeaderView()
  let leftButton = UIButton()
  let rightButton = UIButton()
  var leftButtonTappedHandler: (() -> ())?
  var rightButtonTappedHandler: (() -> ())?
  override func setup() {
    let bottomBorder = UIView()
    bottomBorder.backgroundColor = .black
    addSubview(bottomBorder)
    bottomBorder.anchor(.bottom).matching(.width).height(1)
    
    leftButton.setTitleColor(.darkGray, for: .normal)
    leftButton.setTitle("-", for: .normal)
    leftButton.addTarget(self, action: #selector(self.leftButtonTapped), for: .touchUpInside)
    leftButton.contentHorizontalAlignment = .left
    addSubview(leftButton)
    leftButton.anchor(.left, padding: 10).matching(.height).width(100)
    
    rightButton.setTitleColor(.darkGray, for: .normal)
    rightButton.setTitle("+", for: .normal)
    rightButton.addTarget(self, action: #selector(self.rightButtonTapped), for: .touchUpInside)
    rightButton.contentHorizontalAlignment = .right
    addSubview(rightButton)
    rightButton.anchor(.right, padding: 10).matching(.height).width(100)
  }
  func leftButtonTapped() {
    leftButtonTappedHandler?()
  }
  func rightButtonTapped() {
    rightButtonTappedHandler?()
  }
  func setLeftButtonText(_ text: String?) {
    leftButton.setTitle(text, for: .normal)
  }
  func setRightButtonText(_ text: String?) {
    rightButton.setTitle(text, for: .normal)
  }
}
