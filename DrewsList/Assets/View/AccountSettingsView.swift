//
//  AcctSettingView.swift
//  DrewsList
//
//  Created by Starflyer on 12/16/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import Neon

private extension UITableViewRowAnimation {
  
  static func names() -> [String] { return ["None", "Fade", "Right", "Left", "Top", "Bottom", "Middle", "Automatic"] }
  
  static func all() -> [UITableViewRowAnimation] { return [.None, .Fade, .Right, .Left, .Top, .Bottom, .Middle, .Automatic] }
}


public class AccountSettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = AccountSettingsController()
  private var model: AccountSettingsModel { get { return controller.getModel() } }
  
  private var tableView: DLTableView?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
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
      case 10: return 0
      default: return 48
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 11
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
        cell.titleLabel?.text = "Log in with Facebook"
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
        
        return cell
      }
      break
    case 9:
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
    tableView?.contentInset.bottom = 30
  }
  
  private func setupPushPermissions(view: UIView) {
  }
  
  private func setupEmailPermissions(view: UIView) {
  }
  
  private func setupLoginFBPermissions(view: UIView) {
  }
}













