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
import SwiftyButton

public class CreateListingView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = CreateListingController()
  private var model: CreateListingModel { get { return controller.getModel() } }
  
  // Navigation Header Views
  private var headerView: UIView?
  private var cancelButton: UIButton?
  private var saveButton: UIButton?
  private var headerTitle: UILabel?
  
  private var tableView: DLTableView?
  
  // MARK: View Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupHeaderView()
    setupTableView()
    
    headerView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
    headerTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
    cancelButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
    saveButton?.anchorInCorner(.BottomRight, xPad: 8, yPad: 8, width: 64, height: 24)
    
    tableView?.alignAndFill(align: .UnderCentered, relativeTo: headerView!, padding: 0)
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
    
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
      // dismiss keyboard
      self?.tableView?.resignFirstResponder()
      // hide header buttons
      self?.hideHeaderButtons()
      // show loading screen
      if bool == true { self?.view.showLoadingScreen() }
      else if bool == false { self?.view.hideLoadingScreen() }
    }
    
    model._serverCallbackFromUploadListing.removeAllListeners()
    model._serverCallbackFromUploadListing.listen(self) { [weak self] bool in
      // show header buttons
      self?.showHeaderButtons()
      // hide loading screen
      self?.view.hideLoadingScreen()
      // dismiss feed and present listing feed if callback was good
      if bool == true { self?.dismissAndPresentListingFeed() }
    }
  }
  
  private func setupHeaderView() {
    headerView = UIView()
    headerView?.backgroundColor = .soothingBlue()
    view.addSubview(headerView!)
    
    headerTitle = UILabel()
    headerTitle?.text = "Create A Listing"
    headerTitle?.textAlignment = .Center
    headerTitle?.font = UIFont.asapBold(16)
    headerTitle?.textColor = .whiteColor()
    headerView?.addSubview(headerTitle!)
    
    cancelButton = UIButton()
    cancelButton?.setTitle("Cancel", forState: .Normal)
    cancelButton?.titleLabel?.font = UIFont.asapRegular(16)
    cancelButton?.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
    headerView?.addSubview(cancelButton!)
    
    saveButton = UIButton()
    saveButton?.setTitle("Upload", forState: .Normal)
    saveButton?.titleLabel?.font = UIFont.asapRegular(16)
    saveButton?.addTarget(self, action: "upload", forControlEvents: .TouchUpInside)
    headerView?.addSubview(saveButton!)
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
    case 0, 2, 4, 6, 9: return 24
    case 1: return 168
    case 7: return screen.height / 15
    case 8: return 40
    case 11: return 150
    case 14: return 400
    default: return 48
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 14
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
//    case 0:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
//        cell.paddingLabel?.font = .asapBold(16)
//        cell.paddingLabel?.text = "Listing Details"
//        cell.hideBothTopAndBottomBorders()
//        return cell
//      }
//      break
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Book"
        cell.hideTopBorder()
        cell.showBottomBorder()
        cell.alignTextLeft()
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        cell.setBook(model.book)
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "For"
        cell.alignTextLeft()
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell", forIndexPath: indexPath) as? ToggleCell {
        cell.leftToggleButton?.setTitle("My Wish List", forState: .Normal)
        cell.rightToggleButton?.setTitle("My Sale List", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] toggle in
          switch toggle {
          case .Left:
            self?.model.listing?.listType = "buying"
            return
          case .Right:
            self?.model.listing?.listType = "selling"
            return
          }
        }
        cell.hideTopBorder()
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Cover"
        cell.alignTextLeft()
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell", forIndexPath: indexPath) as? ToggleCell {
        cell.leftToggleButton?.setTitle("Hardcover", forState: .Normal)
        cell.rightToggleButton?.setTitle("Paperback", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] toggle in
          switch toggle {
          case .Left:
            self?.model.listing?.cover = "hardcover"
            return
          case .Right:
            self?.model.listing?.cover = "paperback"
            return
          }
        }
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Condition"
        cell.alignTextLeft()
        return cell
      }
      break
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as? SliderCell {
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] toggle in
          switch toggle {
          case .left:
            print("1")
            self?.model.listing?.condition = "1"
            return
          case .middle:
            print("2")
            self?.model.listing?.condition = "2"
            return
          case .right:
            print("3")
            self?.model.listing?.condition = "3"
            return
          }
        }
        return cell
      }
      break
    case 8:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.alignTextLeft()
        cell.hideBothTopAndBottomBorders()
        return cell
      }
      break
    case 9:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Information"
        cell.alignTextLeft()
        return cell
      }
      break
    case 10:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
        cell.inputTextField?.placeholder = "Price"
        cell.inputTextField?.keyboardType = .DecimalPad
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) { [weak self] bool in
          if let cell = self?.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0)) {
            self?.tableView?.setContentOffset(CGPointMake(0, cell.frame.origin.y), animated: true)
          }
        }
        cell._inputTextFieldString.removeAllListeners()
        cell._inputTextFieldString.listen(self) { [weak self] text in
          self?.model.listing?.price = text
        }
        return cell
      }
      break
    case 11:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextViewCell", forIndexPath: indexPath) as? InputTextViewCell {
        cell.titleLabel?.text = "Notes"
        cell.inputTextView?.placeholder = "Want to buy or sell this book as soon as possible? Write your pitch here! Tell future users why you are listing this book. Keep it clean please ;)"
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) { [weak self] bool in
          if let cell = self?.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0)) {
            self?.tableView?.setContentOffset(CGPointMake(0, cell.frame.origin.y), animated: true)
          }
        }
        cell._inputTextViewString.removeAllListeners()
        cell._inputTextViewString.listen(self) { [weak self] text in
          self?.model.listing?.notes = text
        }
        return cell
      }
      break
    case 12:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.buttonLabel?.text = "Upload Listing"
        cell._onPressed.removeAllListeners()
        cell._onPressed.listen(self) { [weak self] bool in self?.controller.uploadListingToServer() }
        return cell
      }
      break
    case 14:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.showTopBorder()
        cell.hideBottomBorder()
        cell.paddingLabel?.text = ""
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
  
  public func dismissAndPresentListingFeed() {
    if  let tabView = presentingViewController as? TabView,
        let scannerView = (tabView.viewControllers?.filter { $0 is ScannerView })?.first as? ScannerView,
        let communityFeedView = (tabView.viewControllers?.filter { $0 is CommunityFeedView })?.first as? CommunityFeedView
    {
      // dismiss view and go back to scanner view
      scannerView.dismissViewControllerAnimated(false) { [weak self, weak scannerView, weak tabView, weak communityFeedView] in
        // setup scanner view to start new session
        scannerView?.previewLayer?.hidden = false
        scannerView?.session?.startRunning()
        tabView?.selectedIndex = 0
        communityFeedView?.selectMiddlePage()
        if self?.model.listing?.listType == "buying" {
          communityFeedView?.middlePage?.selectLeftPage()
          communityFeedView?.middlePage?.getListingsFromServer(0, listing: "buying")
        } else if self?.model.listing?.listType == "selling" {
          communityFeedView?.middlePage?.selectRightPage()
          communityFeedView?.middlePage?.getListingsFromServer(0, listing: "selling")
        }
      }
    }
  }
  
  public func cancel() {
    if let tabView = presentingViewController as? TabView, let scannerView = (tabView.viewControllers?.filter { $0 is ScannerView })?.first as? ScannerView {
      scannerView.dismissViewControllerAnimated(true) { [weak scannerView] in
        scannerView?.previewLayer?.hidden = false
        scannerView?.session?.startRunning()
      }
    }
  }
  
  public func upload() {
    controller.uploadListingToServer()
  }
  
  public func hideHeaderButtons() {
    cancelButton?.hidden = true
    saveButton?.hidden = true
  }
  
  public func showHeaderButtons() {
    cancelButton?.hidden = false
    saveButton?.hidden = false
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
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupToggleViews()
    
    toggleContainer?.fillSuperview()
    toggleContainer?.groupAndFill(group: .Horizontal, views: [leftToggleButton!, rightToggleButton!], padding: 8)
    
    toggleSelector?.frame = leftToggleButton!.frame
//    leftToggleButton?.setTitleColor(.whiteColor(), forState: .Normal)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  public override func setupSelf() {
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
    leftToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    leftToggleButton?.backgroundColor = .clearColor()
    leftToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(leftToggleButton!)
    
    rightToggleButton = UIButton()
    rightToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    rightToggleButton?.backgroundColor = .clearColor()
    rightToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(rightToggleButton!)
  }
  
  public func dragSelector(sender: UILongPressGestureRecognizer) {
    if (sender.state == .Began) {
    } else if (sender.state == .Ended){
      snapToToggle(sender.locationInView(self))
//      animateToggleIntersections()
    } else  if pointInside(sender.locationInView(self), withEvent: nil),
      let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let rightToggleButton = rightToggleButton
    {
      let leftLimit = leftToggleButton.center.x
      let rightLimit = rightToggleButton.center.x
      let newCenter = selector.center.x - (selector.center.x - sender.locationInView(self).x)
      
      if newCenter > leftLimit && newCenter < rightLimit {
        UIView.animate({ [unowned selector] in selector.center.x = newCenter })
      }
    }
  }
  
  private func animateToggleIntersections() {
    if  let selector = toggleSelector,
        let leftToggleButton = leftToggleButton,
        let rightToggleButton = rightToggleButton
    {
      if CGRectIntersectsRect(leftToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.setTitleColor(.whiteColor(), forState: .Normal)
          self?.rightToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
        })
      } else if CGRectIntersectsRect(rightToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
          self?.rightToggleButton?.setTitleColor(.whiteColor(), forState: .Normal)
        })
      }
    }
  }
  
  private func snapToToggle(senderLocation: CGPoint) {
    if  let selector = toggleSelector,
        let leftToggleButton = leftToggleButton,
        let rightToggleButton = rightToggleButton
    {
      if CGRectContainsPoint(leftToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in
          selector.center.x = leftToggleButton.center.x
        })
        toggle = .Left
      } else if CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in
          selector.center.x = rightToggleButton.center.x
        })
        toggle = .Right
      } else {
        UIView.animate({ [unowned selector] in
          selector.center.x = leftToggleButton.center.x
        })
        toggle = .Left
      }
      
    }
    
    _didSelectCell => toggle
  }
}

