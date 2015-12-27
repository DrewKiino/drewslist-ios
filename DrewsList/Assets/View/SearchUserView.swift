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
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("UserCell", forIndexPath: indexPath) as? UserCell {
      cell.setUser(model.users[indexPath.row])
      return cell
    }
    return DLTableViewCell()
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    model.user = model.users[indexPath.row]
  }
}

public class UserCell: DLTableViewCell {
  
  public var profileImageView: UIImageView?
  public var profileImageUrl: String?
  
  public var usernameLabel: UILabel?
  public var schoolLabel: UILabel?
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupProfileImageView()
    setupUsernameLabel()
    setupSchoolLabel()
    
    profileImageView?.anchorToEdge(.Left, padding: 4, width: 36, height: 36)
    usernameLabel?.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: profileImageView!, padding: 4, height: 12)
    schoolLabel?.alignAndFillWidth(align: .UnderMatchingLeft, relativeTo: usernameLabel!, padding: 0, height: 12)
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
    usernameLabel?.font = .asapRegular(12)
    usernameLabel?.adjustsFontSizeToFitWidth = true
    usernameLabel?.minimumScaleFactor = 0.5
    addSubview(usernameLabel!)
  }
  
  private func setupSchoolLabel() {
    schoolLabel = UILabel()
    schoolLabel?.font = .asapRegular(10)
    schoolLabel?.textColor = .sexyGray()
    schoolLabel?.adjustsFontSizeToFitWidth = true
    schoolLabel?.minimumScaleFactor = 0.5
    addSubview(schoolLabel!)
  }
  
  
  public func setUser(user: User?) {
    guard let user = user else { return }
    
    usernameLabel?.text = user.getName()
    schoolLabel?.text = user.school
    
    if profileImageUrl != user.image { profileImageView?.image = nil }
    
    // MARK: Images
    Async.background { [weak self, weak user ] in
      
      var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(self?.profileImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
      
      Async.main { [weak self] in
        
        if self?.profileImageView?.image == nil { self?.profileImageView?.image = toucan?.image }
      
        toucan = nil
        
        if user?.image != nil && self?.profileImageUrl != user?.image {
          
          UIImageView.dl_setImageFromUrl(user?.image) { [weak self] image, error, cache, finished, nsurl in
            Async.background { [weak self] in
              
              // NOTE: correct way to handle memory management with toucan
              // init toucan and pass in the arguments directly in the parameter headers
              // do the resizing in the background
              var toucan: Toucan? = Toucan(image: image).resize(self?.profileImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
          
              Async.main { [weak self] in
                
                self?.profileImageUrl = nsurl.URLString
                
                // set the image view's image
                self?.profileImageView?.image = toucan?.image
                
                // deinit toucan
                toucan = nil
              }
            }
          }
        }
      }
    }
  }
}






















