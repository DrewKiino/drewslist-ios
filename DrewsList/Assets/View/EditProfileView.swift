//
//  EditProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Toucan

public class EditProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let controller = EditProfileController()
  private var model: EditProfileModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds
  private var tableView = UITableView()
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    setUpTableView()
    controller.setUp()
    
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
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
      log.debug(user?.image)
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
          cell.textLabel?.text = "Change Picture"
          cell.textLabel?.textColor = UIColor.lightGrayColor()
          cell.textLabel?.font = UIFont.asapRegular(14)
          return cell
        }
        break;
      case 1:
        if let cell = tableView.dequeueReusableCellWithIdentifier("EditCell", forIndexPath: indexPath) as? EditCell {
          cell.textField?.text = "First Name"
          cell.textField?.textColor = UIColor.lightGrayColor()
          cell.textField?.font = UIFont.asapRegular(14)
 
          return cell
        }
        break;
   
      case 2:
        if let cell = tableView.dequeueReusableCellWithIdentifier("EditCell", forIndexPath: indexPath) as? EditCell {
          cell.textField?.text = "Last Name"
          cell.textField?.textColor = UIColor.lightGrayColor()
          cell.textField?.font = UIFont.asapRegular(14)
 
          return cell
        }
        break;
      case 3:
        if let cell = tableView.dequeueReusableCellWithIdentifier("EditCell", forIndexPath: indexPath) as? EditCell {
          cell.textField?.text = "Username"
          cell.textField?.textColor = UIColor.lightGrayColor()
          cell.textField?.font = UIFont.asapRegular(14)
          
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
  
//  public var textView: UILabel?
//  public var imageView: UIImageView?
//  
//  public override init(frame: CGRect) {
//    super.init(frame: frame)
//  }
//  
//  public required init?(coder aDecoder: NSCoder) {
//    super.init(coder: aDecoder)
//  }
}

public class EditCell: UITableViewCell {
  
  public var textField: UITextField?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    textField = UITextField()
    addSubview(textField!)
    textField?.fillSuperview()
    
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
//  }
}
}
