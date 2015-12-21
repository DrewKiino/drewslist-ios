//
//  AcctSettingView.swift
//  DrewsList
//
//  Created by Starflyer on 12/16/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import Former

private extension UITableViewRowAnimation {
  
  static func names() -> [String] {
    return ["None", "Fade", "Right", "Left", "Top", "Bottom", "Middle", "Automatic"]
  }
  
  static func all() -> [UITableViewRowAnimation] {
    return [.None, .Fade, .Right, .Left, .Top, .Bottom, .Middle, .Automatic]
  }
}


final class AcctSettingView: FormViewController {

  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    
    
  func configure() {
      title = "Account Settings"
      tableView.contentInset.bottom = 30

  }

    //DBG
//    func viewWillAppear(animated: Bool) {
//      super.viewWillAppear(animated)
//      former.deselect(true)
//    }

    //DBG
    //let inputAccessoryView = FormerInputAccessoryView(former: Former)

    //DBG
//    let textFields = TextFieldRowFormer<FormTextFieldCell>() {
//      
//        $0.titleLabel.text = "Email"
//        $0.titleLabel.textColor = UIColor.juicyOrange()
//        $0.titleLabel.font = .boldSystemFontOfSize(16)
//        $0.textField.textColor = UIColor.bareBlue()
//        $0.titleLabel.font = .boldSystemFontOfSize(14)
//        $0.textField.returnKeyType = .Next
//        $0.tintColor = UIColor.sexyGray()
//      
//  }
    
    
    //AcctSettingView
    let EmailRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Email"
        row.textDisabledColor = UIColor.bareBlue()
        row.subText = "erolnoble@gmail.com"
      }.onSelected { row in
        // Do Something//Action
    }
    
    let PasswordRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "UserName"
        row.subText = "Vergil611"
      }.onSelected { row in
        // Do Something//Action
    }
    
    let SchoolRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "School"
        row.subText = "Cal State Los Angeles"
      }.onSelected { row in
         //Do Something//Action
    }

    
    let PSCheckRow = CheckRowFormer<FormCheckCell>() {
      $0.titleLabel.text = "Push Notification"
      $0.titleLabel.textColor = UIColor.juicyOrange()
      $0.titleLabel.font = UIFont.asapBold(16)
      }.configure {
        let check = UIImage(named: "check")!.imageWithRenderingMode(.AlwaysTemplate)
        let checkView = UIImageView(image: check)
        checkView.tintColor = UIColor.bareBlue()
        $0.customCheckView = checkView
    }
    
    let EMCheckRow = CheckRowFormer<FormCheckCell>() {
      $0.titleLabel.text = "Email Notification"
      $0.titleLabel.textColor = UIColor.juicyOrange()
      $0.titleLabel.font = UIFont.asapBold(16)
      
      }.configure {
        let check = UIImage(named: "check")!.imageWithRenderingMode(.AlwaysTemplate)
        let checkView = UIImageView(image: check)
        checkView.tintColor = UIColor.bareBlue()
        $0.customCheckView = checkView
        
    }
    
    
    let createMenu: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
      return LabelRowFormer<FormLabelCell>() {
        $0.titleLabel.textColor = UIColor.bareBlue()
        $0.titleLabel.font = .boldSystemFontOfSize(16)
        $0.accessoryType = .DisclosureIndicator
        }.configure {
          $0.text = text
        }.onSelected { _ in
          onSelected?()
      }
    }
    
    let FB_Row = createMenu("Log In Facebook") { [weak self] in
      self?.navigationController?.pushViewController(SignUpView(), animated: true)
    
    }
    
    let ClearBrow_row = createMenu("Clear Browsing History") { [weak self] in
        self?.navigationController?.pushViewController(LoginView(), animated: true)
    }
    
    let DeActive_row = createMenu("Deactivate Your Account") { [weak self] in
        self?.navigationController?.pushViewController(BookFeedView(), animated: true)
      
    }
    
    //Need to Use
    let createNav: ((String, (() -> Void)?) -> RowFormer) = { text, onSelected in
      return LabelRowFormer<FormLabelCell>() {
        $0.titleLabel.textColor = UIColor.bareBlue()
        $0.titleLabel.font = .boldSystemFontOfSize(16)
        $0.accessoryType = .DisclosureIndicator
        }.configure {
          $0.text = text
        }.onSelected { _ in
          onSelected?()
      }
    }

    let Terms_of_Use = createMenu("Terms Of Use") { [weak self] in
      self?.navigationController?.pushViewController(BookFeedView(), animated: true)
      
    }
    

    //DBG
