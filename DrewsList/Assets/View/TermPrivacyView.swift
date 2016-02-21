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
  var myLabel:UILabel = UILabel(frame: CGRectMake(7, 5, 370, 600))
 

  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    SetUpSelf()
    
    HeaderView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
    HeaderTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
    BackButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
    TableView?.alignAndFill(align: .UnderCentered, relativeTo: HeaderView!, padding: 0)
    
    
    
    myLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
    myLabel.numberOfLines = 0                      //'0' means infinite number of lines
    myLabel.textColor = UIColor.sexyGray()
    myLabel.text = "Drew's List Privacy Policy (updated January 1st, 2016).This policy details This policy details how data about you is used when you access our mobile app and services (together, DL) or interact with us. If we update it, we will revise the date, place notices on DL if changes are material, and/or obtain your consent as required by law. 1. Protecting your Privacy: We take precautions to prevent unauthorized access to or misuse of data about you.We do not employ tracking devices for marketing purposes.Please review privacy policies of any third party sites linked to from DL. 2. Data we use to provide/improve our services and/or combat fraud/abuse: Data you post on or send via DL, and/or send us directly or via other sites credit card data, which is transmitted to payment processors via a security protocol (e.g. SSL). data you submit or provide (e.g. name, address, email,phone, fax, photos, tax ID).data collected via cookies (e.g. search data and  favorites lists). data about your device(s) (e.g. screen size, DOM local storage, plugins).data from 3rd parties (e.g. phone type, geo-location via IP address).Data provided by Facebook integration (e.g. General Information, email). 3. Data we store: We retain data as needed for our business purposes and/or as required by law. We make good faith efforts to store data securely, but can make no guarantees. You may access and update certain data about you via your account login."


    self.view.addSubview(myLabel)
    
  }
  
  
  private func SetUpSelf() {
    view.backgroundColor = .whiteColor()
    title = "Terms & Privacy"
   
  }
  
}
