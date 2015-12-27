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
  
  static func names() -> [String] { return ["None", "Fade", "Right", "Left", "Top", "Bottom", "Middle", "Automatic"] }
  
  static func all() -> [UITableViewRowAnimation] { return [.None, .Fade, .Right, .Left, .Top, .Bottom, .Middle, .Automatic] }
}


public class AccountSettingsView3: FormViewController {
  
  private let controller = AccountSettingsController()
  private var model: AccountSettingsModel { get { return controller.getModel() } }
  
  private var emailRow: LabelRowFormer<FormLabelCell>?

  override public func viewDidLoad() {
    super.viewDidLoad()
    
    // Former is not databind friendly :/
    NSTimer.after(5.0) {
//      self.model._test.fire("TEST!")
    }
    
    //AcctSettingView
    emailRow = LabelRowFormer<FormLabelCell>()
    .configure { [unowned self] row in
      row.text = "Email"
      row.textDisabledColor = UIColor.bareBlue()
      row.subText = "erolnoble@gmail.com"
      
//      self.model._test.listen(self) { string in
//        row.subText = string
//      }
      
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
    
    let EmailSection = SectionFormer(rowFormer: emailRow!, PasswordRow,SchoolRow)
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
  
  func configure() {
    title = "Account Settings"
    tableView.contentInset.bottom = 30
  }

  private func setupPushPermissions(view: UIView) {
  }

  private func setupEmailPermissions(view: UIView) {
  }

  private func setupLoginFBPermissions(view: UIView) {
  }
}



