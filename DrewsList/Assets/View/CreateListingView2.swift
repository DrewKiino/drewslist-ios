//
//  CreateListingView.swift
//  DrewsList
//
//  Created by Steven Yang on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Neon
import UIKit
import TextFieldEffects
import Signals


public enum ForToggle {
  case Wishlist
  case Selling
  func name() -> String {
    switch self {
    case .Wishlist:
      return "Wishlist"
    case .Selling:
      return "Selling"
    }
  }
}

public enum CoverToggle {
  case Hardcover
  case Paperback
  func name() -> String {
    switch self {
    case .Hardcover:
      return "Hardcover"
    case .Paperback:
      return "Paperback"
    }
  }
}

public class CreateListingView2 : UIViewController, UITextFieldDelegate {
  
  // MARK: Properties
  
  private let controller = CreateListingController()
  private let bookController = BookController()
  private var model: CreateListingModel { get { return controller.getModel() } }
  
  // Navigation Header Views
  private var headerView: UIView?
  private var cancelButton: UIButton?
  private var saveButton: UIButton?
  private var headerTitle: UILabel?
  
  // Scroll Views
  private var scrollViewOriginalFrame: CGRect?
  private var scrollView: UIScrollView?
  private var bookView: BookView?
  private var bookDetailsLabel: UILabel?
  private var containerView: UIView?

  // 'For' Detail
  private var forListLabel: UILabel?
  private var forListToggleContainer: UIView?
  // 'For' Toggle Buttons
  private var wishlist: UIButton?
  private var selling: UIButton?
  private var forSelector: UIView?
  private var forToggle: ForToggle = .Wishlist // setting default
  
  // 'Cover' Detail
  private var coverLabel: UILabel?
  private var coverToggleContainer: UIView?
  // 'Cover' Toggle Buttons
  private var hardcover: UIButton?
  private var paperback: UIButton?
  private var coverSelector: UIView?
  private var coverToggle: CoverToggle = .Hardcover
  
  // 'Condition' Detail
  private var conditionLabel: UILabel?
  private var condtitionLabelPadding: UIView?
  // 'Condition' Slider
  private var conditionSlider: UISlider?
  private var conditionImageViewSelector: UIImageView?
  
  // Text Fields
  private var priceTextField: HoshiTextField?
//  var textField_Notes: IsaoTextField?
  
