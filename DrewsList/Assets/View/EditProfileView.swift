//
//  EditProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Former
import Toucan

public class EditProfileView: FormViewController {
  
  private let screenSize = UIScreen.mainScreen().bounds
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    tableView.scrollEnabled = false
    
    let changePictureRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Change Picture"
        
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
          
          //cell.imageView?.image = Toucan(image: UIImage(named: "j")).maskWithEllipse().image
        }
      }.onSelected { row in
        //navigationController?.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: <#T##Bool#>)
    }
    
    let firstNameRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "First Name"
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
        }
      }.onSelected { row in
        // Do Something
    }
    
    let lastNameRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Last Name"
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
        }
      }.onSelected { row in
        // Do Something
    }
    
    let usernameRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Username"
        row.cellUpdate { cell in
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
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
    
    let section = SectionFormer(rowFormer: changePictureRow, firstNameRow, lastNameRow, usernameRow, blankRow)
      .set(headerViewFormer: header)
    former.append(sectionFormer: section)
    
  }
}