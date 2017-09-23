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
  var keyboardWillShowHandler: ((CGFloat) -> ())?
  var keyboardWillHideHandler: (() -> ())?
  deinit {
    NotificationCenter.default.removeObserver(self)
  }
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.viewTapped)))
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
    NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
  }
  
  func viewTapped() {
    self.resignFirstResponder()
    viewTappedHandler?()
  }
  @discardableResult
  override func resignFirstResponder() -> Bool {
    BasicTextField.resignFirstResponderSignal => ()
    return super.resignFirstResponder()
  }
  
  func keyboardWillShow(notification: Notification) {
    if let height = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.height {
      keyboardWillShowHandler?(height)
    }
  }
  func keyboardWillHide() {
    keyboardWillHideHandler?()
  }
}

class BasicTableViewCell: UITableViewCell {
  static let identifer = "BasicTableViewCell"
  var didSelectCellHandler: ((IndexPath) -> ())?
  var indexPath: IndexPath?
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  func setup() {
    backgroundColor = .white
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didSelect)))
  }
  func didSelect() {
    if let indexPath = self.indexPath {
      didSelectCellHandler?(indexPath)
    }
  }
}

extension UITableViewCell {
  static var empty: UITableViewCell {
    return UITableViewCell()
  }
  class func cell(text: String?, font: UIFont? = nil, using tableView: UITableView, at indexPath: IndexPath, selectionHandler: ((IndexPath) -> ())? = nil) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCell(withIdentifier: BasicTableViewCell.identifer, for: indexPath) as? BasicTableViewCell {
      cell.indexPath = indexPath
      cell.textLabel?.text = text
      cell.textLabel?.font = font ?? cell.textLabel?.font
      cell.didSelectCellHandler = selectionHandler
      return cell
    }
    return .empty
  }
}

extension UITableView {
  func registerBasicTableViewCell() {
    self.register(BasicTableViewCell.self, forCellReuseIdentifier: BasicTableViewCell.identifer)
  }
}

class BasicTextField: UITextField {
  var alternateTextSelectionHandler: ((((String?) -> ())?) -> ())?
  var shouldBeginEditing: ((((Bool) -> ())?) -> ())?
  var didChangeTextHandler: ((String?) -> ())?
  var shouldReturnHandler: (() -> (Bool))?
  fileprivate var bypassFirstResponderCheck = false
  fileprivate static let resignFirstResponderSignal = Signal<()>()
  deinit {
    BasicTextField.resignFirstResponderSignal.cancelSubscription(for: self)
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
  var placeholderString: String? {
    get {
      return self.attributedPlaceholder?.string
    } set(new) {
      guard let new = new else { return }
      self.attributedPlaceholder = NSAttributedString(string: new, attributes: [
        NSFontAttributeName: self.font ?? UIFont.systemFont(ofSize: 11),
        NSForegroundColorAttributeName: UIColor.black.withAlphaComponent(0.4)
      ])
    }
  }
  func setup() {
    autocorrectionType = .no
    autocapitalizationType = .words
    delegate = self
    BasicTextField.resignFirstResponderSignal.subscribe(on: self) { [weak self] in
      self?.resignFirstResponder()
    }
  }
  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    if shouldReturnHandler == nil { resignFirstResponder() }
    return shouldReturnHandler?() ?? true
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

class BasicLabel: UILabel {
  var heightConstraint: NSLayoutConstraint?
  var widthConstraint: NSLayoutConstraint?
  private var maxWidth: CGFloat = .greatestFiniteMagnitude
  private var maxHeight: CGFloat = .greatestFiniteMagnitude
  override var text: String? {
    didSet {
      DispatchQueue.main.async { [weak self] in
        if let width = self?.textWidth(), let maxWidth = self?.maxWidth {
          self?.widthConstraint?.constant = min(width, maxWidth)
        }
        if let height = self?.textHeight(), let maxHeight = self?.maxHeight {
          self?.heightConstraint?.constant = min(height, maxHeight)
        }
      }
    }
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
  override var font: UIFont! {
    didSet {
      
    }
  }
  func setup() {
  }
  func textWidth() -> CGFloat {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: self.frame.height))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = self.font.withSize(adjustedFontSize())
    label.text = self.text
    label.sizeToFit()
    return label.frame.width
  }
  func textHeight() -> CGFloat {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: .greatestFiniteMagnitude))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = self.font.withSize(adjustedFontSize())
    label.text = self.text
    label.sizeToFit()
    return label.frame.height
  }
  func adjustedFontSize() -> CGFloat {
    if let attributedText = self.attributedText {
      let text = NSMutableAttributedString(attributedString: attributedText)
      text.setAttributes([NSFontAttributeName: self.font], range: NSMakeRange(0, text.length))
      let context: NSStringDrawingContext = NSStringDrawingContext()
      context.minimumScaleFactor = self.minimumScaleFactor
      text.boundingRect(with: self.frame.size, options: .usesLineFragmentOrigin, context: context)
      let adjustedFontSize: CGFloat = self.font.pointSize * context.actualScaleFactor
      return adjustedFontSize
    }
    return font.pointSize
  }
  @discardableResult
  func autoresize(width: CGFloat, max: CGFloat = .greatestFiniteMagnitude) -> Self {
    return self.width(width) { [weak self] (constraint) in
      self?.maxWidth = max
      self?.widthConstraint = constraint
      self?.text = self?.text
    }
  }
  @discardableResult
  func autoresize(height: CGFloat, max: CGFloat = .greatestFiniteMagnitude) -> Self {
    return self.height (height) { [weak self] (constraint) in
      self?.maxHeight = max
      self?.heightConstraint = constraint
      self?.text = self?.text
    }
  }
}

class BasicButton: UIButton {
  var didTapHandler: (() -> ())?
  var widthConstraint: NSLayoutConstraint?
  override func setTitle(_ title: String?, for state: UIControlState) {
    super.setTitle(title, for: state)
    self.widthConstraint?.constant = textWidth()
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
    addTarget(self, action: #selector(self.didTap), for: .touchUpInside)
    titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
  }
  func didTap() {
    didTapHandler?()
  }
  func textWidth() -> CGFloat {
    let label: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: .greatestFiniteMagnitude, height: self.frame.height))
    label.numberOfLines = 0
    label.lineBreakMode = .byWordWrapping
    label.font = self.titleLabel?.font
    label.text = self.titleLabel?.text
    label.sizeToFit()
    return label.frame.width
  }
  @discardableResult
  func autoresize(width: CGFloat) -> Self {
    return self.width(width) { [weak self] (constraint) in
      self?.widthConstraint = constraint
      self?.setTitle(self?.titleLabel?.text, for: .normal)
    }
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

