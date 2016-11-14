//
//  Extensions.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

public class BasicViewController: UIViewController {
  
  public init() {
    super.init(nibName: nil, bundle: nil)
    setup()
  }
  
  required public init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public func setup() {
    view.backgroundColor = .whiteColor()
  }
}
public class BasicView: UIView {
  
  public init() {
    super.init(frame: CGRectZero)
    setup()
  }
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public func setup() {
    backgroundColor = .whiteColor()
  }
}

public class BasicCell: UITableViewCell {
  
  public init() {
    super.init(style: .Default, reuseIdentifier: nil)
    setup()
  }
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setup()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }
  
  public func setup() {
    backgroundColor = .whiteColor()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
}


extension String {
  
  public func toInt() -> Int? {
    return Int(self)
  }
  
  public func isValidPhone() -> Bool {
    let phoneRegex = "^\\d{3}-\\d{3}-\\d{4}$"
    let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
    let result =  phoneTest.evaluateWithObject(self)
    return isEmpty ? false : result
  }
  
  public func isValidEmail() -> Bool {
    let emailRegex = "[a-z0-9._%+-]+@[a-z0-9.-]+\\.[a-z]{2,63}$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegex)
    let result = emailTest.evaluateWithObject(self)
    return isEmpty ? false : result
  }
  
  public func toDate() -> NSDate? {
    let serverDateFormatter = NSDateFormatter()
    serverDateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss" // 2015-06-03 13:53:42
    return serverDateFormatter.dateFromString(self)
  }
  
  public func stringFromPascalCase() -> String {
    return self.stringByReplacingOccurrencesOfString(" ", withString: "").characters.enumerate().map { (String($1).componentsSeparatedByCharactersInSet(.uppercaseLetterCharacterSet()).joinWithSeparator("").isEmpty && $0 > 0) ? " \($1)" : "\($1)" }.joinWithSeparator("")
  }
  
  public func height(width: CGFloat, font: UIFont? = UIFont.systemFontOfSize(12)) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
    label.adjustsFontSizeToFitWidth = false
    label.numberOfLines = 0
    label.lineBreakMode = .ByWordWrapping
    label.text = self
    label.font = font
    label.sizeToFit()
    return label.frame.height
  }
  
  public func width(height: CGFloat, font: UIFont = UIFont.systemFontOfSize(12)) -> CGFloat {
    let label:UILabel = UILabel(frame: CGRectMake(0, 0, CGFloat.max, height))
    label.adjustsFontSizeToFitWidth = false
    label.numberOfLines = 0
    label.lineBreakMode = .ByWordWrapping
    label.text = self
    label.font = font
    label.sizeToFit()
    return label.frame.width
  }
}
