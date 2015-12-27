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
  private var tableView = UITableView()
  
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
  }
  
  public func setUser(user: User?) {
    guard let user = user else { return }
    model.user = user
  }
  
  // MARK: setup view functions
  
  public func setUpTableView(){
    view.addSubview(tableView)

    tableView.fillSuperview()
    tableView.delegate = self
    tableView.dataSource = self
    tableView.registerClass(ProfileImgCell.self, forCellReuseIdentifier: "ProfileImgCell")
    tableView.registerClass(EditCell.self, forCellReuseIdentifier: "EditCell")
  }
  
  
  // MARK: private functions
  
  private func setupDataBinding() {
    controller.model._user.listen(self) { [weak self] user in
      self?.tableView.reloadData()
    }
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
    
    var cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
      case 0:
        if let cell = tableView.dequeueReusableCellWithIdentifier("ProfileImgCell", forIndexPath: indexPath) as? ProfileImgCell {
          cell.label?.text = "Change Picture"
          cell.label?.textColor = UIColor.lightGrayColor()
          cell.label?.font = UIFont.asapRegular(14)
          return cell
        }
        break;
      case 1:
        if let cell = tableView.dequeueReusableCellWithIdentifier("EditCell", forIndexPath: indexPath) as? EditCell {
          cell.textField?.text = model.user?.firstName
          cell.textField?.textColor = UIColor.lightGrayColor()
          cell.textField?.font = UIFont.asapRegular(14)
          cell._textFieldString.listen(self) { [weak self] string in
            self?.controller.setFirstName(string)
          }
          return cell
        }
        break;
   
      case 2:
        if let cell = tableView.dequeueReusableCellWithIdentifier("EditCell", forIndexPath: indexPath) as? EditCell {
          cell.textField?.text = model.user?.lastName
          cell.textField?.textColor = UIColor.lightGrayColor()
          cell.textField?.font = UIFont.asapRegular(14)
          cell._textFieldString.listen(self) { [weak self] string in
            self?.controller.setLastName(string)
          }

          return cell
        }
        break;
      case 3:
        if let cell = tableView.dequeueReusableCellWithIdentifier("EditCell", forIndexPath: indexPath) as? EditCell {
          cell.textField?.text = model.user?.username
          cell.textField?.textColor = UIColor.lightGrayColor()
          cell.textField?.font = UIFont.asapRegular(14)
          cell._textFieldString.listen(self) { [weak self] string in
            self?.controller.setUsername(string)
          }
          
          return cell
        }
        break;
      case 4:
        cell = tableView.dequeueReusableCellWithIdentifier("EditCell") as! EditCell
        break;
      default:
        break;
    }
    
    cell.textLabel?.textColor = UIColor.lightGrayColor()
    cell.textLabel?.font = UIFont.asapRegular(14)
    return cell
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    print("You selected cell #\(indexPath.row)!")
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if (indexPath.row == 4){
      return screen.height
    } else {
      return screen.height / 15
    }
  }
}



  // MARK: Cell Classes

public class ProfileImgCell: UITableViewCell {
  public var label: UILabel?
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    label = UILabel()
    addSubview(label!)
    label?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
  }
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
}


public class EditCell: UITableViewCell, UITextFieldDelegate {
  
  public var textField: UITextField?
  public let _textFieldString = Signal<String?>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupTextField()
  }
  
  public func setupTextField() {
    textField = UITextField()
    addSubview(textField!)
    textField?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
    textField?.delegate = self
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        _textFieldString.fire(NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1)))
      // else, user has inputted some new strings
      } else { _textFieldString.fire(text + string) }
    }
    return true
  }
}
