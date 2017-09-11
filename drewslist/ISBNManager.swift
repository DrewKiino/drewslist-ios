//
//  ISBNManager.swift
//  drewslist
//
//  Created by Andrew Aquino on 9/9/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import BarcodeScanner

class ISBNManager {
  static let shared = ISBNManager()
  fileprivate weak var presentingViewController: UIViewController?
  fileprivate var barcodeScannerController: BarcodeScannerController?
  fileprivate var dismissHandler: ((String?) -> ())?
  private func setupBarcodeScannerController() -> BarcodeScannerController {
    let vc = BarcodeScannerController()
    vc.codeDelegate = self
    vc.errorDelegate = self
    vc.dismissalDelegate = self
    vc.isOneTimeSearch = true
    BarcodeScanner.Title.text = NSLocalizedString("ISBN Scanner", comment: "")
    BarcodeScanner.CloseButton.text = NSLocalizedString("Cancel", comment: "")
    BarcodeScanner.Info.loadingText = NSLocalizedString("Scanning...", comment: "")
    BarcodeScanner.Info.notFoundText = NSLocalizedString("No ISBN Found.", comment: "")
    BarcodeScanner.Info.settingsText = NSLocalizedString(
      "In order to scan ISBN(s) you have to allow camera under your settings.", comment: "")
    return vc
  }
  class func presented(
    with viewController: UIViewController?,
    selectedISBNHandler: @escaping ((String?) -> ())
    ) {
    let this = ISBNManager.shared
    this.dismissHandler = { isbn in
      selectedISBNHandler(isbn)
    }
    this.presentingViewController = viewController
    this.barcodeScannerController = this.setupBarcodeScannerController()
    if let barcodeScannerController = this.barcodeScannerController {
      viewController?.present(barcodeScannerController, animated: true) {
      }
    }
  }
  func dismiss(with isbn: String? = nil) {
    if isbn == nil { self.dismissHandler?(nil) }
    presentingViewController?.dismiss(animated: true) { [weak self] in
      if isbn != nil { self?.dismissHandler?(isbn) }
    }
  }
}

extension ISBNManager:
  BarcodeScannerCodeDelegate,
  BarcodeScannerErrorDelegate,
  BarcodeScannerDismissalDelegate
{
  func barcodeScanner(_ controller: BarcodeScannerController, didCaptureCode code: String, type: String) {
    controller.reset()
    dismiss(with: code)
  }
  func barcodeScanner(_ controller: BarcodeScannerController, didReceiveError error: Error) {
    controller.resetWithError(message: "Unable to read ISBN")
  }
  func barcodeScannerDidDismiss(_ controller: BarcodeScannerController) {
    dismiss()
  }
}
