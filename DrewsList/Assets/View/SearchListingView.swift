//
//  SearchListingView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/14/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit

public class SearchListingView: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UIScrollViewDelegate {
  
  private let controller = SearchListingController()
  private var model: SearchListingModel { get { return controller.model } }
  
  // Navigation Header Views
  private var headerView: UIView?
  private var cancelButton: UIButton?
  //  private var chooseButton: UIButton?
  private var headerTitle: UILabel?
  
  // Search Bar
  private var searchBarContainer: UIView?
  private var searchBarTextField: UITextField?
  
  //  School List
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupHeaderView()
    setupSearchBar()
    setupTableView()
    
    title = "Search Listing"
    
    if navigationController == nil {
      
      headerView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
      headerTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
      cancelButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
      
      searchBarContainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: headerView!, padding: 0, height: 36)
      tableView?.alignAndFill(align: .UnderCentered, relativeTo: searchBarContainer!, padding: 0)
      
    } else {
      
      searchBarContainer?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 36)
      tableView?.alignAndFillWidth(align: .UnderCentered, relativeTo: searchBarContainer!, padding: 0, height: view.frame.height - 36 - 113)
    }
    
    searchBarTextField?.fillSuperview(left: 8, right: 8, top: 8, bottom: 8)
    
    FBSDKController().createCustomEventForName("UserSearchListing")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    searchBarTextField?.becomeFirstResponder()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupDataBinding() {
    controller.isLoadingDataFromServer.removeAllListeners()
    controller.isLoadingDataFromServer.listen(self) { [weak self] isLoading in
      if self?.navigationController == nil {
        self?.view.showActivityBarItem()
      } else {
        DLNavigationController.showActivityAnimation(self)
      }
    }
    controller.didLoadDataFromServer.removeAllListeners()
    controller.didLoadDataFromServer.listen(self) { [weak self] didLoad in
      if self?.navigationController == nil {
        self?.view.dismissActivityView()
      } else {
        DLNavigationController.hideActivityAnimation(self)
      }

      self?.tableView?.reloadData()
    }
  }
  
  private func setupHeaderView() {
    headerView = UIView()
    headerView?.backgroundColor = .soothingBlue()
    view.addSubview(headerView!)
    
    headerTitle = UILabel()
    headerTitle?.text = "Search Listing"
    headerTitle?.textAlignment = .Center
    headerTitle?.font = UIFont.asapBold(16)
    headerTitle?.textColor = .whiteColor()
    headerView?.addSubview(headerTitle!)
    
    cancelButton = UIButton()
    cancelButton?.setTitle("Cancel", forState: .Normal)
    cancelButton?.titleLabel?.font = UIFont.asapRegular(16)
    cancelButton?.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
    headerView?.addSubview(cancelButton!)
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
    searchBarTextField?.autocorrectionType = .No
    searchBarTextField?.clearButtonMode = .WhileEditing
    searchBarTextField?.placeholder = "Title, Author, ISBN, etc."
    searchBarContainer?.addSubview(searchBarTextField!)
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.showsVerticalScrollIndicator = true
    tableView?.backgroundColor = .whiteColor()
    view.addSubview(tableView!)
  }
  
  // MARK: Functions
  public func cancel() {
    searchBarTextField?.resignFirstResponder()
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  public func choose() {
    searchBarTextField?.resignFirstResponder()
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
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
    
    if model.searchString?.characters.count == 0 {
      model.listings.removeAll(keepCapacity: false)
      tableView?.reloadData()
    }
    
    return true
  }
  
  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if let notes = model.listings[indexPath.row].notes where !notes.isEmpty {
      
      return NSAttributedString(string: notes).heightWithConstrainedWidth(screen.width) + 325
      
    } else { return 325 }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.listings.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("ListFeedCell", forIndexPath: indexPath) as? ListFeedCell {
      
      cell.showSeparatorLine()
      cell.isUserListing = UserModel.sharedUser().user?._id == model.listings[indexPath.row].user?._id
      cell.listView?.setListing(model.listings[indexPath.row])
      
      return cell
    }
    
    return DLTableViewCell()
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//    model.user = model.users[indexPath.row]
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    searchBarTextField?.resignFirstResponder()
    log.debug("mark")
  }
}