//
//  SearchSchoolView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/24/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class SearchSchoolView: UIViewController, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = SearchSchoolController()
  private var model: SearchSchoolModel { get { return controller.model } }
  
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
  private var tableView: UITableView?
  
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
    model._schools.removeAllListeners()
    model._schools.listen(self) { [weak self] schools in
      self?.tableView?.reloadData()
    }
//    model._school.removeAllListeners()
    model._school.listen(self) { [weak self] school in
      self?.choose()
    }
  }
  
  private func setupHeaderView() {
    headerView = UIView()
    headerView?.backgroundColor = .soothingBlue()
    view.addSubview(headerView!)
    
    headerTitle = UILabel()
    headerTitle?.text = "Search Schools"
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
    tableView = UITableView()
    tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
    tableView?.delegate = self
    tableView?.dataSource = self
//    tableView?.separatorColor = .clearColor()
    view.addSubview(tableView!)
  }
  
  // MARK: Functions
  public func cancel() {
    searchBarTextField?.resignFirstResponder()
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  public func choose() {
    searchBarTextField?.resignFirstResponder()
    controller.saveData()
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
    return model.schools.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("UITableViewCell", forIndexPath: indexPath)
    cell.textLabel?.text = model.schools[indexPath.row].name
    cell.textLabel?.font = .asapRegular(12)
    cell.textLabel?.adjustsFontSizeToFitWidth = true
    cell.textLabel?.minimumScaleFactor = 0.5
    return cell
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    model.school = model.schools[indexPath.row]
  }
}