public class TripleToggleCell: DLTableViewCell {
  
  public enum Toggle {
    case Left
    case Middle
    case Right
  }
  
  private var leftToggleButton: UIButton?
  private var middleToggleButton: UIButton?
  private var rightToggleButton: UIButton?
  private var toggleSelector: UIView?
  private var toggleContainer: UIView?
  private var toggle: Toggle = .Middle // setting default
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupToggleViews()
    
    toggleContainer?.fillSuperview()
    toggleContainer?.groupAndFill(group: .Horizontal, views: [leftToggleButton!, middleToggleButton!, rightToggleButton!], padding: 8)
    
    toggleSelector?.frame = middleToggleButton!.frame
    
    leftToggleButton?.imageView?.tintColor = .juicyOrange()
    middleToggleButton?.imageView?.tintColor = .blackColor()
    rightToggleButton?.imageView?.tintColor = .juicyOrange()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    leftToggleButton?.setImage(leftToggleButton?.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
    middleToggleButton?.setImage(middleToggleButton?.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
    rightToggleButton?.setImage(rightToggleButton?.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
  }
  
  public override func setupSelf() {
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
    leftToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    leftToggleButton?.backgroundColor = .clearColor()
    leftToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(leftToggleButton!)
    
    middleToggleButton = UIButton()
    middleToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    middleToggleButton?.backgroundColor = .clearColor()
    middleToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(middleToggleButton!)
    
    rightToggleButton = UIButton()
    rightToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    rightToggleButton?.backgroundColor = .clearColor()
    rightToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(rightToggleButton!)
  }
  
  public func dragSelector(sender: UILongPressGestureRecognizer) {
    if (sender.state == .Began) {
    } else if (sender.state == .Ended){
      snapToToggle(sender.locationInView(self))
      animateToggleIntersections(sender.locationInView(self))
    } else  if pointInside(sender.locationInView(self), withEvent: nil),
      let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let rightToggleButton = rightToggleButton
    {
      let leftLimit = leftToggleButton.center.x
      let rightLimit = rightToggleButton.center.x
      let newCenter = selector.center.x - (selector.center.x - sender.locationInView(self).x)
      
      if newCenter > leftLimit && newCenter < rightLimit {
        UIView.animate({ [unowned selector] in selector.center.x = newCenter })
      }
    }
  }
  
  private func animateToggleIntersections(senderLocation: CGPoint) {
    if  let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let middleToggleButton = middleToggleButton,
      let rightToggleButton = rightToggleButton
    {
      if CGRectIntersectsRect(leftToggleButton.frame, selector.frame) || CGRectContainsPoint(leftToggleButton.frame, senderLocation) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .blackColor()
          self?.middleToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.rightToggleButton?.imageView?.tintColor = .juicyOrange()
        })
      } else if CGRectIntersectsRect(rightToggleButton.frame, selector.frame) || CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.middleToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.rightToggleButton?.imageView?.tintColor = .blackColor()
        })
      } else if CGRectIntersectsRect(middleToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.middleToggleButton?.imageView?.tintColor = .blackColor()
          self?.rightToggleButton?.imageView?.tintColor = .juicyOrange()
        })
      }
    }
  }
  
  private func snapToToggle(senderLocation: CGPoint) {
    if  let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let middleToggleButton = middleToggleButton,
      let rightToggleButton = rightToggleButton
    {
      if CGRectContainsPoint(leftToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = leftToggleButton.center.x })
        toggle = .Left
      } else if CGRectContainsPoint(middleToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = middleToggleButton.center.x })
        toggle = .Middle
      } else if CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = rightToggleButton.center.x })
        toggle = .Right
      } else {
        UIView.animate({ [unowned selector] in selector.center.x = middleToggleButton.center.x })
        toggle = .Middle
      }
    }
    
    _didSelectCell => toggle
  }
}

