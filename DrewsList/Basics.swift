//
//  Basics.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import Signals

extension UIView {
  func show(after delay: TimeInterval = 0.0, animated: Bool = true, completionHandler: (() -> ())? = nil) {
    if animated {
      UIView.animate(
        withDuration: 0.5,
        delay: delay,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 0.5,
        options: [
          .curveEaseInOut,
          .allowUserInteraction
        ],
        animations: { [weak self] in
          self?.alpha = 1.0
        }
      ) { _ in
        completionHandler?()
      }
    } else {
      alpha = 1.0
      completionHandler?()
    }
  }
  func hide(after delay: TimeInterval = 0.0, animated: Bool = true, completionHandler: (() -> ())? = nil) {
    if animated {
      UIView.animate(
        withDuration: 0.5,
        delay: delay,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 0.5,
        options: [
          .curveEaseInOut,
          .allowUserInteraction
        ],
        animations: { [weak self] in
          self?.alpha = 0.0
        }
      ) { _ in
        completionHandler?()
      }
    } else {
      alpha = 0.0
      completionHandler?()
    }
  }
}

class BasicView: UIView {
  init() {
    super.init(frame: .zero)
    setup()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  func setup() {}
}

class BasicViewController: UIViewController {
  let headerView = HeaderView.shared
  var viewTappedHandler: (() -> ())?
  fileprivate static let resignFirstResponderSignal = Signal<()>()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped)))
  }
  
  func viewTapped() {
    resignFirstResponder()
    BasicViewController.resignFirstResponderSignal => ()
    viewTappedHandler?()
  }
}

class BasicTableViewCell: UITableViewCell {
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  func setup() {}
}

extension UITableViewCell {
  static var empty: UITableViewCell {
    return UITableViewCell()
  }
}

class BasicTextField: UITextField {
  var alternateTextSelectionHandler: ((((String?) -> ())?) -> ())?
  var shouldBeginEditing: ((((Bool) -> ())?) -> ())?
  var didChangeTextHandler: ((String?) -> ())?
  fileprivate var bypassFirstResponderCheck = false
  deinit {
    BasicViewController.resignFirstResponderSignal.cancelSubscription(for: self)
  }
  init() {
    super.init(frame: .zero)
    setup()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  func setup() {
    autocapitalizationType = .words
    delegate = self
    BasicViewController.resignFirstResponderSignal.subscribe(on: self) { [weak self] in
      self?.resignFirstResponder()
    }
  }
}
extension BasicTextField: UITextFieldDelegate {
  func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    if bypassFirstResponderCheck { return true }
    shouldBeginEditing?({ [weak self] shouldBegin in
      if shouldBegin {
        self?.bypassFirstResponderCheck = true
        self?.becomeFirstResponder()
        self?.text = nil
      } else {
        self?.resignFirstResponder()
        self?.alternateTextSelectionHandler?({ [weak self] text in
          self?.text = text ?? self?.text
          self?.didChangeTextHandler?(self?.text)
        })
      }
    })
    return (shouldBeginEditing) == nil
  }
  func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    bypassFirstResponderCheck = false
    return true
  }
  func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    let newText = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string)
    didChangeTextHandler?(newText)
    return true
  }
}

class BasicButton: UIButton {
  var didTapHandler: (() -> ())?
  init() {
    super.init(frame: .zero)
    setup()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  func setup() {
    addTarget(self, action: #selector(self.didTap), for: .touchUpInside)
  }
  func didTap() {
    didTapHandler?()
  }
}

class BasicImageView: UIImageView {
  init() {
    super.init(frame: .zero)
    setup()
  }
  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  func setup() {}
}