  private var textViewNotes: UITextView?
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
   
  }
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK: Setups
    setupSelf()
    setupDataBinding()
    setupHeaderView()
    setupScrollView()
    setupBookView()
    setupContainerView()
    setupBookDetailsLabel()
    setupForListViews()
    setupCoverViews()
    setupConditionViews()
    setupPriceTextField()
   
    // MARK: Mock Nav Header Views
    headerView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
    headerTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
    cancelButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
    saveButton?.anchorInCorner(.BottomRight, xPad: 8, yPad: 8, width: 64, height: 24)
    
    // MARK: Book Details View
    scrollView?.alignAndFill(align: .UnderCentered, relativeTo: headerView!, padding: 0)
    scrollView?.contentSize = CGSizeMake(scrollView!.width, scrollView!.height + 300)
    bookView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 150)

    containerView?.alignAndFill(align: .UnderCentered, relativeTo: bookView!, padding: 8)
    bookDetailsLabel?.anchorAndFillEdge(.Top, xPad: 8, yPad: 0, otherSize: 12)
    
    // MARK: 'For' Views
    forListLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: bookDetailsLabel!, padding: 8, height: 16)
    forListToggleContainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: forListLabel!, padding: 8, height: 36)
    forListToggleContainer?.groupAndFill(group: .Horizontal, views: [wishlist!, selling!], padding: 0)
    // set the wishlist as the default selection
    forSelector?.frame = wishlist!.frame
    
    // MARK: 'Cover' Views
    coverLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: forListToggleContainer!, padding: 8, height: 16)
    coverToggleContainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: coverLabel!, padding: 8, height: 36)
    coverToggleContainer?.groupAndFill(group: .Horizontal, views: [hardcover!, paperback!], padding: 0)
    // set the hardcover as the default selection
    coverSelector?.frame = hardcover!.frame
    
    // MARK: 'Condition' Views
    conditionLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: coverToggleContainer!, padding: 8, height: 16)
    condtitionLabelPadding?.alignAndFillWidth(align: .UnderCentered, relativeTo: conditionLabel!, padding: 0, height: 24)
    conditionSlider?.alignAndFillWidth(align: .UnderCentered, relativeTo: condtitionLabelPadding!, padding: 8, height: 36)
    
    // set the condition selector to the middle condition
    conditionImageViewSelector?.frame = CGRectMake(
      (conditionLabel!.frame.width / 2) - 4,
      conditionLabel!.frame.origin.y + 20,
      24,
      24
    )
    
    priceTextField?.alignAndFillWidth(align: .UnderCentered, relativeTo: conditionSlider!, padding: 8, height: 48)
    
    scrollViewOriginalFrame = scrollView?.frame
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    conditionImageViewSelector?.image = Toucan(image: UIImage(named: "Icon-Condition2")).resize(CGSize(width: 24, height: 24)).image
  }
   
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillAppear:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillDisappear:", name: UIKeyboardWillHideNotification, object: nil)
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
    saveButton?.setTitle("Save", forState: .Normal)
    saveButton?.titleLabel?.font = UIFont.asapRegular(16)
    saveButton?.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
    headerView?.addSubview(saveButton!)
  }
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView?.backgroundColor = .whiteColor()
    scrollView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    view.addSubview(scrollView!)
  }
  
  private func setupBookView() {
    bookView = BookView()
    bookView?.setBook(model.book)
    scrollView?.addSubview(bookView!)
  }
  
  private func setupContainerView() {
    containerView = UIView()
    containerView?.backgroundColor = .whiteColor()
    scrollView?.addSubview(containerView!)
  }
  
  private func setupBookDetailsLabel() {
    bookDetailsLabel = UILabel()
    bookDetailsLabel?.text = "List Details:"
    bookDetailsLabel?.font = UIFont.asapBold(12)
    bookDetailsLabel?.textColor = .blackColor()
    containerView?.addSubview(bookDetailsLabel!)
  }
  
  private func setupForListViews() {
    forListLabel = UILabel()
    forListLabel?.text = "For"
    forListLabel?.font = UIFont.asapBold(16)
    forListLabel?.textColor = .sexyGray()
    containerView?.addSubview(forListLabel!)
    
    forListToggleContainer = UIView()
    forListToggleContainer?.backgroundColor = .whiteColor()
    containerView?.addSubview(forListToggleContainer!)
    
    forSelector = UIView()
    forSelector?.backgroundColor = .sweetBeige()
    forSelector?.layer.cornerRadius = 8.0
    forListToggleContainer?.addSubview(forSelector!)
    
    wishlist = UIButton()
    wishlist?.setTitle("My Wish List", forState: .Normal)
    wishlist?.setTitleColor(.blackColor(), forState: .Normal)
    wishlist?.addTarget(self, action: "selectedWishList", forControlEvents: .TouchUpInside)
    wishlist?.backgroundColor = .clearColor()
    wishlist?.titleLabel?.font = UIFont.asapRegular(16)
    forListToggleContainer?.addSubview(wishlist!)
    
    selling = UIButton()
    selling?.setTitle("My Sale List", forState: .Normal)
    selling?.setTitleColor(.blackColor(), forState: .Normal)
    selling?.addTarget(self, action: "selectedSaleList", forControlEvents: .TouchUpInside)
    selling?.backgroundColor = .clearColor()
    selling?.titleLabel?.font = UIFont.asapRegular(16)
    forListToggleContainer?.addSubview(selling!)
  }
  
  private func setupCoverViews() {
    coverLabel = UILabel()
    coverLabel?.text = "Cover"
    coverLabel?.font = UIFont.asapBold(16)
    coverLabel?.textColor = .sexyGray()
    containerView?.addSubview(coverLabel!)
    
    coverToggleContainer = UIView()
    coverToggleContainer?.backgroundColor = .whiteColor()
    containerView?.addSubview(coverToggleContainer!)
    
    coverSelector = UIView()
    coverSelector?.backgroundColor = .sweetBeige()
    coverSelector?.layer.cornerRadius = 8.0
    coverToggleContainer?.addSubview(coverSelector!)
    
    hardcover = UIButton()
    hardcover?.setTitle("Hardcover", forState: .Normal)
    hardcover?.setTitleColor(.blackColor(), forState: .Normal)
    hardcover?.addTarget(self, action: "selectedHardcover", forControlEvents: .TouchUpInside)
    hardcover?.backgroundColor = .clearColor()
    hardcover?.titleLabel?.font = UIFont.asapRegular(16)
    coverToggleContainer?.addSubview(hardcover!)
    
    paperback = UIButton()
    paperback?.setTitle("Paperback", forState: .Normal)
    paperback?.setTitleColor(.blackColor(), forState: .Normal)
    paperback?.addTarget(self, action: "selectedPaperback", forControlEvents: .TouchUpInside)
    paperback?.backgroundColor = .clearColor()
    paperback?.titleLabel?.font = UIFont.asapRegular(16)
    coverToggleContainer?.addSubview(paperback!)
  }
  
  private func setupConditionViews() {
    conditionLabel = UILabel()
    conditionLabel?.text = "Condition"
    conditionLabel?.font = UIFont.asapBold(16)
    conditionLabel?.textColor = .sexyGray()
    containerView?.addSubview(conditionLabel!)
    
    condtitionLabelPadding = UIView()
    containerView?.addSubview(condtitionLabelPadding!)
    
    conditionSlider = UISlider()
    conditionSlider?.minimumValue = 1
    conditionSlider?.maximumValue = 3
    conditionSlider?.value = 2
    conditionSlider?.tintColor = .sexyGray()
    conditionSlider?.continuous = true
    conditionSlider?.addTarget(self, action: "sliderDidChange:", forControlEvents: .ValueChanged)
    containerView?.addSubview(conditionSlider!)
    
    conditionImageViewSelector = UIImageView()
    containerView?.addSubview(conditionImageViewSelector!)
  }
  
  private func setupDataBinding() {
    model._book.removeAllListeners()
    model._book.listen(self) { [weak self] book in
      self?.bookView?.setBook(book)
    }
  }
  
  private func setupPriceTextField() {
    priceTextField = HoshiTextField()
    priceTextField?.borderInactiveColor = UIColor.bareBlue()
    priceTextField?.borderActiveColor = UIColor.juicyOrange()
    priceTextField?.placeholderColor = UIColor.sexyGray()
    priceTextField?.placeholder = "Price"
    priceTextField?.delegate = self
    priceTextField?.tag = 10
    containerView?.addSubview(priceTextField!)
  }
  
  // MARK: Class Functions
  
  public func dismissKeyboard() {
    priceTextField?.resignFirstResponder()
  }
  
  public func setBook(book: Book?) -> Self {
    model.book = book
    return self
  }
  
  public func selectedWishList() {
    forToggle = .Wishlist
    toggleFor()
  }
  
  public func selectedSaleList() {
    forToggle = .Selling
    toggleFor()
  }
  
  private func toggleFor() {
    
    let duration: NSTimeInterval = 0.7
    let damping: CGFloat = 0.5
    let velocity: CGFloat = 1.0
    
    switch forToggle {
    case .Wishlist:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        if let frame = self?.wishlist?.frame { self?.forSelector?.frame = frame }
      }, completion: { bool in
      })
      break
    case .Selling:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        if let frame = self?.selling?.frame { self?.forSelector?.frame = frame }
      }, completion: { bool in
      })
      break
    }
  }
  
  
  public func selectedHardcover() {
    coverToggle = .Hardcover
    toggleCover()
  }
  
  public func selectedPaperback() {
    coverToggle = .Paperback
    toggleCover()
  }
  
  private func toggleCover() {
    
    let duration: NSTimeInterval = 0.7
    let damping: CGFloat = 0.5
    let velocity: CGFloat = 1.0
    
    switch coverToggle {
    case .Hardcover:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        if let frame = self?.hardcover?.frame { self?.coverSelector?.frame = frame }
      }, completion: { bool in
      })
      break
    case .Paperback:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        if let frame = self?.paperback?.frame { self?.coverSelector?.frame = frame }
      }, completion: { bool in
      })
      break
    }
  }
  
  public func sliderDidChange(sender: UISlider!) {
    
    let duration: NSTimeInterval = 0.7
    let damping: CGFloat = 0.5
    let velocity: CGFloat = 1.0

    switch sender.value {
    case let x where x < 1.5:
      conditionSlider?.setValue(1, animated: false)
      conditionImageViewSelector?.image = Toucan(image: UIImage(named: "Icon-Condition1")).resize(CGSize(width: 24, height: 24)).image
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        self?.conditionImageViewSelector?.frame = CGRectMake(
          self!.conditionLabel!.frame.origin.x + 3,
          self!.conditionLabel!.frame.origin.y + 20,
          24,
          24
        )
      }, completion: { bool in
      })
      break
    case let x where x >= 1.5 && x <= 2.5:
      conditionSlider?.setValue(2, animated: false)
      conditionImageViewSelector?.image = Toucan(image: UIImage(named: "Icon-Condition2")).resize(CGSize(width: 24, height: 24)).image
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        self?.conditionImageViewSelector?.frame = CGRectMake(
          (self!.conditionLabel!.frame.width / 2) - 4,
          self!.conditionLabel!.frame.origin.y + 20,
          24,
          24
        )
      }, completion: { bool in
      })
      break
    case let x where x > 2.0 && x <= 3:
      conditionSlider?.setValue(3, animated: false)
      conditionImageViewSelector?.image = Toucan(image: UIImage(named: "Icon-Condition3")).resize(CGSize(width: 24, height: 24)).image
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        self?.conditionImageViewSelector?.frame = CGRectMake(
          (self!.conditionLabel!.frame.width) - 17,
          self!.conditionLabel!.frame.origin.y + 20,
          24,
          24
        )
      }, completion: { bool in
      })
      break
    default: break
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
  
  public func save() {
    controller.saveListingToServer()
  }
  
  public func keyboardWillAppear(notification: NSNotification) {
//    guard let keyboardInfo = notification.userInfo,
//          let frame = scrollViewOriginalFrame,
//          let keyboardFrame = scrollView?.window!.convertRect(keyboardInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue, toView: scrollView!.superview!)
//    else { return }
  }
  
  public func keyboardWillDisappear(notification: NSNotification) {
//    guard let keyboardInfo = notification.userInfo,
//      let frame = scrollViewOriginalFrame,
//      let keyboardFrame = scrollView?.window!.convertRect(keyboardInfo[UIKeyboardFrameEndUserInfoKey]!.CGRectValue, toView: scrollView!.superview!)
//    else { return }
  }
  
  // MARK: UITextField Delegates
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    // price textfield
    if textField.tag == 10 { scrollView?.setContentOffset(CGPointMake(0, textField.frame.origin.y), animated: true) }
  }
  
  public func textFieldDidEndEditing(textField: UITextField) {
  }
}





