//
//  ListView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Gifu
import Toucan
import Haneke
import SwiftDate

public class ListView: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = ListController()
  
  private var tableView: UITableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    setupTableView()
    
    view.backgroundColor = UIColor.whiteColor()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  public func setListing(listing: Listing?) -> Bool {
    guard let listing = listing else { return false }
    
    controller.setListing(listing)
    
    return true
  }
  
  private func setupTableView() {
    tableView = UITableView()
    tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView?.registerClass(BookViewCell.self, forCellReuseIdentifier: "BookViewCell")
    tableView?.registerClass(ListerProfileViewCell.self, forCellReuseIdentifier: "ListerProfileViewCell")
    tableView?.registerClass(ListerAttributesViewCell.self, forCellReuseIdentifier: "ListerAttributesViewCell")
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.allowsSelection = false
    view.addSubview(tableView!)
  }
  
  private func setupDataBinding() {
  }
  
  // MARK: UITableView Delegates 
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 158
    case 1: return 40
    case 2: return 200
    default: return 0
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // get cell
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    let listing = controller.getListing()
    
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        // clear seperator lines
        cell.subviews.forEach { if let _ = $0 as? BookView { return } else { $0.removeFromSuperview() } }
        
        cell.bookView?.setBook(listing?.book)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.bookView?.setBook(listing?.book)
        }
      }
      return cell
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ListerProfileViewCell", forIndexPath: indexPath) as? ListerProfileViewCell {
        
        cell.setListing(listing?.highestLister)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.setListing(listing?.highestLister)
        }
      }
      return cell
    case 2:
      return cell
    default: return cell
    }
  }
}

public class BookViewCell: UITableViewCell {
  
  private var bookView: BookView? = BookView()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(bookView!)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    bookView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 150)
  }
}

public class ListerProfileViewCell: UITableViewCell {
  
  private var userImageView: UIImageView?
  private var nameLabel: UILabel?
  private var listDateLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUserImage()
    setupNameLabel()
    setupListDateLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    userImageView?.anchorInCorner(.TopLeft, xPad: 8, yPad: 8, width: 24, height: 24)

    nameLabel?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: userImageView!, padding: 8, width: 100)

    listDateLabel?.anchorInCorner(.TopRight, xPad: 8, yPad: 8, width: 100, height: 24)
  }
  
  private func setupUserImage() {
    userImageView = UIImageView()
    addSubview(userImageView!)
  }
  
  private func setupNameLabel() {
    nameLabel = UILabel()
    nameLabel?.font = UIFont.asapRegular(16)
    nameLabel?.adjustsFontSizeToFitWidth = true
    nameLabel?.minimumScaleFactor = 0.8
    addSubview(nameLabel!)
  }
  
  private func setupListDateLabel() {
    listDateLabel = UILabel()
    addSubview(listDateLabel!)
  }
  
  public func setListing(listing: Listing?) {
    guard let listing = listing, let user = listing.user else { return }
    
    if let url = user.image, let nsurl = NSURL(string: url) {
      userImageView?.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "Small_User_Images", diskCapacity: 10 * 1024 * 1024) { [unowned self] image in
        return Toucan(image: image).resize(self.userImageView!.frame.size, fitMode: .Crop).maskWithEllipse().image
      })
    }
    
    nameLabel?.text = user.username ?? user.getName()
    
    listDateLabel?.text = listing.createdAt
    
  }
  
  public override func setSelected(selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    if(selected) {
      userImageView?.backgroundColor = UIColor.whiteColor()
      nameLabel?.backgroundColor = UIColor.whiteColor()
      listDateLabel?.backgroundColor = UIColor.whiteColor()
    }
  }
  
  public override func setHighlighted(highlighted: Bool, animated: Bool) {
    super.setHighlighted(highlighted, animated: false)
    
    if(highlighted) {
      userImageView?.backgroundColor = UIColor.whiteColor()
      nameLabel?.backgroundColor = UIColor.whiteColor()
      listDateLabel?.backgroundColor = UIColor.whiteColor()
    }
  }
}

extension NSDate {
  struct Date {
    static let formatter = NSDateFormatter()
  }
  var formatted: String {
    Date.formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSX"
    Date.formatter.timeZone = NSTimeZone(forSecondsFromGMT: 0)
    Date.formatter.calendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierISO8601)!
    Date.formatter.locale = NSLocale(localeIdentifier: "en_US_POSIX")
    return Date.formatter.stringFromDate(self)
  }
}


public class ListerAttributesViewCell: UITableViewCell {
  
  private var priceLabel: UILabel?
  private var conditionLabel: UILabel?
  private var notesLabel: UILabel?
  
  private var chatButton: UIButton?
  private var callButton: UIButton?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    priceLabel?.anchorInCorner(.TopLeft, xPad: 8, yPad: 8, width: 100, height: 24)
    priceLabel?.backgroundColor = UIColor.redColor()
  }
  
  private func setupPriceLabel() {
    priceLabel = UILabel()
    addSubview(priceLabel!)
  }
  
  private func setupChatButton() {
    chatButton = UIButton()
    addSubview(chatButton!)
  }
  
  private func setupCallButton() {
    callButton = UIButton()
    addSubview(callButton!)
  }
}

















