//
//  SearchBookView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Async

public class SearchBookView: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  private let controller = SearchBookController()
  private var model: SearchBookModel { get { return controller.model } }
  
  // Navigation Header Views
  private var headerView: UIView?
  private var cancelButton: UIButton?
  private var searchButton: UIButton?
  private var searchActivityView: UIActivityIndicatorView?
  private var headerTitle: UILabel?
  
  // Search Bar
  private var searchBarContainer: UIView?
  private var searchBarTextField: UITextField?
  private var searchBarImageView: UIImageView?
  
  //  School List
  private var tableView: DLTableView?
  private var originalTableViewFrame: CGRect?
  private var lastKeyboardFrame: CGRect?
  
  public var onDismissBlock: (() -> Void)?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupHeaderView()
    setupSearchBar()
    setupTableView()
    
    headerView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
    headerTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
    cancelButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
    searchButton?.anchorInCorner(.BottomRight, xPad: 8, yPad: 8, width: 64, height: 24)
    searchActivityView?.fillSuperview()
  
    searchBarContainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: headerView!, padding: 0, height: 36)
    searchBarTextField?.anchorAndFillEdge(.Left, xPad: 8, yPad: 8, otherSize: screen.width - 48)
    searchBarImageView?.alignAndFill(align: .ToTheRightCentered, relativeTo: searchBarTextField!, padding: 8)
    
    tableView?.alignAndFill(align: .UnderCentered, relativeTo: searchBarContainer!, padding: 0)
    originalTableViewFrame = tableView!.frame
    
    searchBarImageView?.image = Toucan(image: UIImage(named: "Icon-Search-1")).resize(searchBarImageView!.frame.size).image
    
    FBSDKController.createCustomEventForName("UserSearchBook")
  }
  
  public override func viewWillAppear(animated: Bool) {
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    searchBarTextField?.text = nil
    model.lastSearchString = nil
    model.books.removeAll(keepCapacity: false)
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    searchBarTextField?.becomeFirstResponder()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    NSNotificationCenter.defaultCenter().removeObserver(self)
    
    resignFirstResponder()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupDataBinding() {
    
    model._books.removeAllListeners()
    model._books.listen(self) { [weak self] books in
      self?.tableView?.reloadData()
    }
    
    model._book.removeAllListeners()
    model._book.listen(self) { [weak self] book in
      self?.cancel()
    }
    
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
      if bool == true {
        self?.searchButton?.userInteractionEnabled = false
        self?.searchButton?.setTitle("", forState: .Normal)
        self?.searchActivityView?.startAnimating()
      } else {
        self?.searchActivityView?.stopAnimating()
        self?.searchButton?.setTitle("Search", forState: .Normal)
        self?.searchButton?.userInteractionEnabled = true
      }
    }
  }
  
  private func setupHeaderView() {
    headerView = UIView()
    headerView?.backgroundColor = .soothingBlue()
    view.addSubview(headerView!)
    
    headerTitle = UILabel()
    headerTitle?.text = "Search Books"
    headerTitle?.textAlignment = .Center
    headerTitle?.font = UIFont.asapBold(16)
    headerTitle?.textColor = .whiteColor()
    headerView?.addSubview(headerTitle!)
    
    cancelButton = UIButton()
    cancelButton?.setTitle("Cancel", forState: .Normal)
    cancelButton?.titleLabel?.font = UIFont.asapRegular(16)
    cancelButton?.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
    headerView?.addSubview(cancelButton!)
    
    searchButton = UIButton()
    searchButton?.setTitle("Search", forState: .Normal)
    searchButton?.titleLabel?.font = UIFont.asapRegular(16)
    searchButton?.addTarget(self, action: "search", forControlEvents: .TouchUpInside)
    headerView?.addSubview(searchButton!)
    
    searchActivityView = UIActivityIndicatorView()
    searchButton?.addSubview(searchActivityView!)
  }
  
  private func setupSearchBar() {
    
    searchBarContainer = UIView()
    searchBarContainer?.backgroundColor = .soothingBlue()
    view.addSubview(searchBarContainer!)
    
    searchBarTextField = UITextField()
    searchBarTextField?.backgroundColor = .whiteColor()
    searchBarTextField?.layer.cornerRadius = 2.0
    searchBarTextField?.font = .asapRegular(16)
    searchBarTextField?.delegate = self
    searchBarTextField?.autocapitalizationType = .Words
    searchBarTextField?.spellCheckingType = .No
//    searchBarTextField?.autocorrectionType = .No
    searchBarTextField?.clearButtonMode = .Always
    searchBarContainer?.addSubview(searchBarTextField!)
    
    searchBarImageView = UIImageView()
    searchBarContainer?.addSubview(searchBarImageView!)
    
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.showsVerticalScrollIndicator = true
    view.addSubview(tableView!)
  }
  
  // MARK: Functions
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    searchBarTextField?.resignFirstResponder()
    return true
  }
  
  public func cancel() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  public func search() {
    controller.searchBook()
  }
  
  public func setOnDismiss(block: () -> Void) -> Self {
    onDismissBlock = block
    return self
  }
  
  // MARK: TextField Delegates
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        model.searchString = NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1))
        // else, user has inputted some new strings
      } else { model.searchString = text + string }
    }
    return true
  }
  
  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    controller.searchBook()
    resignFirstResponder()
    return false
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 166
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.books.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
      cell.setBook(model.books[indexPath.row])
      cell.bookView?.canShowBookProfile = false
      cell._cellPressed.removeAllListeners()
      cell._cellPressed.listen(self) { [weak self] bool in
        if bool == true {
          
          self?.model.book = self?.model.books[indexPath.row]
          
          self?.dismissViewControllerAnimated(true, completion: nil)
          
          self?.onDismissBlock?()
        }
      }
      
      return cell
    }
    return DLTableViewCell()
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    model.book = model.books[indexPath.row]
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let frame = lastKeyboardFrame where screen.height - frame.height < scrollView.panGestureRecognizer.locationInView(self.view).y {
      resignFirstResponder()
    }
  }
  
  // MARK: Keyboard observers
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(), let originalFrame = originalTableViewFrame {
      lastKeyboardFrame = keyboardFrame
      if let frame = tableView?.frame { tableView?.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, originalFrame.height - keyboardFrame.height) }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let frame = originalTableViewFrame { tableView?.frame = frame }
  }
}


















