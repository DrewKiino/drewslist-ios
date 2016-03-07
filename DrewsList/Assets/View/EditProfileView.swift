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
//  private let profileImagePicker = ProfileImagePickerView()
  
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setUpTableView()
    
    tableView?.fillSuperview()
    
    FBSDKController.createCustomEventForName("UserEditProfile")
  }
  
  public override func viewWillAppear(animated: Bool) {
    controller.readRealmUser()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    controller.writeRealmUser()
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
    print("Present School Picker")
  }
  
  private func setupSelf() {
    title = "Edit Profile"
    view.backgroundColor = .whiteColor()
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
      
      case 0:
        if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
          cell.paddingLabel?.text = "Profile Image"
          cell.paddingLabel?.textAlignment = .Center
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
//      case 2:
//        if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
//          cell.paddingLabel?.text = "Profile Bio"
//          cell.paddingLabel?.textAlignment = .Center
//          cell.backgroundColor = .paradiseGray()
//          return cell
//        }
//        break
//      case 3:
//        if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
//          
//          let label = UILabel()
//          cell.addSubview(label)
//          label.text = "Username"
//          label.textColor = .sexyGray()
//          label.font = .asapRegular(16)
//          let xPad = screen.width / 30
//          label.anchorInCorner(.BottomLeft, xPad: xPad, yPad: 0, width: screen.width * (1 / 4) - xPad, height: cell.height / 2)
//          
//          cell.inputTextField?.anchorAndFillEdge(.Right, xPad: xPad, yPad: 0, otherSize: screen.width * (3 / 4) - xPad)
//          cell.inputTextField?.text = UserModel.sharedUser().user?.username
//          cell.inputTextField?.font = .asapRegular(16)
//          
//          cell._inputTextFieldString.listen(self) { [weak self] string in
//            self?.controller.setUsername(string)
//          }
//          return cell
//        }
//        break
//      
//      case 4:
//        if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
//          cell.hideBothTopAndBottomBorders()
//          return cell
//        }
//      break
//      
//      case 5:
//        if let cell = tableView.dequeueReusableCellWithIdentifier("PickerCell", forIndexPath: indexPath) as? PickerCell {
//          cell.label?.text = "Change School"
//          cell.label?.textColor = .sexyGray()
//          cell.label?.font = UIFont.asapRegular(16)
//          
//          //cell.setupUser(model.user)
//          
//          cell._didSelectCell.removeAllListeners()
//          cell._didSelectCell.listen( self ) { [weak self] bool in
//            self?.presentSchoolPicker()
//          }
//          
//          return cell
//        }
//        break
      default:
        break
    }
    return cell
  }
  
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 24
    default: break
    }
    return 48
  }
}

