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
        // Do Something
    }
    
    let helpCenterRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Help Center"
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
        }
      }.onSelected { row in
        // Do Something
    }
    
    let termsPrivacyRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Terms & Privacy"
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
        }
      }.onSelected { row in
        // Do Something
    }
    
    let logoutRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Log Out"
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapBold(14)
        }
      }.onSelected { row in
        // Do Something
    }
  
    let blankRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.rowHeight = screenSize.height
        row.enabled = false
      }.onSelected { row in
        
    }
    

    let header = LabelViewFormer<FormLabelHeaderView>() { view in
      view.titleLabel.text = "Label Header"
    }
    
    let section = SectionFormer(rowFormer: editProfileRow, accountSettingsRow, helpCenterRow, termsPrivacyRow, logoutRow, blankRow)
      .set(headerViewFormer: header)
    former.append(sectionFormer: section)
    
  }
}