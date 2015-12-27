//
//  SettingsView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Former
import RealmSwift

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
      self.navigationController?.pushViewController(EditProfileView(), animated: true)
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
      self?.navigationController?.pushViewController(AccountSettingsView(), animated: true)
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
      
      // deletes the current user, then will log user out.
      self?.deleteRealmUser()
      // since the current user does not exist anymore
      // we ask the tab view to check any current user, since we have no current user
      // it will present the login screen
      self?.navigationController?.popToRootViewControllerAnimated(true)
      if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView { tabView.checkIfUserIsLoggedIn() }
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
    guard let disableRow = rowFormer as? LabelRowFormer<FormLabelCell> else { return }
    self.former.deselect(true)
    self.former[1...2].flatMap { $0.rowFormers }.forEach { $0.enabled = !enabled }
    disableRow.text = (enabled ? "Enable" : "Disable") + " All Cells"
    disableRow.update()
    self.enabled = !self.enabled
  }
  
  
  // this one deletes all prior users, on logout.
  public func deleteRealmUser(){ try! Realm().write { try! Realm().delete(try! Realm().objects(RealmUser.self)) } }
}







