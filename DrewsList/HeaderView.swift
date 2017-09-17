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
  let titleButton = BasicButton()
  let leftButton = BasicButton()
  let rightButton = BasicButton()
  var leftButtonTappedHandler: (() -> ())?
  var rightButtonTappedHandler: (() -> ())?
  override func setup() {
    
    backgroundColor = .white
    
    titleButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Bold", size: 24)
    titleButton.setTitle("Drew's List", for: .normal)
    addSubview(titleButton)
    titleButton.center().autoresize(width: 100).height(44)
    
    leftButton.setTitleColor(.darkGray, for: .normal)
    leftButton.setTitle(nil, for: .normal)
    leftButton.addTarget(self, action: #selector(self.leftButtonTapped), for: .touchUpInside)
    leftButton.contentHorizontalAlignment = .left
    leftButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Light", size: 20)
    addSubview(leftButton)
    leftButton.anchor(.left, padding: 10).matching(.height).autoresize(width: 100)
    
    rightButton.setTitleColor(.darkGray, for: .normal)
    rightButton.setTitle(nil, for: .normal)
    rightButton.addTarget(self, action: #selector(self.rightButtonTapped), for: .touchUpInside)
    rightButton.contentHorizontalAlignment = .right
    rightButton.titleLabel?.font = UIFont(name: "AvenirNextCondensed-Medium", size: 20)
    addSubview(rightButton)
    rightButton.anchor(.right, padding: 10).matching(.height).autoresize(width: 100)
  }
  func leftButtonTapped() {
    leftButtonTappedHandler?()
  }
  func rightButtonTapped() {
    rightButtonTappedHandler?()
  }
  func setLeftButtonText(_ text: String?) {
    leftButton.hide() { [weak self] in
      self?.leftButton.setTitle(text, for: .normal)
      self?.leftButton.show()
    }
  }
  func setRightButtonText(_ text: String?) {
    rightButton.hide() { [weak self] in
      self?.rightButton.setTitle(text, for: .normal)
      self?.rightButton.show()
    }
  }
}

extension HeaderView {
  class func moveToWindow() {
    let headerView = HeaderView.shared
    UIApplication.shared.keyWindow?.addSubview(headerView)
    headerView.anchor(.top).matching(.width).height(44)
  }
}
