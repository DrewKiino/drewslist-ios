//
//  AddListingsView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 4/1/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation

public class ListingsView: DLViewController, UITableViewDataSource, UITableViewDelegate {
  
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupTableView()
    
    tableView?.fillSuperview()
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
    
    view.addSubview(tableView!)
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0, 3: return 24
    default: return 36
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
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
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("Refer a Friend!", forState: .Normal)
        
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("Share this App!", forState: .Normal)
        
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
  public var titleTextLabel: UILabel?
  public var buttonLabel: UIButton?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupTitleTextLabel()
    setupButtonLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 8, yPad: 0, otherSize: 80)
    titleTextLabel?.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: titleLabel!, padding: 8, height: 24)
    buttonLabel?.anchorToEdge(.Right, padding: 8, width: 36, height: 36)
  }
  
  public override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
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
    titleTextLabel = UILabel()
    titleTextLabel?.textColor = .coolBlack()
    titleTextLabel?.font = .asapRegular(12)
    titleTextLabel?.adjustsFontSizeToFitWidth = true
    titleTextLabel?.minimumScaleFactor = 0.8
    addSubview(titleTextLabel!)
  }
  
  private func setupButtonLabel() {
    buttonLabel = UIButton(type: .ContactAdd)
//    buttonLabel?.titleLabel?.font = .asapRegular(12)
//    buttonLabel?.setTitleColor(.coolBlack(), forState: .Normal)
    addSubview(buttonLabel!)
  }
}
