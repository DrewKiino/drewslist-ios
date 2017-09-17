//
//  ImagePickerButton.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/9/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

class ImagePickerButton: BasicView {
  private let actionButton = BasicButton()
  private let imageView = BasicImageView()
  private var tapGesture: UITapGestureRecognizer?
  let spinner = UIActivityIndicatorView(activityIndicatorStyle: .white)
  var didFinishWithImageHandler: ((UIImage?) -> ())?
  override func setup() {
    clipsToBounds = true
    layer.borderColor = UIColor.dlBlue.cgColor
    layer.borderWidth = 1.0
    layer.cornerRadius = 8.0
    // init self
    self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapped))
    addGestureRecognizer(self.tapGesture!)
    // init image view
    addSubview(imageView)
    imageView.fillSuperview()
    // spinner
    addSubview(spinner)
    spinner.center()
    // init cancel
    actionButton.addTarget(self, action: #selector(self.actionTapped), for: .touchUpInside)
    actionButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
    addSubview(actionButton)
    actionButton.anchor(.top, .left, padding: 0).size(width: 36, height: 36)
  }
  func tapped() {
    HeaderView.shared.hide()
    actionButton.hide()
    CameraManager.presented(
      with: RootNavigationController.topPresentedViewController
    ) { [weak self] (image) in
      HeaderView.shared.show()
      self?.select(image: image)
    }
  }
  func actionTapped() {
    if imageView.image == nil { tapped()
    } else { deselect() }
  }
  func select(image: UIImage?) {
    actionButton.show()
    imageView.image = image ?? imageView.image
    actionButton.setImage(self.imageView.image == nil ? #imageLiteral(resourceName: "camera") : #imageLiteral(resourceName: "cancel-light"), for: .normal)
    didFinishWithImageHandler?(self.imageView.image)
  }
  @objc func deselect() {
    imageView.image = nil
    didFinishWithImageHandler?(self.imageView.image)
    actionButton.hide() { [weak self] in
      self?.actionButton.setImage(#imageLiteral(resourceName: "camera"), for: .normal)
      self?.actionButton.show() {
        
      }
    }
  }
}
