//
//  EditProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class EditProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let controller = EditProfileController()
  private var model: EditProfileModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds
  private var tableView: DLTableView?
  
  public override func viewWillAppear(animated: Bool) {
    controller.readRealmUser()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    controller.writeRealmUser()
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    setUpTableView()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView?.fillSuperview()
  }
  
  public func setUser(user: User?) {
    guard let user = user else { return }
    model.user = user
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
    controller.model._user.listen(self) { [weak self] user in
      //self?.setUser(user)
      self?.tableView!.reloadData()
    }
    // setup controller's databinding
    controller.setupDataBinding()
  }
  
  private func presentImagePicker() {
    let picker = UIImagePickerController()
    picker.delegate = self
    picker.sourceType = .PhotoLibrary
    picker.allowsEditing = false
    //self.navigationController?.pushViewController(picker, animated: true)
    presentViewController(picker, animated: true, completion: nil)
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 5
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
      case 0:
        if let cell = tableView.dequeueReusableCellWithIdentifier("ChangeImageCell", forIndexPath: indexPath) as? ChangeImageCell {
          cell.label?.text = "Change Picture"
          cell.label?.textColor = UIColor.lightGrayColor()
          cell.label?.font = UIFont.asapRegular(14)
          
          print("moo")
          ///////////////
          //cell.setupUserImage(model.user)
          ///////////////
          
          cell._didSelectCell.listen( self ) { [weak self] bool in
            self?.presentImagePicker()
          }
          return cell
        }
        break;
      case 1:
        if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
          cell.inputTextField?.text = model.user?.firstName
          cell.inputTextField?.textColor = UIColor.lightGrayColor()
          cell.inputTextField?.font = UIFont.asapRegular(14)
          cell._inputTextFieldString.listen(self) { [weak self] string in
            self?.controller.setFirstName(string)
          }
          return cell
        }
        break;
   
      case 2:
        if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
          cell.inputTextField?.text = model.user?.lastName
          cell.inputTextField?.textColor = UIColor.lightGrayColor()
          cell.inputTextField?.font = UIFont.asapRegular(14)
          cell._inputTextFieldString.listen(self) { [weak self] string in
            self?.controller.setLastName(string)
          }
          return cell
        }
        break;
      case 3:
        if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
          cell.inputTextField?.text = model.user?.username
          cell.inputTextField?.textColor = UIColor.lightGrayColor()
          cell.inputTextField?.font = UIFont.asapRegular(14)
          
          cell._inputTextFieldString.listen(self) { [weak self] string in
            self?.controller.setUsername(string)
          }
          return cell
        }
        break;
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
  
  public func imagePickerController(
    picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [String : AnyObject])
  {
    // expecting image here?
    // model.profileImage = image
  }
  
  public func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if (indexPath.row == 4){
      return screen.height
    } else {
      return screen.height / 15
    }
  }
  
  
}

