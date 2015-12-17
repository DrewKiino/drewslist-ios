//
//  AcctSettingView.swift
//  DrewsList
//
//  Created by Starflyer on 12/16/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import Former


final class AcctSettingView: FormViewController {

  
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    

    let textFields = TextFieldRowFormer<FormTextFieldCell>() {
      
        $0.titleLabel.text = "Email"
        $0.titleLabel.textColor = UIColor.juicyOrange()
        $0.titleLabel.font = .boldSystemFontOfSize(16)
        $0.textField.textColor = UIColor.bareBlue()
        $0.titleLabel.font = .boldSystemFontOfSize(14)
        $0.textField.returnKeyType = .Next
        $0.tintColor = UIColor.sexyGray()
      
  }
    
//    let createSelectorRow = { (
//      text: String,
//      subText: String,
//      onSelected: (RowFormer -> Void)?
//      ) -> RowFormer in
//      return LabelRowFormer<FormLabelCell>() {
//        $0.titleLabel.textColor = UIColor.sexyGray()
//        $0.titleLabel.font = .boldSystemFontOfSize(16)
//        $0.subTextLabel.textColor = UIColor.sexyGray()
//        $0.subTextLabel.font = .boldSystemFontOfSize(14)
//        $0.accessoryType = .DisclosureIndicator
//        }.configure { form in
//          _ = onSelected.map { form.onSelected($0) }
//          form.text = text
//          form.subText = subText
//      }
//    }
//    let options = ["Option1", "Option2", "Option3"]
//    
//    let pushSelectorRow = createSelectorRow("Push", options[0], pushSelectorRowSelected(options))
//    
//    private func pushSelectorRowSelected(options: [String])(rowFormer: RowFormer) {
//      if let rowFormer = rowFormer as? LabelRowFormer<FormLabelCell> {
//        let controller = TextSelectorViewContoller()
//        controller.texts = options
//        controller.selectedText = rowFormer.subText
//        controller.onSelected = {
//          rowFormer.subText = $0
//          rowFormer.update()
//        }
//        navigationController?.pushViewController(controller, animated: true)
//      }
//    }
//    
//    
//    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    let labelRow = LabelRowFormer<FormLabelCell>()
      .configure { row in
        row.text = "Label Cell"
      }.onSelected { row in
        // Do Something
    }
//
//    let inlinePickerRow = InlinePickerRowFormer<FormInlinePickerCell, Int>() {
//      $0.titleLabel.text = "Inline Picker Cell"
//      }.configure { row in
//        row.pickerItems = (1...5).map {
//          InlinePickerItem(title: "Option\($0)", value: Int($0))
//        }
//      }.onValueChanged { item in
//        // Do Something
//    }

    let header = LabelViewFormer<FormLabelHeaderView>() { view in
      view.titleLabel.text = "Account Setting"
    }
    let section1 = SectionFormer(rowFormer: textFields, labelRow)
      .set(headerViewFormer: header)
    former.append(sectionFormer: section1)
  }
}








