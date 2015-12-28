//
//  BookProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class BookProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource {


  private let controller = BookProfileController()
  private var model: BookProfileModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
    setupDataBinding()
 
  }
  
  public override func viewWillAppear(animated: Bool) {
  }
  
  public override func viewWillDisappear(animated: Bool) {
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView?.fillSuperview()
  }
  
  // MARK: setup view functions
  
  public func setUpTableView(){
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  
  // MARK: private functions
  
  private func setupDataBinding() {
    // setup view's databinding
    model._book.listen(self) { [weak self] book in
       print(self?.model.book?.title)
      self?.tableView!.reloadData()
    }
    // setup controller's databinding
    controller.setBookID("56728eafa0e9851f007e7850")
    controller.getBookFromServer()
  }
  
  public func setBook(book: Book?) {
    guard let book = book else { return }
    model.book = book
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
        cell.titleLabel?.text = model.book?.authors.first?.name
        cell.titleLabel?.font = UIFont.asapItalic(12)
        return cell
      }
      break;
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
        cell.titleLabel?.text = model.book?.title
        cell.titleLabel?.font = UIFont.asapBold(20)
        return cell
      }
      break;
      
//    case 2:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
//        cell.inputTextField?.text = model.user?.lastName
//        cell.inputTextField?.textColor = UIColor.lightGrayColor()
//        cell.inputTextField?.font = UIFont.asapRegular(14)
//        cell._inputTextFieldString.listen(self) { [weak self] string in
//          self?.controller.setLastName(string)
//        }
//        return cell
//      }
//      break;
//    case 3:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
//        cell.inputTextField?.text = model.user?.username
//        cell.inputTextField?.textColor = UIColor.lightGrayColor()
//        cell.inputTextField?.font = UIFont.asapRegular(14)
//        
//        cell._inputTextFieldString.listen(self) { [weak self] string in
//          self?.controller.setUsername(string)
//        }
//        return cell
//      }
//      break;
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.backgroundColor = UIColor.whiteColor()
        cell.hideBothTopAndBottomBorders()
        cell.selectionStyle = .None
        return cell
      }
      break;
    default:
      break;
    }
    
    cell.textLabel?.textColor = UIColor.lightGrayColor()
    cell.textLabel?.font = UIFont.asapRegular(14)
    return cell
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    if (indexPath.row == 0){
//      return screen.height / 3
//    } else {
//      return screen.height / 15
//    }
    
    switch (indexPath.row) {
    case 0:
      return screen.height / 35
      break;
//    case 1:
//      break;
//    case 2:
//      break;
    default:
      return screen.height / 30
      break;
    
    }
  }
  
  
}