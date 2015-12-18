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

public class ListViewContainer: UIViewController {
  
  public var listView: ListView?
  public var listing: Listing?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupListView()
    setupSelf()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    listView?.fillSuperview()
  }
  
  private func setupListView() {
    listView = ListView()
    listView?.setListing(listing)
    view.addSubview(listView!)
  }
  
  private func setupSelf() {
    
    view.backgroundColor = .whiteColor()
    
    title = "Best Match"
  }
  
  public func setListing(listing: Listing?) -> Bool {
    guard let listing = listing else { return false }
    
    self.listing = listing
    
    return true
  }
}

public class ListView: UIView, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = ListController()
  private var defaultSeperatorColor: UIColor?
  
  public var tableView: UITableView?
  
  public init() {
    super.init(frame: CGRectZero)
    setupDataBinding()
    setupTableView()
    
    backgroundColor = UIColor.whiteColor()
  }
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    tableView?.fillSuperview()
  }
  
  public func setListing(listing: Listing?) -> Bool {
    guard let listing = listing else { return false }
    
    controller.setListing(listing)
    
    tableView?.reloadData()
    
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
    defaultSeperatorColor = tableView?.separatorColor
    tableView?.separatorColor = .clearColor()
    addSubview(tableView!)
  }
  
  private func setupDataBinding() {
    controller.get_Listing().listen(self) { [weak self] listing in
      self?.tableView?.reloadData()
    }
  }
  
  // MARK: UITableView Delegates 
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 158
    case 1: return 56
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
    let hasMatch = listing?.highestLister != nil || listing?.user != nil
    if (hasMatch) { tableView.separatorColor = defaultSeperatorColor }
    
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        cell.subviews.forEach { if let _ = $0 as? BookView { return } else { $0.removeFromSuperview() } }
        
        cell.bookView?.setBook(listing?.book)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.bookView?.setBook(listing?.book)
        }
      }
      return cell
    case 1:
      
      if  let cell = tableView.dequeueReusableCellWithIdentifier("ListerProfileViewCell", forIndexPath: indexPath) as? ListerProfileViewCell
          where listing?.highestLister != nil || listing?.user != nil
      {
        cell.setListing(listing?.highestLister ?? listing)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.setListing(listing?.highestLister ?? listing)
        }
      }
      
      return cell
    case 2:
      if  let cell = tableView.dequeueReusableCellWithIdentifier("ListerAttributesViewCell", forIndexPath: indexPath) as? ListerAttributesViewCell
          where listing?.highestLister != nil || listing?.user != nil
      {
        
        cell.setListing(listing?.highestLister ?? listing)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.setListing(listing?.highestLister ?? listing)
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
  private var listTypeLabel: UILabel?
  private var listDateTitle: UILabel?
  private var listDateLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUserImage()
    setupNameLabel()
    setupListTypeLabel()
    setupListDateLabel()
    setupListDateTitle()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    userImageView?.anchorToEdge(.Left, padding: 16, width: 36, height: 36)
    
    nameLabel?.align(.ToTheRightMatchingTop, relativeTo: userImageView!, padding: 8, width: 160, height: 16)
    
    listTypeLabel?.align(.ToTheRightMatchingBottom, relativeTo: userImageView!, padding: 8, width: 160, height: 16)

    listDateTitle?.anchorInCorner(.TopRight, xPad: 16, yPad: 12, width: 100, height: 16)
    
    listDateLabel?.anchorInCorner(.BottomRight, xPad: 16, yPad: 12, width: 100, height: 16)
  }
  
  private func setupUserImage() {
    userImageView = UIImageView()
    addSubview(userImageView!)
  }
  
  private func setupNameLabel() {
    nameLabel = UILabel()
    nameLabel?.font = UIFont.asapRegular(12)
    addSubview(nameLabel!)
  }
  
  private func setupListTypeLabel() {
    listTypeLabel = UILabel()
    listTypeLabel?.font = UIFont.asapBold(12)
    addSubview(listTypeLabel!)
  }
  
  private func setupListDateTitle() {
    listDateTitle = UILabel()
    listDateTitle?.font = UIFont.asapBold(12)
    listDateTitle?.textAlignment = .Right
    addSubview(listDateTitle!)
  }
  
  private func setupListDateLabel() {
    
    listDateLabel = UILabel()
    listDateLabel?.font = UIFont.asapRegular(12)
    listDateLabel?.textAlignment = .Right
    addSubview(listDateLabel!)
  }
  
  public func setListing(listing: Listing?) {
    guard let listing = listing, let user = listing.user where user._id != nil else { return }
    
    if let url = user.image, let nsurl = NSURL(string: url) {
      userImageView?.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "Medium_User_Images", diskCapacity: 10 * 1024 * 1024) { [weak self] image in
        if let this = self { return Toucan(image: image).resize(this.userImageView!.frame.size, fitMode: .Crop).maskWithEllipse().image }
        else { return image }
      })
    }
    
    nameLabel?.text = user.username ?? user.getName()
    
    listTypeLabel?.text = listing.getListTypeText() ?? ""
    
    // NOTE: DONT FORGET THESE CODES OMFG
    // converts the date strings sent from the server to local time strings
    if  let dateString = listing.createdAt?.toRegion(.ISO8601, region: Region.LocalRegion())?.toShortString(true, time: false),
        let relativeString = listing.createdAt?.toDateFromISO8601()?.toRelativeString(abbreviated: true, maxUnits: 2)
    {
      let coloredString = NSMutableAttributedString(string: "Listed At \(dateString)")
      coloredString.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 10))
      
      listDateTitle?.attributedText = coloredString
      
      listDateLabel?.text = 60.seconds.ago > listing.createdAt?.toDateFromISO8601() ? "\(relativeString) ago" : "just now"
    }
    
    // not really sure, but the book view covers this view.
    // so I had to set the z position to go over the book view
    // then set the background color to clear
    backgroundColor = .clearColor()
    layer.zPosition = 1
  }
}

