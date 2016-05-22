//
//  AcctSettingView.swift
//  DrewsList
//
//  Created by Starflyer on 12/16/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import Neon
import CoreLocation
import AddressBook
import AVFoundation
import Photos
import EventKit
import CoreBluetooth
import CoreMotion
import Contacts
import PermissionScope



public class AccountSettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
  
  private let controller = AccountSettingsController()
  private var model: AccountSettingsModel { get { return controller.getModel() } }
  
  private let pushController = PushController.sharedInstance()
  private let locationController = LocationController.sharedInstance()
  private let userPrivacyController = UserPrivacyController.sharedInstance()
  
  private var tableView: DLTableView?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupTableView()
  
    FBSDKController.createCustomEventForName("UserAccountSettings")
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    controller.viewDidAppear()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    controller.viewWillDisappear()
  }
  
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
    title = "Account Settings"
  }

  private func setupDataBinding() {
    model._user.removeListener(self)
    model._user.listen(self) { [weak self] user in
      self?.tableView?.reloadData()
    }
    _applicationWillEnterForeground.removeListener(self)
    _applicationWillEnterForeground.listen(self) { [weak self] bool in
      self?.controller.viewDidAppear()
    }
  }
  
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0, 7, 11, 13: return 24
    case 15: return 100
    default: return 36
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 16
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideTopBorder()
        cell.paddingLabel?.text = "Account Info"
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Email:"
        cell.titleTextLabel?.text = model.user?.email
        cell.hideSeparatorLine()
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Username:"
        cell.titleTextLabel?.text = model.user?.username
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "First Name:"
        cell.titleTextLabel?.text = model.user?.firstName
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Last Name:"
        cell.titleTextLabel?.text = model.user?.lastName
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Phone Number:"
        cell.titleTextLabel?.text = model.user?.getPhoneNumberText()
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "School:"
        cell.titleTextLabel?.text = model.user?.school
        return cell
      }
      break
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Permissions"
        return cell
      }
      break
    case 8:
      if let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as? SwitchCell {
        cell.titleLabel?.text = "Allow push notifications"
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] bool in
          self?.pushController.showPermissions(true)
        }
        
        pushController._didUpdateAuthorizationStatus.removeListener(self)
        pushController._didUpdateAuthorizationStatus.listen(self) { [weak self, weak cell] bool in
          if bool { cell?.switchOn() }
          else { cell?.switchOff() }
        }
        
        if pushController.isRegisteredForRemoteNotifications() == true {
          cell.switchOn()
        } else {
          cell.switchOff()
        }
        
        cell.hideSeparatorLine()
        
        return cell
      }
      break
    case 9:
      if let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as? SwitchCell {
        cell.titleLabel?.text = "Allow in-app location services"
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self, weak cell] bool in
          self?.locationController.showPermissions()
        }
        
        if locationController.isRegisteredForLocationUpdates() {
          cell.switchOn()
        } else {
          cell.switchOff()
        }
        
        locationController._didUpdateAuthorizationStatus.removeListener(self)
        locationController._didUpdateAuthorizationStatus.listen(self) { [weak self, weak cell] bool in
          if bool { cell?.switchOn() }
          else { cell?.switchOff() }
        }
        
        cell.hideSeparatorLine()
        return cell
      }
      break
    case 10:
      if let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as? SwitchCell {
        cell.titleLabel?.text = "Allow other users to call you"
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self, weak cell] bool in
          cell?.toggleSwitch()
          self?.userPrivacyController.privatePhoneNumber = cell?.isOn() == false
        }
        
        if userPrivacyController.hasPrivatePhoneNumber() == true {
          cell.switchOff()
        } else {
          cell.switchOn()
        }
        
        cell.hideSeparatorLine()
        
        return cell
      }
      break
    case 11:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Main Options"
        return cell
      }
      break
    case 12:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        cell.titleButton?.setTitle("Manage Listings", forState: .Normal)
        cell.onClick = { [weak self] in
          self?.navigationController?.pushViewController(ListingsView(), animated: true)
        }
        return cell
      }
      break
    case 13:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Other Options"
        return cell
      }
      break
    case 14:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("Delete Account", forState: .Normal)
        cell.hideArrowIcon()
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self ] bool in
          UserController.deleteUserInServer(UserModel.sharedUser().user?._id)
        }
        
        return cell
      }
      break
    default: break
    }
    
    return DLTableViewCell()
  }
  
  private func setupPushPermissions() {
  }
  
  private func setupEmailPermissions(view: UIView) {
  }
  
  private func setupLoginFBPermissions(view: UIView) {
  }
}













