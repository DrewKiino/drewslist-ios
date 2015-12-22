//
//  CreateListingView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/21/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals
import TextFieldEffects
import KMPlaceholderTextView

public class CreateListingView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = CreateListingController()
  private var model: CreateListingModel { get { return controller.getModel() } }
  
  private var tableView: DLTableView?
  
  // MARK: View Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupTableView()
    
    tableView?.fillSuperview()
  }
  
  // MARK: Setup Functions
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupDataBinding() {
    model._book.removeAllListeners()
    model._book.listen(self) { [weak self] book in
      self?.tableView?.reloadData()
    }
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 1, 3, 5, 7: return 24
    case 2: return 168
    case 10: return 400
    default: return 48
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 11
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.font = .asapBold(16)
        cell.paddingLabel?.text = "Listing Details"
        cell.hideBothTopAndBottomBorders()
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Book"
        cell.hideTopBorder()
        cell.alignTextLeft()
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        cell.setBook(model.book)
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "For"
        cell.alignTextLeft()
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell", forIndexPath: indexPath) as? ToggleCell {
        cell.leftToggleButton?.setTitle("My Wish List", forState: .Normal)
        cell.rightToggleButton?.setTitle("My Sale List", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { toggle in
//          log.debug(toggle.getValue())
        }
        cell.hideTopBorder()
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Cover"
        cell.alignTextLeft()
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell", forIndexPath: indexPath) as? ToggleCell {
        cell.leftToggleButton?.setTitle("Hardcover", forState: .Normal)
        cell.rightToggleButton?.setTitle("Paperback", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { toggle in
//          log.debug(toggle.getValue())
        }
        return cell
      }
      break
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Information"
        cell.alignTextLeft()
        return cell
      }
      break
    case 8:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
        cell.inputTextField?.placeholder = "Price"
        cell.inputTextField?.keyboardType = .DecimalPad
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) { [weak self] bool in
          if let cell = self?.tableView?.cellForRowAtIndexPath(indexPath) where bool {
            self?.tableView?.setContentOffset(CGPointMake(0, screen.height - cell.frame.origin.y + 128), animated: true)
          }
        }
        return cell
      }
      break
    case 9:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextViewCell", forIndexPath: indexPath) as? InputTextViewCell {
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) { [weak self] bool in
          if let cell = self?.tableView?.cellForRowAtIndexPath(indexPath) where bool {
            self?.tableView?.setContentOffset(CGPointMake(0, screen.height - cell.frame.origin.y + 128), animated: true)
          }
        }
        return cell
      }
      break
    case 10:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBottomBorder()
        return cell
      }
      break
    default: break
    }
    
    return UITableViewCell()
  }
  
  
  // MARK: Class Functions
  
  public func setBook(book: Book?) -> Self {
    model.book = book
    return self
  }
}

public class ToggleCell: DLTableViewCell {
  
  public enum Toggle {
    case Left
    case Right
    public func getValue() -> Bool {
      switch self {
      case .Left: return true
      case .Right: return false
      }
    }
  }
  
  private var leftToggleButton: UIButton?
  private var rightToggleButton: UIButton?
  private var toggleSelector: UIView?
  private var toggleContainer: UIView?
  private var toggle: Toggle = .Left// setting default
  private var isDragging: Bool = false
  private var isDraggingTimer: NSTimer?
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupToggleViews()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    toggleContainer?.fillSuperview()
    toggleContainer?.groupAndFill(group: .Horizontal, views: [leftToggleButton!, rightToggleButton!], padding: 8)
    
