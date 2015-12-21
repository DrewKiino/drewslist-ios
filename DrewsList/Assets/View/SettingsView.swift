//
//  SettingsView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Former

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
        let editProfileView = EditProfileView()
        self.navigationController?.pushViewController(editProfileView, animated: true)
    }
    
    let accountSettingsRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Account Settings"
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
        }
      }.onSelected { row in
        self.former.deselect(true)
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
      }.onSelected { row in
        self.former.deselect(true)
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
    self.former[1...2].flatMap { $0.rowFormers }.forEach {
      $0.enabled = !enabled
    }
    disableRow.text = (enabled ? "Enable" : "Disable") + " All Cells"
    disableRow.update()
    self.enabled = !self.enabled
  }
  
  
}