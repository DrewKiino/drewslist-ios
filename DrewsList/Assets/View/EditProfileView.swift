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
import Neon

public class EditProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let controller = EditProfileController()
  private var model: EditProfileModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setUpTableView()
    
    tableView?.fillSuperview()
    
    FBSDKController.createCustomEventForName("UserEditProfile")
    
    setButton(.LeftBarButton, title: "Cancel", target: self, selector: "cancel")
    setButton(.RightBarButton, title: "Save", target: self, selector: "save")
  }
  
  public override func viewWillAppear(animated: Bool) {
    model.user = UserModel.sharedUser().user
    }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
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
    model._user.listen(self) { [weak self] user in
      self?.tableView!.reloadData()
    }
    // setup controller's databinding
    controller.setupDataBinding()
  }
  
  public func setUser(user: User?) {
    guard let user = user else { return }
    model.user = user
  }
  
  private func presentImagePicker() {
//    navigationController?.pushViewController(ProfileImagePickerView(), animated: true)
    presentViewController(ProfileImagePickerView(), animated: true, completion: nil)
  }
  
  private func presentSchoolPicker() {
    presentViewController(SearchSchoolView().setOnDismiss() { [weak self] school in
      UserModel.sharedUser().user?.school = school?.name
      UserModel.sharedUser().user?.state = school?.state
      self?.tableView?.reloadData()
    }, animated: true, completion: nil)
  }
    

  
  private func setupSelf() {
    title = "Edit Profile"
    view.backgroundColor = .whiteColor()
  }
  
  public func cancel() {
    navigationController?.popViewControllerAnimated(true)
  }
  
  public func save() {
    controller.saveEdit()
    navigationController?.popViewControllerAnimated(true)
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
      
      case 0:
        if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
          cell.paddingLabel?.text = "Profile Image"
          cell.paddingLabel?.textAlignment = .Left
          cell.backgroundColor = .paradiseGray()
          return cell
        }
        break
      case 1:
        if let cell = tableView.dequeueReusableCellWithIdentifier("ChangeImageCell", forIndexPath: indexPath) as? ChangeImageCell {
          cell.label?.text = "Change Picture"
          cell.label?.textColor = UIColor.sexyGray()
          cell.label?.font = .asapRegular(16)
          
          cell.setupUser(model.user)
          cell._didSelectCell.removeAllListeners()
          cell._didSelectCell.listen( self ) { [weak self] bool in
            self?.presentImagePicker()
          }
          return cell
        }
        break
      case 2:
        if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
          cell.paddingLabel?.text =  "School & Phone"
          cell.paddingLabel?.textAlignment = .Left
          cell.backgroundColor = .paradiseGray()
          return cell
        }
      break
      case 3:
        if let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell", forIndexPath: indexPath) as? PickerCell {
          cell.label?.text = "Change School"
          cell.label?.textColor = .sexyGray()
          cell.label?.font = UIFont.asapRegular(16)
          cell.showBottomBorder()
          
          cell.schoolNameLabel?.text = UserModel.sharedUser().user?.getSchoolAbbv()
          
          //cell.setupUser(model.user)
          cell._didSelectCell.removeAllListeners()
          cell._didSelectCell.listen( self ) { [weak self] bool in
            self?.presentSchoolPicker()
          }
          return cell
        }
        break
    case 4:
        if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldWithLabelCell", forIndexPath: indexPath) as? InputTextFieldWithLabelCell {
          
          cell.showBottomBorder()
          cell.titleLabel?.text = "Change Phone"
          cell.textfield?.text = UserModel.sharedUser().user?.getPhoneNumberText()

          return cell
            
        }
        break
      default:
        break
    }
    return cell
  }
  
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0, 2: return 24
    default: break
    }
    return 36
  }
}

public class InputTextFieldWithLabelCell: DLTableViewCell, UITextFieldDelegate {
  
  public var textfield: UITextField?
  public var titleLabel: UILabel?
  
  public override func setupSelf() {
    super.setupSelf()
    
    titleLabel = UILabel()
    titleLabel?.font = .asapRegular(16)
    titleLabel?.textColor = .sexyGray()
    addSubview(titleLabel!)
    
    textfield = UITextField()
    textfield?.font = .asapRegular(16)
    textfield?.textColor = .coolBlack()
    textfield?.delegate = self
    textfield?.textAlignment = .Right
    addSubview(textfield!)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel?.anchorToEdge(.Left, padding: 8, width: 128, height: 24)
    textfield?.anchorToEdge(.Right, padding: 40, width: 128, height: 24)
  }
  
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        var _string: String? = NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1))
        UserModel.sharedUser().user?.phone = Int(_string ?? "")
        _string = nil
        // else, user has inputted some new strings
      } else {
        var _string: String? = text + string
        UserModel.sharedUser().user?.phone = Int(_string ?? "")
        _string = nil
      }
    }
    return true
  }
}

