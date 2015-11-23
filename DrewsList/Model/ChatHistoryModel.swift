//
//  ChatListModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import RealmSwift
import UIKit

public class ChatHistoryModel {
  
  public let _chat = Signal<[ChatModel]>()
  public var chat = [ChatModel]() { didSet { _chat => chat } }
  
  public init() {
  }
}

public class ChatListViewCell: UITableViewCell {
  
  public var profileImageView: UIImageView?
  public var usernameLabel: UILabel?
  public var bookTitleLabel: UILabel?
  public var lastchatLabel: UILabel?
  public var rightView: UIView?
  private var doOnce = true
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    profileImageView = UIImageView()
    profileImageView?.anchorInCorner(.TopLeft, xPad: 8, yPad: 8, width: 48, height: 48)
    addSubview(profileImageView!)
    
    rightView = UIView()
    addSubview(rightView!)
    
    usernameLabel = UILabel()
    usernameLabel?.font = UIFont.helvetica(12)
    rightView?.addSubview(usernameLabel!)
    
    bookTitleLabel = UILabel()
    bookTitleLabel?.textColor = UIColor.sexyGray()
    bookTitleLabel?.font = UIFont.helvetica(8)
    rightView?.addSubview(bookTitleLabel!)
    
    lastchatLabel = UILabel()
    lastchatLabel?.textColor = UIColor.juicyOrange()
    lastchatLabel?.font = UIFont.helvetica(10)
    lastchatLabel?.numberOfLines = 0
    rightView?.addSubview(lastchatLabel!)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    rightView?.alignAndFillWidth(align: .ToTheRightMatchingTop, relativeTo: profileImageView!, padding: 8, height: 48)
    usernameLabel?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 12)
    bookTitleLabel?.anchorAndFillEdge(.Top, xPad: 0, yPad: 10, otherSize: 12)
    lastchatLabel?.anchorAndFillEdge(.Top, xPad: 0, yPad: 20, otherSize: 24)
    
    if doOnce {
      let border = CALayer()
      let width = CGFloat(1.0)
      border.frame = CGRect(x: 0, y: rightView!.frame.size.height - width, width:  rightView!.frame.size.width, height: rightView!.frame.size.height)
      border.borderColor = UIColor.bareBlue().CGColor
      border.opacity = 0.1
      
      border.borderWidth = width
      rightView?.layer.addSublayer(border)
      rightView?.layer.masksToBounds = true
      
      doOnce = false
    }
  }
}