    toggleSelector?.frame = leftToggleButton!.frame
  }
  
  private func setupSelf() {
    backgroundColor = .whiteColor()
    hideBothTopAndBottomBorders()
  }
  
  private func setupToggleViews() {
    toggleContainer = UIView()
    toggleContainer?.backgroundColor = .whiteColor()
    toggleContainer?.multipleTouchEnabled = true
    addSubview(toggleContainer!)
    
    toggleSelector = UIView()
    toggleSelector?.backgroundColor = .sweetBeige()
    toggleSelector?.layer.cornerRadius = 8.0
    toggleContainer?.addSubview(toggleSelector!)
    
    let press = UILongPressGestureRecognizer(target: self, action: "dragSelector:")
    press.minimumPressDuration = 0.01
    
    toggleContainer?.addGestureRecognizer(press)
    
    leftToggleButton = UIButton()
    leftToggleButton?.setTitle("My Wish List", forState: .Normal)
    leftToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    leftToggleButton?.addTarget(self, action: "selectLeft", forControlEvents: .TouchUpInside)
    leftToggleButton?.backgroundColor = .clearColor()
    leftToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(leftToggleButton!)
    
    rightToggleButton = UIButton()
    rightToggleButton?.setTitle("My Sale List", forState: .Normal)
    rightToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    rightToggleButton?.addTarget(self, action: "selectRight", forControlEvents: .TouchUpInside)
    rightToggleButton?.backgroundColor = .clearColor()
    rightToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(rightToggleButton!)
  }
  
  public func dragSelector(sender: UILongPressGestureRecognizer) {
    if (sender.state == .Began) {
      
    } else if (sender.state == .Ended){
      snapToToggle(sender.locationInView(self))
    } else  if pointInside(sender.locationInView(self), withEvent: nil),
            let selector = toggleSelector,
            let leftLimit = leftToggleButton?.center.x,
            let rightLimit = rightToggleButton?.center.x
    {
      
      let newCenter = selector.center.x - (selector.center.x - sender.locationInView(self).x)
      
      if newCenter > leftLimit && newCenter < rightLimit {
        UIView.animate({ [unowned selector] in selector.center.x = newCenter })
      }
    }
  }
  
  private func snapToToggle(senderLocation: CGPoint) {
    if  let selector = toggleSelector,
        let leftToggleButton = leftToggleButton,
        let rightToggleButton = rightToggleButton
    {
      if CGRectContainsPoint(leftToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = leftToggleButton.center.x })
        toggle = .Left
      } else if CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = rightToggleButton.center.x })
        toggle = .Right
      } else {
        UIView.animate({ [unowned selector] in selector.center.x = leftToggleButton.center.x })
        toggle = .Left
      }
    }
    
    _didSelectCell => toggle
  }

  public func selectLeft() {
    toggle = .Left
    animateToggle()
  }
  
  public func selectRight() {
    toggle = .Right
    animateToggle()
  }
  
  public func toggleSelect() {
    if toggle == .Left { toggle = .Right}
    else if toggle == .Right { toggle = .Left }
    animateToggle()
  }
  
  public func animateToggle() {
    switch toggle {
    case .Left:
      UIView.animate ({ [weak self] in
        if let frame = self?.leftToggleButton?.frame { self?.toggleSelector?.frame = frame }
      })
      break
    case .Right:
      UIView.animate ({ [weak self] in
        if let frame = self?.rightToggleButton?.frame { self?.toggleSelector?.frame = frame }
      })
      break
    }
    
    _didSelectCell => toggle
  }
}

public class InputTextFieldCell: DLTableViewCell, UITextFieldDelegate {
  
  private let separatorLine = CALayer()
  
  public var inputTextField: HoshiTextField?
  
  public let _isFirstResponder = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupInputTextField()
    
    inputTextField?.fillSuperview(left: 14, right: 14, top: 2, bottom: 2)
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    hideBothTopAndBottomBorders()
  }
  
  private func setupSelf() {
    backgroundColor = .whiteColor()
  }
  
  private func setupInputTextField() {
    inputTextField = HoshiTextField()
    inputTextField?.textColor = .blackColor()
    inputTextField?.font = .asapRegular(16)
    inputTextField?.borderInactiveColor = UIColor.tableViewNativeSeparatorColor()
    inputTextField?.borderActiveColor = UIColor.sweetBeige()
    inputTextField?.placeholderColor = UIColor.sexyGray()
    inputTextField?.delegate = self
    addSubview(inputTextField!)
  }
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    _isFirstResponder => true
  }
  
  public func textFieldDidEndEditing(textField: UITextField) {
    _isFirstResponder => false
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    inputTextField?.resignFirstResponder()
    
    return true
  }
}

public class InputTextViewCell: DLTableViewCell, UITextFieldDelegate {
  
  private let separatorLine = CALayer()
  
  public var inputTextView: KMPlaceholderTextView?
  
  public let _isFirstResponder = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupInputTextView()
    
    inputTextView?.fillSuperview(left: 14, right: 14, top: 2, bottom: 2)
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  private func setupSelf() {
    backgroundColor = .whiteColor()
    hideBothTopAndBottomBorders()
  }
  
  private func setupInputTextView() {
    
  }
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    _isFirstResponder => true
  }
  
  public func textFieldDidEndEditing(textField: UITextField) {
    _isFirstResponder => false
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    inputTextView?.resignFirstResponder()
    
    return true
  }
}