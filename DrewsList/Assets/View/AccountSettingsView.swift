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


private extension UITableViewRowAnimation {
  
  static func names() -> [String] { return ["None", "Fade", "Right", "Left", "Top", "Bottom", "Middle", "Automatic"] }
  
  static func all() -> [UITableViewRowAnimation] { return [.None, .Fade, .Right, .Left, .Top, .Bottom, .Middle, .Automatic] }
}


public class AccountSettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate{
  
  private let controller = AccountSettingsController()
  private var model: AccountSettingsModel { get { return controller.getModel() } }
  let baseView    = UIView()
  let contentView = UIView()
  let headerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
  let bodyLabel   = UILabel(frame: CGRect(x: 0, y: 0, width: 240, height: 70))
  let closeButton = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 32))
  let Pscope = PermissionScope()
  

  
  private var tableView: DLTableView?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    //SetUpPermissions
    Pscope.headerLabel.text = "Hey Book Worm!"
    Pscope.bodyLabel.text = "Do you Want Notifications From Drew's List? "
    Pscope.addPermission(NotificationsPermission(), message: "Do you want Push & Email Notification Enabled?")
    Pscope.addPermission(ContactsPermission(), message: "Do you want to Integrate your Facebook")
    
    
    //Show Dialog and Callbacks
    Pscope.show( { finished, results in
      print("got results \(results)") } ,
      cancelled: { (results) -> Void in
        print("Cancelled")
        
        
      })
    
    
    
    
    //Unified Permission API
    func checkNotification() {
      switch PermissionScope().statusNotifications(){
      case .Unknown:
        // ask
        PermissionScope().requestNotifications()
      case .Unauthorized, .Disabled:
        // bummer
        return
      case .Authorized:
        // thanks!
        return
      }
    }
    
    setupSelf()
    setupTableView()
    tableView?.fillSuperview()
  }
  
  

  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    controller.readRealmUser()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
    title = "Account Setting"
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
      case 9: return 100
      case 12: return 0
      default: return 48
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 12
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
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
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Platform Integration"
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        cell.titleButton?.setTitle("FaceBook Coming Soon", forState: .Normal)
        cell._didSelectCell.listen(self) { bool in
          log.debug(bool)
        }
        
        cell.hideSeparatorLine()
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
        cell.titleLabel?.text = "Push Notifications"
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak cell] bool in
          log.debug(bool)
          cell?.toggleSwitch()
        }
        cell.hideSeparatorLine()
        return cell
      }
      break
    case 9:
      if let cell = tableView.dequeueReusableCellWithIdentifier("SwitchCell", forIndexPath: indexPath) as? SwitchCell {
         cell.titleLabel?.text = "Email Notificiations"
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak cell] bool in
          log.debug(bool)
          cell?.toggleSwitch()
        }
        cell.hideSeparatorLine()
        return cell
      }
      break
    case 10:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as?
        PaddingCell { cell.paddingLabel?.text = "Deactivation of Account"
          return cell
      }
      break
      //need to DBG UIFontView
    case 11:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        cell.textLabel?.text = "Deactivate Account"
        cell._didSelectCell.listen(self) { bool in
          log.debug(bool)
      }
      return cell
      }
      break
    case 12:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBottomBorder()
        return cell
      }
      break
    default: break
    }
    
    let cell = UITableViewCell()
    cell.separatorInset = UIEdgeInsetsMake(0, screen.width, 0, 0)
    
    return cell
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    log.debug(indexPath.row)
  }
  
  func configure() {
    title = "Account Settings"
    tableView?.contentInset.bottom = 40
  }

  
  
  //Permissions_V2_Need_to_DBG
  //  public init(backgroundTapCancels: Bool) {
  //    super.init(nibName: nil, bundle: nil)
  //
  //    view.frame = UIScreen.mainScreen().bounds
  //    view.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleHeight]
  //    view.backgroundColor = UIColor.bareBlue()
  //    view.addSubview(baseView)
  //
  //    //BaseView
  //    baseView.frame = view.frame
  //    baseView.addSubview(contentView)
  //    if backgroundTapCancels {
  //      let tap = UITapGestureRecognizer(target: self, action: Selector("cancel"))
  //      tap.delegate = self
  //      baseView.addGestureRecognizer(tap)
  //
  //    }
  //
  //    //ContentView
  //    contentView.backgroundColor = UIColor.whiteColor()
  //    contentView.layer.cornerRadius = 10
  //    contentView.layer.masksToBounds = true
  //    contentView.layer.borderWidth = 0.5
  //
  //    //HeaderLabel
  //    headerLabel.font = UIFont.systemFontOfSize(22)
  //    headerLabel.textColor = UIColor.blackColor()
  //    headerLabel.textAlignment = NSTextAlignment.Center
  //    headerLabel.text = "Hey, listen"._sdLocalize
  //
  //    contentView.addSubview(headerLabel)
  //
  //    //BodyLabel
  //    bodyLabel.font = UIFont.boldSystemFontOfSize(16)
  //    bodyLabel.textColor = UIColor.blackColor()
  //    bodyLabel.textAlignment = NSTextAlignment.Center
  //    bodyLabel.text = "We need a couple of things\r\nbefore you get started"._sdLocalize
  //    bodyLabel.numberOfLines = 2
  //
  //    contentView.addSubview(bodyLabel)
  //
  //    //CloseButton
  //    closeButton.setTitle("Close"._sdLocalize, forState: .Normal)
  //    closeButton.addTarget(self, action: Selector("cancel"), forControlEvents: UIControlEvents.TouchUpInside)
  //
  //    contentView.addSubview(closeButton)
  //
  //  }
  //
  //  required public init?(coder aDecoder: NSCoder) {
  //      fatalError("init(coder:) has not been implemented")
  //  }
  
  

  
  private func setupPushPermissions() {
    controller.permissionsAppear()
  }
  
  private func setupEmailPermissions(view: UIView) {
  }
  
  private func setupLoginFBPermissions(view: UIView) {
  }
}