public class SliderCell: DLTableViewCell {
  
  // Could add toggle to switch highlight
  public enum Toggle {
    case left
    case middle
    case right
  }
 
  private var container = UIView?()
  private var slider = UISlider?()
  private var leftFace = UIImageView?()
  private var middleFace = UIImageView?()
  private var rightFace = UIImageView?()
  private var toggle: Toggle = .middle // setting default
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.backgroundColor = .whiteColor()
    setupSlider()
    setupFaces()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    container?.anchorInCenter(width: screen.width, height: screen.height / 12)
    slider?.fillSuperview(left: 10, right: 10, top: 0, bottom: 0)
    leftFace?.anchorInCorner(.BottomLeft, xPad: 0, yPad: 0, width: 25, height: 25)
    leftFace?.align(.UnderMatchingLeft, relativeTo: slider!, padding: 0, width: 25, height: 25)
    middleFace?.anchorInCenter(width: 25, height: 25)
    middleFace?.align(.UnderCentered, relativeTo: slider!, padding: 0, width: 25, height: 25)
    rightFace?.anchorInCorner(.BottomRight, xPad: 0, yPad: 0, width: 25, height: 25)
    rightFace?.align(.UnderMatchingRight, relativeTo: slider!, padding: 0, width: 25, height: 25)
  }
  
  public func setupSlider() {
    container = UIView()
    slider = UISlider()
    slider!.minimumValue = 0
    slider!.minimumTrackTintColor = UIColor.juicyOrange()
    slider!.maximumValue = 2
    slider!.maximumTrackTintColor = UIColor.juicyOrange()
    slider!.setValue(1.0, animated: false)
    slider!.addTarget(self, action: "sliderChanged:", forControlEvents: .ValueChanged)
    container!.addSubview(slider!)
  }
  
  public func setupFaces() {
    leftFace = UIImageView(image:Toucan(image: UIImage(named: "Icon-Condition1")).image)
    leftFace?.frame = CGRect(x: 0,y: 0,width: 25,height: 25)
    container?.addSubview(leftFace!)
  
    middleFace = UIImageView(image:Toucan(image: UIImage(named: "Icon-Condition2")).image)
    middleFace?.frame = CGRect(x: 0,y: 0,width: 25,height: 25)
    container?.addSubview(middleFace!)

    rightFace = UIImageView(image:Toucan(image: UIImage(named: "Icon-Condition3")).image)
    rightFace?.frame = CGRect(x: 0,y: 0,width: 25,height: 25)
    container?.addSubview(rightFace!)
    
    addSubview(container!)
  }
  
  public func sliderChanged(sender: UISlider) {
    slider!.value = roundf(slider!.value)
    switch slider!.value {
    case 0:
      toggle = .left
      break
    case 1:
      toggle = .middle
      break
    case 2:
      toggle = .right
      break
    default:
      break
    }
    self._didSelectCell.fire(toggle)
  }
  
}

