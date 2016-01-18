//
//  TermPrivacyView.swift
//  DrewsList
//
//  Created by Starflyer on 1/15/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import TextFieldEffects
import KMPlaceholderTextView
import SwiftyButton



//UnderConstruction!
class TermPrivacyView: UIViewController, UITableViewDelegate, UITextFieldDelegate {
  
  
  
  //NavView
  private var TableView: DLTableView?
  private var HeaderView: UIView?
  private var BackButton: UIButton?
  private var HeaderTitle: UILabel?
  private var TermPriLabel: UILabel!
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    SetUpSelf()
    SetUpHeaderView()
    //TermPriSelf()
  
    
    
    HeaderView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
    HeaderTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
    BackButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
    
    TableView?.alignAndFill(align: .UnderCentered, relativeTo: HeaderView!, padding: 0)
  
    
  }
  
  
  private func SetUpSelf() {
    view.backgroundColor = .whiteColor()
    
  }
  
  private func SetUpHeaderView() {
    HeaderView = UIView()
    HeaderView?.backgroundColor = .soothingBlue()
    view.addSubview(HeaderView!)
    
    HeaderTitle = UILabel()
    HeaderTitle?.text = "Term & Privacy"
    HeaderTitle?.font = UIFont.asapBold(16)
    HeaderTitle?.textColor = .whiteColor()
    HeaderView?.addSubview(HeaderTitle!)
    
    BackButton = UIButton()
    BackButton?.setTitle("Back", forState: .Normal)
    BackButton?.titleLabel?.font = UIFont.asapBold(12)
    HeaderView?.addSubview(BackButton!)
    
    
  }
  

  
//  private func TermPriSelf() {
//    
//    TermPriLabel?.backgroundColor = .bareBlue()
//    TermPriLabel?.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Hello Ispumspisum"
//    TermPriLabel?.textAlignment = .Center
//    TermPriLabel?.font = UIFont.boldSystemFontOfSize(15)
//    TermPriLabel?.textColor = UIColor.whiteColor()
//    TermPriLabel?.numberOfLines = 0
//    view.addSubview(TermPriLabel!)
//    
//    
//    
//  }
//  
//  
//  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
}
