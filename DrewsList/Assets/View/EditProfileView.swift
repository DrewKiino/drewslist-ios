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
          // cell text color & font
          cell.titleLabel.textColor = UIColor.lightGrayColor()
          cell.titleLabel?.font = UIFont.asapRegular(14)
          
          // cell add profile view
          cell.subviews.forEach { if $0.tag == 1 { $0.removeFromSuperview() } }
          var profileImgView :UIImageView? = UIImageView(frame: CGRect(x: screenSize.width-cell.frame.height*(8/5), y: cell.frame.height*(1/10), width: cell.frame.height*(4/5), height: cell.frame.height*(4/5)))
          profileImgView?.tag = 1
          cell.addSubview(profileImgView!)
          let profileImg = UIImage(named: "Icon-Condition2")
          var profileToucan: Toucan? = Toucan(image: profileImg).resize(CGSize(width: profileImgView!.height, height: profileImgView!.height)).maskWithEllipse()
          profileImgView?.image = profileToucan?.image
          profileToucan = nil
          profileImgView = nil
          
          // cell add arrow
          cell.subviews.forEach { if $0.tag == 2 { $0.removeFromSuperview() } }
          var arrowImgView :UIImageView? = UIImageView(frame: CGRect(x: screenSize.width-cell.frame.height*(1/2), y: cell.frame.height*(1/4), width: cell.frame.height*(1/2), height: cell.frame.height*(1/2)))
          arrowImgView?.tag = 2
          cell.addSubview(arrowImgView!)
         
          let arrowImg = UIImage(named: "Icon-OrangeChevron")
          var arrowToucan: Toucan? = Toucan(image: arrowImg).resize(CGSize(width: arrowImgView!.height, height: arrowImgView!.height)).maskWithEllipse()
          arrowImgView?.image = arrowToucan?.image
          arrowToucan = nil
          arrowImgView = nil
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