public class InputTextFieldCell: DLTableViewCell, UITextFieldDelegate {
  
  private let separatorLine = CALayer()
  
  public var inputTextField: HoshiTextField?
  
  public let _inputTextFieldString = Signal<String?>()
  
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
  
  public override func setupSelf() {
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
  
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        _inputTextFieldString.fire(NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1)))
        // else, user has inputted some new strings
      } else { _inputTextFieldString.fire(text + string) }
    }
    return true
  }
}

public class InputTextViewCell: DLTableViewCell, UITextViewDelegate {
  
  private let separatorLine = CALayer()
  
  public var titleLabel: UILabel?
  public var inputTextView: KMPlaceholderTextView?
  
  public let _inputTextViewString = Signal<String?>()
  
  public let _isFirstResponder = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupInputTextView()
    
    titleLabel?.anchorAndFillEdge(.Top, xPad: 14, yPad: 2, otherSize: 12)
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    inputTextView?.anchorAndFillEdge(.Top, xPad: 14, yPad: 16, otherSize: bounds.height - 16)
  }
  
  public override func setupSelf() {
    backgroundColor = .whiteColor()
    hideBothTopAndBottomBorders()
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel?.font = .asapRegular(10)
    titleLabel?.textColor = .sexyGray()
    addSubview(titleLabel!)
  }
  
  private func setupInputTextView() {
    inputTextView  = KMPlaceholderTextView()
    inputTextView?.font = .asapRegular(12)
    inputTextView?.placeholderColor = .sexyGray()
    inputTextView?.delegate = self
    addSubview(inputTextView!)
  }
  
  public func textViewDidBeginEditing(textView: UITextView) {
    _isFirstResponder => true
  }
  
  public func textViewDidEndEditing(textView: UITextView) {
    _isFirstResponder => false
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    inputTextView?.resignFirstResponder()
    
    return true
  }
  
  public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if let string = textView.text {
      // this means the user inputted a backspace
      if text.characters.count == 0 && string.characters.count > 0 {
        _inputTextViewString.fire(NSString(string: string).substringWithRange(NSRange(location: 0, length: string.characters.count - 1)))
        // else, user has inputted some new strings
      } else { _inputTextViewString.fire(string + text) }
    }
    return true
  }
}