//    let createSelectRow = { (
//      text: String,
//      subtext: String,
//      onSelected: (RowFormer -> Void)?
//      
//   ) -> RowFormer in
//      return LabelRowFormer<FormLabelCell>() {
//        $0.titleLabel.textColor = UIColor.juicyOrange()
//        $0.titleLabel.font = UIFont.asapBold(16)
//        $0.subTextLabel.textColor = UIColor.juicyOrange()
//        $0.subTextLabel.font = UIFont.asapBold(14)
//        $0.accessoryType = .DisclosureIndicator
//        
//        }.configure { form in
//          _ = onSelected.map { form.onSelected($0) }
//          form.text = text
//          //form.subText = subText
//      }
//    }
//    
//     let options = ["Yes", "No", "Maybe So"]
//    
//     //let CB_SheetSelectorRow = createSelectRow("Sheet", options[0],
//      //sheetSelectorRowSelected(options))
//    
//    
//  
//    let pickerSelectorRow = SelectorPickerRowFormer<FormSelectorPickerCell, Any> {
//      $0.titleLabel.text = "Picker"
//      $0.titleLabel.textColor = UIColor.juicyOrange()
//      $0.titleLabel.font = .boldSystemFontOfSize(16)
//      $0.displayLabel.textColor = UIColor.juicyOrange()
//      $0.displayLabel.font = .boldSystemFontOfSize(14)
//      $0.accessoryType = .DisclosureIndicator
//      }.configure {
//        $0.selectorViewUpdate {
//          $0.backgroundColor = .whiteColor()
//        }
//        $0.pickerItems = options.map { SelectorPickerItem(title: $0) }
//        $0.inputAccessoryView = inputAccessoryView
//        $0.displayEditingColor = UIColor.bareBlue()
//    
//    }
//    
//    
//    
//  
//     func sheetSelectorRowSelected(options: [String?]) (rowFormer: RowFormer) {
//      if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
//        let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
//        options.forEach { title in
//          sheet.addAction(UIAlertAction(title: title, style: .Default, handler: {
//            [weak rowFormer] _ in
//            rowFormer?.subText = title
//            rowFormer?.update()
//    
//            })
//          )
//        }
//    
//        sheet.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: nil))
//       //sheet.presentedViewController(sheet, animated: true, completion: nil)
//       //Former.deselect(true)
//        
//      }
//      
//      
//      
//      
//    }
//    
//
    
    
    
    //Create_Heaaders_Footers
    let createHeader: (String -> ViewFormer) = { text in
      return LabelViewFormer<FormLabelHeaderView>()
        .configure {
          $0.text = text
          $0.viewHeight = 40
      }
    }
    
    let createFooter: (String -> ViewFormer) = { text in
      return LabelViewFormer<FormLabelFooterView>()
        .configure {
          $0.text = text
          $0.viewHeight = 100
      }
    }
    
    
  
    
    let header = LabelViewFormer<FormLabelHeaderView>() { view in
      view.titleLabel.text = "Account Setting"
    }
    
    
    
    let EmailSection = SectionFormer(rowFormer: EmailRow, PasswordRow,SchoolRow)
    .set(headerViewFormer: createHeader("Email, UserName & School Setting"))
    let Permissions = SectionFormer(rowFormer: PSCheckRow, EMCheckRow)
    .set(headerViewFormer: createHeader("Permissions"))
    let facebook = SectionFormer(rowFormer: FB_Row,ClearBrow_row,DeActive_row)
    .set(headerViewFormer: createHeader("Settings"))
    let TOU = SectionFormer(rowFormer: Terms_of_Use)
    .set(headerViewFormer: createHeader("Term of Usage"))
    .set(footerViewFormer: createFooter("© Drew's List"))
    
    former.append(sectionFormer: EmailSection, Permissions, facebook, TOU)
  }
}

private func setupPushPermissions(view: UIView) {
  
  
}

private func setupEmailPermissions(view: UIView) {
  
  
}

private func setupLoginFBPermissions(view: UIView) {
  
  
}