public class ListerAttributesViewCell: UITableViewCell {
  
  private var priceLabel: UILabel?
  private var conditionLabel: UILabel?
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
    
    conditionLabel?.align(.UnderMatchingLeft, relativeTo: priceLabel!, padding: 8, width: 200, height: 12)
    
    notesTitle?.align(.UnderMatchingLeft, relativeTo: conditionLabel!, padding: 8, width: 200, height: 12)
    
    notesTextViewContainer?.anchorAndFillEdge(.Top, xPad: 12, yPad: 72, otherSize: frame.height - 72 - 16)
    notesTextView?.fillSuperview()
    
    let gradient = CAGradientLayer(layer: notesTextViewContainer!.layer)
    gradient.frame = notesTextViewContainer!.bounds
    gradient.colors = [UIColor.clearColor().CGColor, UIColor.blueColor().CGColor]
    gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
    gradient.endPoint = CGPoint(x: 0.0, y: 0.85)
    
    notesTextViewContainer?.layer.mask = gradient
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
  
  private func setupNotesTitle() {
    notesTitle = UILabel()
    notesTitle?.font = UIFont.asapBold(12)
    addSubview(notesTitle!)
  }
  
  private func setupNotesTextViewContainer() {
    notesTextViewContainer = UIView()
    addSubview(notesTextViewContainer!)
  }
  
  private func setupNotesTextView() {
    notesTextView = UITextView()
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
    
    if let image = UIImage(named: "Icon-CallButton") where callButton?.frame.height > 0 {
      let toucan = Toucan(image: image).resize(callButton!.frame.size)
      callButton?.setImage(toucan.image, forState: .Normal)
    }
    
    chatButton?.align(.ToTheLeftCentered, relativeTo: callButton!, padding: 24, width: 24, height: 24)
    
    if let image = UIImage(named: "Icon-MessageButton") {
      let toucan = Toucan(image: image).resize(chatButton!.frame.size)
      chatButton?.setImage(toucan.image, forState: .Normal)
    }
    
    if let text = listing.getConditionText() {
      let string = "Condition: \(text)"
      let coloredString = NSMutableAttributedString(string: string)
      coloredString.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 10))
      
      conditionLabel?.attributedText = coloredString
    }
    
    notesTitle?.text = "Notes:"
    
    if let notes = listing.notes {
      
      let paragraphStyle = NSMutableParagraphStyle()
      paragraphStyle.alignment = .Justified
      
      let attributedString = NSAttributedString(string: notes, attributes: [
        NSParagraphStyleAttributeName: paragraphStyle,
        NSBaselineOffsetAttributeName: NSNumber(float: 0),
        NSForegroundColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont.asapRegular(12)
      ])
      
      notesTextView?.attributedText = attributedString
    }
    
    // same things is happening as the view view before this
    layer.zPosition = 2
  }
}

