public class BigButtonCell: DLTableViewCell {
  
  private var indicator: UIActivityIndicatorView?
  public var button: SwiftyCustomContentButton?
  public var buttonLabel: UILabel?
  
  public let _onPressed = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupButton()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    button?.fillSuperview(left: 14, right: 14, top: 2, bottom: 2)
    indicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
    buttonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
  }
  
  public override func setupSelf() {
    backgroundColor = .whiteColor()
  }
  
  private func setupButton() {
    
    button = SwiftyCustomContentButton()
    button?.buttonColor         = .sweetBeige()
    button?.highlightedColor    = .juicyOrange()
    button?.shadowColor         = .clearColor()
    button?.disabledButtonColor = .grayColor()
    button?.disabledShadowColor = .darkGrayColor()
    button?.shadowHeight        = 0
    button?.cornerRadius        = 8
    button?.buttonPressDepth    = 0.5 // In percentage of shadowHeight
    button?.addTarget(self, action: "pressed", forControlEvents: .TouchUpInside)
    
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    button?.customContentView.addSubview(indicator!)
    
    buttonLabel = UILabel()
    buttonLabel?.textAlignment = .Center
    buttonLabel?.textColor = UIColor.whiteColor()
    buttonLabel?.font = .asapRegular(16)
    button?.customContentView.addSubview(buttonLabel!)
    
    addSubview(button!)
  }
  
  public func pressed() {
    _onPressed => true
  }
}





















































