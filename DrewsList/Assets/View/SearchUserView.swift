//
//  SearchUserView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/25/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Async

public class SearchUserView: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  private let controller = SearchUserController()
  private var model: SearchUserModel { get { return controller.model } }
  
  // Navigation Header Views
  private var headerView: UIView?
  private var cancelButton: UIButton?
  //  private var chooseButton: UIButton?
  private var headerTitle: UILabel?
  
  // Search Bar
  private var searchBarContainer: UIView?
  private var searchBarTextField: UITextField?
  private var searchBarImageView: UIImageView?
  
  //  School List
  private var tableView: DLTableView?
  
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
    //    chooseButton?.anchorInCorner(.BottomRight, xPad: 8, yPad: 8, width: 64, height: 24)
    
    searchBarContainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: headerView!, padding: 0, height: 36)
    searchBarTextField?.anchorAndFillEdge(.Left, xPad: 8, yPad: 8, otherSize: screen.width - 48)
    searchBarImageView?.alignAndFill(align: .ToTheRightCentered, relativeTo: searchBarTextField!, padding: 8)
    
    tableView?.alignAndFill(align: .UnderCentered, relativeTo: searchBarContainer!, padding: 0)
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    searchBarTextField?.becomeFirstResponder()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    searchBarImageView?.image = Toucan(image: UIImage(named: "Icon-Search-1")).resize(searchBarImageView!.frame.size).image
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupDataBinding() {
    model._users.removeAllListeners()
    model._users.listen(self) { [weak self] users in
      self?.tableView?.reloadData()
    }
    //    model._school.removeAllListeners()
    model._user.listen(self) { [weak self] user in
      self?.choose()
    }
  }
  
  private func setupHeaderView() {
    headerView = UIView()
    headerView?.backgroundColor = .soothingBlue()
    view.addSubview(headerView!)
    
    headerTitle = UILabel()
    headerTitle?.text = "Search Users"
    headerTitle?.textAlignment = .Center
    headerTitle?.font = UIFont.asapBold(16)
    headerTitle?.textColor = .whiteColor()
    headerView?.addSubview(headerTitle!)
    
    cancelButton = UIButton()
    cancelButton?.setTitle("Cancel", forState: .Normal)
    cancelButton?.titleLabel?.font = UIFont.asapRegular(16)
    cancelButton?.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
    headerView?.addSubview(cancelButton!)
    
    //    chooseButton = UIButton()
    //    chooseButton?.setTitle("Choose", forState: .Normal)
    //    chooseButton?.titleLabel?.font = UIFont.asapRegular(16)
    //    chooseButton?.addTarget(self, action: "choose", forControlEvents: .TouchUpInside)
    //    headerView?.addSubview(chooseButton!)
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
    searchBarContainer?.addSubview(searchBarTextField!)
    
    searchBarImageView = UIImageView()
    searchBarContainer?.addSubview(searchBarImageView!)
    
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
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
    return true
  }
  
  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return false
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.users.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let duration: NSTimeInterval = 0.7
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as? UserCell {
      return cell
    }
//    cell.textLabel?.text = model.users[indexPath.row].getName()
//    cell.textLabel?.font = .asapRegular(12)
//    cell.textLabel?.adjustsFontSizeToFitWidth = true
//    cell.textLabel?.minimumScaleFactor = 0.5
//    cell.imageView?.dl_setImageFromUrl(model.users[indexPath.row].image) { [weak cell] image, error, cache, url in
//      Async.background { [weak cell] in
//        // NOTE: correct way to handle memory management with toucan
//        // init toucan and pass in the arguments directly in the parameter headers
//        // do the resizing in the background
//        var toucan: Toucan? = Toucan(image: image).resize(cell?.imageView?.frame.size, fitMode: .Crop)
//        
//        Async.main { [weak cell] in
//          
//          cell?.imageView?.alpha = 0.0
//          
//          cell?.imageView?.image = toucan?.image
//          
//          UIView.animateWithDuration(duration) { [weak cell] in
//            log.debug(cell?.frame.size)
//            cell?.imageView?.alpha = 1.0
//          }
//          
//          // deinit toucan
//          toucan = nil
//        }
//      }
//    }
    return DLTableViewCell()
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    model.user = model.users[indexPath.row]
  }
}

public class UserCell: DLTableViewCell {
  
  public var profileImageView: UIImageView?
  public var usernameLabel: UILabel?
  
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupProfileImageView()
    setupUsernameLabel()
    
    profileImageView?.anchorAndFillEdge(.Left, xPad: 2, yPad: 2, otherSize: 36)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func setupProfileImageView() {
    profileImageView = UIImageView()
    addSubview(profileImageView!)
  }
  
  private func setupUsernameLabel() {
    usernameLabel = UILabel()
    addSubview(usernameLabel!)
  }
  
  
  public func setUser(user: User?) {
    guard let user = user else { return }
    
    
    
    
    
  }
}






















