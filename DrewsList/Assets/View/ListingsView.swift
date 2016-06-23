//
//  AddListingsView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 4/1/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Signals
import Social

public class ListingsView: DLViewController, UITableViewDataSource, UITableViewDelegate {
  
  private var tableView: DLTableView?
  
  private let resignFirstResponderSignal = Signal<()>()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupTableView()
    setupDataBinding()
    
    tableView?.fillSuperview()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public override func setupSelf() {
    super.setupSelf()
    title = "Listings"
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.backgroundColor = .whiteColor()
    
    tableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ListingsView.dismissKeyboard)))
    
    view.addSubview(tableView!)
  }
  
  private func setupDataBinding() {
    UserModel.sharedUser()._user.removeListener(self)
    UserModel.sharedUser()._user.listen(self) { [weak self] user in
      self?.tableView?.reloadData()
    }
  }
  
  public func dismissKeyboard() {
    resignFirstResponderSignal => ()
  }
  
  // MARK: Table View Functions
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0, 3: return 24
    default: return 36
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 7
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Availability"
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "'For Sale':"
        cell.titleTextLabel?.text = "\(UserModel.sharedUser().user?.freeListings ?? 0) Free Listing Left!"
        cell.hideSeparatorLine()
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "'For Purchase':"
        cell.titleTextLabel?.text = "Free"
        cell.hideSeparatorLine()
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Free Listings"
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("SelectableTitleCell", forIndexPath: indexPath) as? SelectableTitleCell {
        cell.titleLabel?.text = "Copy This Referral Code:"
        cell.selectableTextView?.text = UserModel.sharedUser().user?.referralCode
        resignFirstResponderSignal.removeListener(cell)
        resignFirstResponderSignal.listen(cell) { [weak cell] in
          cell?.resignFirstResponder()
        }
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("Share on Twitter!", forState: .Normal)
        cell.onClick = { [weak self] in
          if SLComposeViewController.isAvailableForServiceType(SLServiceTypeTwitter){
            self?.presentViewController(SLComposeViewController(forServiceType: SLServiceTypeTwitter), animated: true, completion: nil)
          } else {
            self?.showAlert("Accounts", message: "Please login to a Twitter account to share.")
          }
        }
        
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("Share on Facebook!", forState: .Normal)
        cell.onClick = { [weak self] in
          
          if SLComposeViewController.isAvailableForServiceType(SLServiceTypeFacebook){
            self?.presentViewController(SLComposeViewController(forServiceType: SLServiceTypeFacebook), animated: true, completion: nil)
          } else {
            self?.showAlert("Accounts", message: "Please login to a Facebook account to share.")
          }
        }
        
        return cell
      }
      break
    default: break
    }
    
    return DLTableViewCell()
  }
}

public class SelectableTitleCell: DLTableViewCell {
  
  public var titleLabel: UILabel?
  public var selectableTextView: UITextView?
  public var executeOnTap: (() -> Void)?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupTitleTextLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 8, yPad: 0, otherSize: 120)
//    titleLabel?.backgroundColor = .redColor()
    selectableTextView?.anchorAndFillEdge(.Right, xPad: 8, yPad: 0, otherSize: 120)
//    selectableTextView?.backgroundColor = .blueColor()
  }
  
  public override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SelectableTitleCell.onTap)))
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel?.textColor = .sexyGray()
    titleLabel?.font = .asapRegular(12)
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.minimumScaleFactor = 0.8
    addSubview(titleLabel!)
  }
  
  private func setupTitleTextLabel() {
    selectableTextView = UITextView()
    selectableTextView?.textColor = .coolBlack()
    selectableTextView?.font = .asapBold(16)
    selectableTextView?.editable = false
    selectableTextView?.textAlignment = .Right
    addSubview(selectableTextView!)
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    selectableTextView?.resignFirstResponder()
    
    return true
  }
  
  public func onTap() {
    
    
    
    executeOnTap?()
  }
}
