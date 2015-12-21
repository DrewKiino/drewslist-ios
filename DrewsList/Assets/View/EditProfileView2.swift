//
//  EditProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Former
import Toucan

public class EditProfileView2: FormViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let controller = EditProfileController()
  private var model: EditProfileModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds
  
  private var changePictureRow: LabelRowFormer<FormLabelCell>?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    
    tableView.scrollEnabled = false
    
    // configures cell
    // this closure runs only once when cell is initialized
    changePictureRow = LabelRowFormer<FormLabelCell>().configure { row in
      
      row.text = "Change Picture"
      
      // get the cell row
      let cell = row.cell
      
      // cell text color & font
      cell.titleLabel.textColor = UIColor.lightGrayColor()
      cell.titleLabel?.font = UIFont.asapRegular(14)
      
      // remove old image view
      cell.subviews.forEach { if $0.tag == 1 { $0.removeFromSuperview() } }
      
      // create image view
      let profileImgView :UIImageView? = UIImageView(frame: CGRect(
        x: screen.width - cell.frame.height * (8 / 5),
        y: cell.frame.height * (1 / 10),
        width: cell.frame.height * (4 / 5),
        height: cell.frame.height * (4 / 5))
      )
      
      // specify unique tag
      profileImgView?.tag = 10
      
      cell.addSubview(profileImgView!)
      
      cell.subviews.forEach { if $0.tag == 2 { $0.removeFromSuperview() } }
      var arrowImgView :UIImageView? = UIImageView(frame: CGRect(
        x: screen.width - cell.frame.height * (1 / 2),
        y: cell.frame.height * (1 / 4),
        width: cell.frame.height * (1 / 2),
        height: cell.frame.height * (1 / 2))
      )
      arrowImgView?.tag = 2
      cell.addSubview(arrowImgView!)
      
      let arrowImg = UIImage(named: "Icon-OrangeChevron")
      var arrowToucan: Toucan? = Toucan(image: arrowImg).resize(CGSize(width: arrowImgView!.height, height: arrowImgView!.height)).maskWithEllipse()
      arrowImgView?.image = arrowToucan?.image
      arrowToucan = nil
      arrowImgView = nil
    
    // on selected cell
    }.onSelected { row in
      self.former.deselect(true)
      self.presentImagePicker()
    }
    
    // on updated cell
    changePictureRow?.update { [weak self] row in
      
      log.debug(self?.model.user?.image)
      
      let cell = row.cell
      
      if let profileImageView = (cell.subviews.filter { $0 != nil ? $0.tag == 10 : false }).first as? UIImageView {
        // get image from url
        //        profileImgView?.dl_setImageFromUrl(self?.model.user?.image) { [weak profileImgView] image, error, cache, url in
        //
        //          // this closure is ran once image is returned from the web
        //
        //          // resize image with toucan and create rounded image using mask with ellipse
        //          var toucan1: Toucan? = Toucan(image: image).resize(profileImgView?.frame.size).maskWithEllipse()
        //
        //          // set the image
        //          profileImgView?.image = toucan1?.image
        //
        //          // nullify toucan
        //          toucan1 = nil
        //        }
      }
      
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
    
    let section = SectionFormer(rowFormer: changePictureRow!, firstNameRow, lastNameRow, usernameRow, blankRow)
      .set(headerViewFormer: header)
    former.append(sectionFormer: section)
    
    changePictureRow?.update { row in
    }
    
    controller.setUp()
  }
  
  // MARK: private functions
  
  private func setupDataBinding() {
    controller.model._user.listen(self) { [weak self] user in
      self?.changePictureRow?.update()
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
}