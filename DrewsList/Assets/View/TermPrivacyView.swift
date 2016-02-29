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
public class TermPrivacyView: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
  
  //NavView
  private var tableView: DLTableView?
//  private var HeaderView: UIView?
//  private var BackButton: UIButton?
//  private var HeaderTitle: UILabel?
//  private var TermPriLabel: UILabel!
//  var myLabel:UILabel = UILabel(frame: CGRectMake(7, 5, 370, 600))
  
  private let TERMS_AND_PRIVACY = "Drew's List Privacy Policy (updated January 1st, 2016).\n\nThis policy details This policy details how data about you is used when you access our mobile app and services (together, DL) or interact with us. If we update it, we will revise the date, place notices on DL if changes are material, and/or obtain your consent as required by law.\n\n1. Protecting your Privacy: We take precautions to prevent unauthorized access to or misuse of data about you.We do not employ tracking devices for marketing purposes.Please review privacy policies of any third party sites linked to from DL.\n\n2. Data we use to provide/improve our services and/or combat fraud/abuse: Data you post on or send via DL, and/or send us directly or via other sites credit card data, which is transmitted to payment processors via a security protocol (e.g. SSL). data you submit or provide (e.g. name, address, email,phone, fax, photos, tax ID).data collected via cookies (e.g. search data and  favorites lists). data about your device(s) (e.g. screen size, DOM local storage, plugins).data from 3rd parties (e.g. phone type, geo-location via IP address).Data provided by Facebook integration (e.g. General Information, email).\n\n3. Data we store: We retain data as needed for our business purposes and/or as required by law. We make good faith efforts to store data securely, but can make no guarantees. You may access and update certain data about you via your account login.\n\n4. Circumstances in which we may disclose user data: to vendors and service providers (e.g. payment processors) working on our behalf. to respond to subpoenas, search warrants, court orders, or other legal process. to protect our rights, property, or safety, or that of users of CL or the general public. with your consent (e.g. if you authorize us to share data with other users). in connection with a merger, bankruptcy, or sale/transfer of assets. in aggregate/summary form, where it cannot reasonably be used to identify you. To third party marketing companies.\n\n5. International Users - By accessing DL or providing us data, you agree we may use and disclose data we collect as described here or as communicated to you, transmit it outside your resident jurisdiction, and store it on servers in the United States. For more information please contact our privacy officer at privacy@drewslist.com."

 
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpSelf()
    setupTableView()
    
//    HeaderView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
//    HeaderTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
//    BackButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
//    TableView?.alignAndFill(align: .UnderCentered, relativeTo: HeaderView!, padding: 0)
    
    
    
//    myLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
//    myLabel.numberOfLines = 0                      //'0' means infinite number of lines
//    myLabel.textColor = UIColor.sexyGray()
//    myLabel.text =
//
//
//    self.view.addSubview(myLabel)
    
    tableView?.fillSuperview()
    
    FBSDKController().createCustomEventForName("UserTermPrivacy")
  }
  
  // MARK: DLTableView delegates  
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return TERMS_AND_PRIVACY.height(screen.width)
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextViewCell", forIndexPath: indexPath) as? InputTextViewCell {
      cell.inputTextView?.text = TERMS_AND_PRIVACY
      cell.inputTextView?.userInteractionEnabled = false
      return cell
    }
    
    return DLTableViewCell()
  }
  
  private func setUpSelf() {
    view.backgroundColor = .whiteColor()
    title = "Terms & Privacy"
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.backgroundColor = .whiteColor()
    view.addSubview(tableView!)
  }
  
}


