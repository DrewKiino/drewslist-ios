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
      if let cell = tableView.dequeueReusableCellWithIdentifier("ListerAttributesViewCell", forIndexPath: indexPath) as? ListerAttributesViewCell {
        
        cell.setListing(listing?.highestLister)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.setListing(listing?.highestLister)
        }
      }
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
  private var listDateTitle: UILabel?
  private var listDateLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUserImage()
    setupNameLabel()
    setupListDateLabel()
    setupListDateTitle()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    userImageView?.anchorInCorner(.TopLeft, xPad: 8, yPad: 8, width: 24, height: 24)

    nameLabel?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: userImageView!, padding: 8, width: 180)

    listDateTitle?.anchorInCorner(.TopRight, xPad: 8, yPad: 8, width: 100, height: 12)
    listDateLabel?.anchorInCorner(.BottomRight, xPad: 8, yPad: 8, width: 100, height: 12)
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
  
  private func setupListDateTitle() {
    listDateTitle = UILabel()
    listDateTitle?.font = UIFont.asapBold(10)
    listDateTitle?.textAlignment = .Right
    addSubview(listDateTitle!)
  }
  
  private func setupListDateLabel() {
    
    listDateLabel = UILabel()
    listDateLabel?.font = UIFont.asapRegular(10)
    listDateLabel?.textAlignment = .Right
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
    
    // NOTE: DONT FORGET THESE CODES OMFG
    // converts the date strings sent from the server to local time strings
    if  let dateString = listing.createdAt?.toRegion(.ISO8601, region: Region.LocalRegion())?.toShortString(true, time: false),
        let relativeString = listing.createdAt?.toDateFromISO8601()?.toRelativeString(abbreviated: true, maxUnits: 2)
    {
      let coloredString = NSMutableAttributedString(string: "Listed At \(dateString)")
      coloredString.addAttribute(NSFontAttributeName, value: UIFont.asapBold(10), range: NSRange(location: 0,length: 10))

      listDateTitle?.attributedText = coloredString
      listDateLabel?.text = "\(relativeString) ago"
    }
  }
}

public class ListerAttributesViewCell: UITableViewCell {
  
  private var priceLabel: UILabel?
  private var conditionLabel: UILabel?
  private var conditionImageView: UIImageView?
  private var notesTitle: UILabel?
  private var notesTextViewContainer: UIView?
  private var notesTextView: UITextView?
  
  private var chatButton: UIButton?
  private var callButton: UIButton?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupPriceLabel()
    setupChatButton()
    setupCallButton()
    setupConditionLabel()
    setupNotesTitle()
    setupNotesTextViewContainer()
    setupNotesTextView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    priceLabel?.anchorInCorner(.TopLeft, xPad: 16, yPad: 16, width: 200, height: 12)
    
    callButton?.anchorInCorner(.TopRight, xPad: 16, yPad: 16, width: 24, height: 24)
    
    if let image = UIImage(named: "Icon-CallButton") {
      let toucan = Toucan(image: image).resize(callButton!.frame.size)
      callButton?.setImage(toucan.image, forState: .Normal)
    }
    
    chatButton?.align(.ToTheLeftCentered, relativeTo: callButton!, padding: 24, width: 24, height: 24)
    
    if let image = UIImage(named: "Icon-MessageButton") {
      let toucan = Toucan(image: image).resize(chatButton!.frame.size)
      chatButton?.setImage(toucan.image, forState: .Normal)
    }
    
    conditionLabel?.align(.UnderMatchingLeft, relativeTo: priceLabel!, padding: 8, width: 200, height: 12)
    
//    conditionImageView?.align(.ToTheRightCentered, relativeTo: conditionLabel!, padding: 8, width: 16, height: 16)
    
    notesTitle?.align(.UnderMatchingLeft, relativeTo: conditionLabel!, padding: 8, width: 200, height: 12)
    
    notesTextViewContainer?.anchorAndFillEdge(.Top, xPad: 12, yPad: 72, otherSize: frame.height - 72 - 16)
    notesTextView?.fillSuperview()
  }
  
  private func setupPriceLabel() {
    priceLabel = UILabel()
    priceLabel?.font = UIFont.asapRegular(12)
    priceLabel?.textColor = UIColor.moneyGreen()
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
  
  private func setupConditionLabel() {
    conditionLabel = UILabel()
    conditionLabel?.font = UIFont.asapRegular(12)
    addSubview(conditionLabel!)
  }
  
  private func setupConditionImageView() {
    conditionImageView = UIImageView()
    addSubview(conditionImageView!)
  }
  
  private func setupNotesTitle() {
    notesTitle = UILabel()
    notesTitle?.text = "Notes:"
    notesTitle?.font = UIFont.asapBold(12)
    addSubview(notesTitle!)
  }
  
  private func setupNotesTextViewContainer() {
    notesTextViewContainer = UIView()
    addSubview(notesTextViewContainer!)
  }
  
  private func setupNotesTextView() {
    notesTextView = UITextView()
    notesTextView?.font = UIFont.asapRegular(10)
    notesTextView?.showsVerticalScrollIndicator = false
    notesTextView?.editable = false
    notesTextViewContainer?.addSubview(notesTextView!)
  }
  
  public func setListing(listing: Listing?) {
    guard let listing = listing else { return }
    
    if let price = listing.price {
      let string = "Desired Price: $\(price)"
      let coloredString = NSMutableAttributedString(string: string)
      coloredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 13))
      coloredString.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 13))
      
      priceLabel?.attributedText = coloredString
    }
    
//    if let image = listing.getConditionImage() {
//      let toucan = Toucan(image: image).resize(conditionImageView!.frame.size)
//      conditionImageView?.image = toucan.image
//    }
    
    if let text = listing.getConditionText() {
      let string = "Condition: \(text)"
      let coloredString = NSMutableAttributedString(string: string)
      coloredString.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 10))
      
      conditionLabel?.attributedText = coloredString
    }
    
    if let notes = listing.notes {
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .Justified
      
      let attributedString = NSAttributedString(string: notes, attributes: [
        NSParagraphStyleAttributeName: paragraphStyle,
        NSBaselineOffsetAttributeName: NSNumber(float: 0),
        NSForegroundColorAttributeName: UIColor.sexyGray()
      ])
      
      notesTextView?.attributedText = attributedString
    }
  }
}

















