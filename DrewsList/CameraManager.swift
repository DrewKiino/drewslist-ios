//
//  CameraManager.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/9/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import ImagePicker

class CameraManager {
  static let shared = CameraManager()
  fileprivate weak var presentingViewController: UIViewController?
  fileprivate var imagePickerController: ImagePickerController?
  fileprivate var dismissHandler: ((UIImage?) -> ())?
  private func setupImagePickerController() -> ImagePickerController {
    let vc = ImagePickerController()
    vc.delegate = self
    vc.imageLimit = 1
    vc.configuration = {
      var configuration = Configuration()
      configuration.collapseCollectionViewWhileShot = false
      configuration.allowMultiplePhotoSelection = false
      configuration.canRotateCamera = false
      return configuration
    }()
    return vc
  }
  class func presented(
    with viewController: UIViewController?,
    selectedImageHandler: @escaping ((UIImage?) -> ())
  ) {
    let this = CameraManager.shared
    this.dismissHandler = { image in
      selectedImageHandler(image)
    }
    this.presentingViewController = viewController
    this.imagePickerController = this.setupImagePickerController()
    if let imagePickerController = this.imagePickerController {
      viewController?.present(imagePickerController, animated: true) {
      }
    }
  }
  func dismiss(with image: UIImage? = nil) {
    if image == nil { self.dismissHandler?(nil) }
    presentingViewController?.dismiss(animated: true) { [weak self] in
      if image != nil { self?.dismissHandler?(image) }
    }
  }
}

extension CameraManager: ImagePickerDelegate {
  func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
  }
  func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
    dismiss(with: images.first)
  }
  func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
    dismiss()
  }
}
