//
//  SettingsView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKLoginKit

public class SettingsView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupTableView()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
    title = "Settings"
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
    
    tableView?.fillSuperview()
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
//    case 0:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell") as? PaddingCell {
//        cell.hideTopBorder()
//        return cell
//      }
//      break
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell") as? FullTitleCell {
        cell.showTopBorder()
        cell.titleButton?.setTitle("Edit Profile", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] bool in
          self?.navigationController?.pushViewController(EditProfileView(), animated: true)
        }
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell") as? FullTitleCell {
        cell.showSeparatorLine()
        cell.titleButton?.setTitle("Account Settings", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] bool in
          self?.navigationController?.pushViewController(AccountSettingsView(), animated: true)
        }
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell") as? FullTitleCell {
        cell.showSeparatorLine()
        cell.titleButton?.setTitle("Help Center", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] bool in
          log.debug("TODO: show help center view")
        }
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell") as? FullTitleCell {
        cell.showSeparatorLine()
        cell.titleButton?.setTitle("Terms & Privacy", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] bool in
          log.debug("TODO: show terms and privacy view")
        }
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell") as? FullTitleCell {
        cell.showSeparatorLine()
        cell.hideArrowIcon()
        cell.titleButton?.setTitle("Log Out", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] bool in
          NSTimer.after(0.5) { [weak self] in
            // deletes the current user, then will log user out.
            self?.deleteRealmUser()
            // log out of facebook if they are logged in
//            if let token = FBSDKAccessToken.currentAccessToken() {
//              print("User \(token) will be logged out")
//              FBSDKAccessToken.setCurrentAccessToken(nil)
//            }
            // since the current user does not exist anymore
            // we ask the tab view to check any current user, since we have no current user
            // it will present the login screen
            self?.navigationController?.popToRootViewControllerAnimated(true)
            if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView { tabView.checkIfUserIsLoggedIn() }
          }
        }
        cell.showBottomBorder()
        return cell
      }
      break
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell") as? PaddingCell {
        cell.hideBottomBorder()
        return cell
      }
      break
    default: break
    }
    return DLTableViewCell()
  }
  
  // this one deletes all prior users, on logout.
  public func deleteRealmUser(){ try! Realm().write { try! Realm().delete(try! Realm().objects(RealmUser.self)) } }
}

/*

public class SettingsView: FormViewController {
  
  private let screenSize = UIScreen.mainScreen().bounds
  
  private var enabled = true
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.scrollEnabled = false
    
    let editProfileRow = LabelRowFormer<FormLabelCell>()
    .configure { row in
      row.text = "Edit Profile"
      row.cellUpdate { cell in
        cell.titleLabel.textColor = UIColor.lightGrayColor()
        cell.titleLabel?.font = UIFont.asapRegular(14)
      }
    }.onSelected { row in
      self.former.deselect(true)
    }
    
    let accountSettingsRow = LabelRowFormer<FormLabelCell>()
    .configure { row in
      row.text = "Account Settings"
      row.cellUpdate { cell in
        cell.titleLabel.textColor = UIColor.lightGrayColor()
        cell.titleLabel?.font = UIFont.asapRegular(14)
      }
    }.onSelected { [weak self] row in
      self?.former.deselect(true)
    }
    
    let helpCenterRow = LabelRowFormer<FormLabelCell>()
    .configure { row in
      row.text = "Help Center"
      row.cellUpdate { cell in
        cell.titleLabel.textColor = UIColor.lightGrayColor()
        cell.titleLabel?.font = UIFont.asapRegular(14)
      }
    }.onSelected { row in
      self.former.deselect(true)
    }
    
    let termsPrivacyRow = LabelRowFormer<FormLabelCell>()
    .configure { row in
      row.text = "Terms & Privacy"
      row.cellUpdate { cell in
        cell.titleLabel.textColor = UIColor.lightGrayColor()
        cell.titleLabel?.font = UIFont.asapRegular(14)
      }
    }.onSelected { row in
      self.former.deselect(true)
    }
    
    let logoutRow = LabelRowFormer<FormLabelCell>()
    .configure { row in
      row.text = "Log Out"
      row.cellUpdate { cell in
        cell.titleLabel.textColor = UIColor.lightGrayColor()
        cell.titleLabel?.font = UIFont.asapBold(14)
      }
    }.onSelected { [weak self] row in
      self?.former.deselect(true)
    }
  
    let blankRow = LabelRowFormer<FormLabelCell>()
    .configure { row in
      row.rowHeight = screenSize.height
      row.enabled = false
    }

    let header = LabelViewFormer<FormLabelHeaderView>() { view in
      view.titleLabel.text = "Label Header"
    }
    
    let section = SectionFormer(rowFormer: editProfileRow, accountSettingsRow, helpCenterRow, termsPrivacyRow, logoutRow, blankRow)
    .set(headerViewFormer: header)
    
    former.append(sectionFormer: section)
  }
  
  private func disableRowSelected(rowFormer: RowFormer) {
//    guard let disableRow = rowFormer as? LabelRowFormer<FormLabelCell> else { return }
//    self.former.deselect(true)
//    self.former[1...2].flatMap { $0.rowFormers }.forEach { $0.enabled = !enabled }
//    disableRow.text = (enabled ? "Enable" : "Disable") + " All Cells"
//    disableRow.update()
//    self.enabled = !self.enabled
  }
}








*/