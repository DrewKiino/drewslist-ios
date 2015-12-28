//
//  DLTableView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/21/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals
import TextFieldEffects
import KMPlaceholderTextView
import SwiftyButton
import Async
import SwiftDate

public class DLTableView: UITableView {
  
  public init() {
    super.init(frame: CGRectZero, style: .Plain)
    setupSelf()
  }
  
  private func setupSelf() {
    
    // MARK: Book Cells
    registerClass(BookDetailCell.self, forCellReuseIdentifier: "BookDetailCell")
 
    // MARK: Settings Cells
    registerClass(ChangeImageCell.self, forCellReuseIdentifier: "ChangeImageCell")
    
    // MARK: User Profile 
    registerClass(UserProfileListView.self, forCellReuseIdentifier: "UserProfileListView")
    
    // MARK: Regular Static View Cell
    registerClass(PaddingCell.self, forCellReuseIdentifier: "PaddingCell")
    registerClass(TitleCell.self, forCellReuseIdentifier: "TitleCell")
    registerClass(FullTitleCell.self, forCellReuseIdentifier: "FullTitleCell")
    registerClass(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
    
    // MARK: Create Listing View Cells
    registerClass(BookViewCell.self, forCellReuseIdentifier: "BookViewCell")
    registerClass(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
    registerClass(TripleToggleCell.self, forCellReuseIdentifier: "TripleToggleCell")
    
    registerClass(InputTextFieldCell.self, forCellReuseIdentifier: "InputTextFieldCell")
    registerClass(InputTextViewCell.self, forCellReuseIdentifier: "InputTextViewCell")
    registerClass(BigButtonCell.self, forCellReuseIdentifier: "BigButtonCell")
    
    // MARK: List View Cells
    registerClass(ListerProfileViewCell.self, forCellReuseIdentifier: "ListerProfileViewCell")
    registerClass(ListerAttributesViewCell.self, forCellReuseIdentifier: "ListerAttributesViewCell")
    
    // MARK: List Feed Cells
    registerClass(ListFeedCell.self, forCellReuseIdentifier: "ListFeedCell")
    
    allowsSelection = false
    showsVerticalScrollIndicator = false
    backgroundColor = .paradiseGray()
    separatorColor = .clearColor()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "resignFirstResponder"))
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    visibleCells.forEach { $0.resignFirstResponder() }
    return true
  }
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

public class DLTableViewCell: UITableViewCell {
  
  private let separatorLine = CALayer()
  
  private let topBorder = CALayer()
  private let bottomBorder = CALayer()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    topBorder.frame = CGRectMake(0, 0, bounds.size.width, 0.5)
    bottomBorder.frame = CGRectMake(0, bounds.size.height - 1, bounds.size.width, 1)
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 0.5)
  }
  
  private func setupSelf() {
    backgroundColor = .clearColor()
    
    topBorder.backgroundColor = UIColor.tableViewNativeSeparatorColor().CGColor
    topBorder.zPosition = 2
    layer.addSublayer(topBorder)
    
    bottomBorder.backgroundColor = UIColor.tableViewNativeSeparatorColor().CGColor
    bottomBorder.zPosition = 2
    layer.addSublayer(bottomBorder)
    
    separatorLine.backgroundColor = UIColor.tableViewNativeSeparatorColor().CGColor
    separatorLine.zPosition = 2
    layer.addSublayer(separatorLine)
    
    separatorInset = UIEdgeInsetsMake(0, width, 0, 0)
    
    hideSeparatorLine()
    hideBothTopAndBottomBorders()
  }

  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func showSeparatorLine() {
    separatorLine.hidden = false
  }
  
  public func hideSeparatorLine() {
    separatorLine.hidden = true
  }
  
  public func hideBothTopAndBottomBorders() {
    hideTopBorder()
    hideBottomBorder()
  }
  
  public func showBothTopAndBottomBorders() {
    showTopBorder()
    showBottomBorder()
  }
  
  public func showTopBorder() {
    topBorder.hidden = false
  }
  
  public func showBottomBorder() {
    bottomBorder.hidden = false
  }
  
  public func hideTopBorder() {
    topBorder.hidden = true
  }
  
  public func hideBottomBorder() {
    bottomBorder.hidden = true
  }
}

public class PaddingCell: DLTableViewCell {
  
  public var paddingLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupPaddingLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private override func setupSelf() {
    super.setupSelf()
    
    showBothTopAndBottomBorders()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    paddingLabel?.anchorAndFillEdge(.Left, xPad: 14, yPad: 4, otherSize: 300)
  }
  
  private func setupPaddingLabel() {
    paddingLabel = UILabel()
    paddingLabel?.textColor = .sexyGray()
    paddingLabel?.textAlignment = .Center
    paddingLabel?.font = .asapRegular(12)
    paddingLabel?.adjustsFontSizeToFitWidth = true
    paddingLabel?.minimumScaleFactor = 0.1
    addSubview(paddingLabel!)
  }
  
  public func alignTextLeft() {
    paddingLabel?.textAlignment = .Left
  }
}

public class TitleCell: DLTableViewCell {
  
  public var titleLabel: UILabel?
  public var titleTextLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupTitleTextLabel()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 14, yPad: 8, otherSize: 80)
    titleTextLabel?.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: titleLabel!, padding: 8, height: 24)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel?.textColor = .sexyGray()
    titleLabel?.font = .asapRegular(16)
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.minimumScaleFactor = 0.8
    addSubview(titleLabel!)
  }
  
  private func setupTitleTextLabel() {
    titleTextLabel = UILabel()
    titleTextLabel?.textColor = .blackColor()
    titleTextLabel?.font = .asapRegular(16)
    titleTextLabel?.adjustsFontSizeToFitWidth = true
    titleTextLabel?.minimumScaleFactor = 0.8
    addSubview(titleTextLabel!)
  }
}

public class FullTitleCell: DLTableViewCell {
  
  public var titleButton: UIButton?
  public var rightImageView: UIImageView?
  
  public let _didSelectCell = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupRightImageView()
    
    titleButton?.anchorAndFillEdge(.Left, xPad: 14, yPad: 8, otherSize: screen.width - 48)
    rightImageView?.anchorToEdge(.Right, padding: 12, width: 12, height: 16)
    rightImageView?.image = Toucan(image: UIImage(named: "Icon-GreyChevron")?.imageWithRenderingMode(.AlwaysTemplate)).resize(rightImageView?.frame.size, fitMode: .Clip).image
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  private override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .whiteColor()
  }
  
  private func setupTitleLabel() {
    titleButton = UIButton()
    titleButton?.setTitleColor(.blackColor(), forState: .Normal)
    titleButton?.contentHorizontalAlignment = .Left
    titleButton?.titleLabel?.font = .asapRegular(16)
    titleButton?.titleLabel?.adjustsFontSizeToFitWidth = true
    titleButton?.titleLabel?.minimumScaleFactor = 0.5
    titleButton?.addTarget(self, action: "select", forControlEvents: .TouchUpInside)
    addSubview(titleButton!)
  }
  
  public func setupRightImageView() {
    rightImageView = UIImageView()
    rightImageView?.tintColor = .sexyGray()
    addSubview(rightImageView!)
  }
  
  public func select() {
    _didSelectCell => true
  }
  
}

public class SwitchCell: DLTableViewCell {
  
  public enum Toggle {
    case On
    case Off
    public func getValue() -> Bool {
      switch self {
      case .On: return true
      case .Off: return false
      }
    }
  }
  
  public var titleLabel: UILabel?
  public var switchImageView: UIImageView?
  public var switchImageViewReferenceFrame: CGRect?
  public var toggle: Toggle = .Off
  
  public let _didSelectCell = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupSwitchImageView()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 14, yPad: 8, otherSize: 200)
    switchImageView?.anchorToEdge(.Right, padding: 8, width: 24, height: 24)
    switchImageViewReferenceFrame = switchImageView?.frame
    switchImageView?.frame = CGRectMake(
      screen.width + 2,
      switchImageViewReferenceFrame!.origin.y,
      switchImageViewReferenceFrame!.width,
      switchImageViewReferenceFrame!.height
    )
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  private override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .whiteColor()
    multipleTouchEnabled = false
    
    let pressGesture = UILongPressGestureRecognizer(target: self, action: "pressed:")
    pressGesture.minimumPressDuration = 0.01
    addGestureRecognizer(pressGesture)
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel?.textColor = .blackColor()
    titleLabel?.font = .asapRegular(16)
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.minimumScaleFactor = 0.8
    addSubview(titleLabel!)
  }
  
  public func setupSwitchImageView() {
    switchImageView = UIImageView(image: UIImage(named: "check")?.imageWithRenderingMode(.AlwaysTemplate))
    switchImageView?.tintColor = .juicyOrange()
    addSubview(switchImageView!)
  }
  
  public func select() {
    _didSelectCell => toggle.getValue()
  }
  
  public func switchOn() {
    toggle = .On
    animateToggle()
  }
  
  public func switchOff() {
    toggle = .Off
    animateToggle()
  }
  
  public func toggleSwitch() {
    if toggle == .On { toggle = .Off }
    else if toggle == .Off { toggle = .On }
    animateToggle()
  }
  
  public func animateToggle() {
    
    let duration: NSTimeInterval = 0.7
    let damping: CGFloat = 0.5
    let velocity: CGFloat = 1.0

    switch toggle {
    case .On:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        let frame: CGRect! = self?.switchImageViewReferenceFrame
        self?.switchImageView?.frame = frame
      }, completion: { bool in
      })
      break
    case .Off:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        let frame: CGRect! = self?.switchImageView?.frame
        self?.switchImageView?.frame = CGRectMake(screen.width + 2, frame.origin.y, frame.width, frame.height)
      }, completion: { bool in
      })
      break
    }
  }
  
  public func pressed(sender: UILongPressGestureRecognizer) {
    if (sender.state == .Began) {
      backgroundColor = .sweetBeige()
    } else if (sender.state == .Ended){
      backgroundColor = .whiteColor()
      if self.pointInside(sender.locationInView(self), withEvent: nil) { select() }
    }
  }
}

public class UserProfileListView: DLTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
  
  public let label = UILabel()
  public var collectionView: UICollectionView?
  
  public let controller = UserProfileListingController()
  public var model: UserProfileListingModel { get { return controller.model } }
  
  public let _collectionViewFrame = Signal<CGRect>()
  public var collectionViewFrame: CGRect = CGRectZero { didSet { _collectionViewFrame => collectionViewFrame } }
  
  public let _didSelectListing = Signal<String?>()
  public let _didSelectMatch = Signal<String?>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupDataBinding()
    setupCollectionView()
    setupLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setupDataBinding() {
    model._bookList.listen(self) { [weak self] list in
      self?.collectionView?.reloadData()
    }
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    
    _collectionViewFrame.listen(self) { [weak layout] frame in
      layout?.itemSize = CGSizeMake(100, frame.height)
    }
    
    collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    collectionView?.registerClass(ListCell.self, forCellWithReuseIdentifier: "ListCell")
    collectionView?.delegate = self
    collectionView?.dataSource = self
    collectionView?.backgroundColor = UIColor.whiteColor()
    collectionView?.showsHorizontalScrollIndicator = false
    collectionView?.multipleTouchEnabled = true
    addSubview(collectionView!)
  }
  
  private func setupLabel() {
    label.font = UIFont.systemFontOfSize(16)
    label.textColor = UIColor.sexyGray()
    addSubview(label)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.Top, xPad: 8, yPad: 0, otherSize: 25)
    collectionView?.alignAndFill(align: .UnderCentered, relativeTo: label, padding: 0)
    collectionViewFrame = collectionView!.frame
  }
  
  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    return UIEdgeInsetsMake(0, 8, 0, 8)
  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.bookList.count
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as? ListCell {
      
      cell.setListing(model.bookList[indexPath.row])
      
      // databind the cells
      cell._didSelectListing.removeListener(self)
      cell._didSelectListing.listen(self) { [weak self] list_id in
        self?._didSelectListing.fire(list_id)
      }
      
      // databind the cells
      cell._didSelectMatch.removeListener(self)
      cell._didSelectMatch.listen(self) { [weak self] list_id in
        self?._didSelectMatch.fire(list_id)
      }
      
      return cell
    }
    
    return UICollectionViewCell()
  }
}

public class ListCell: UICollectionViewCell {
  
  public var listing: Listing?
  
  public var bookImageView: UIImageView?
  public var bookPriceLabel: UILabel?
  
  public var matchInfoView: UIView?
  public var matchUserImageView: UIImageView?
  public var matchPriceLabel: UILabel?
  public var matchUserNameLabel: UILabel?
  
  public let _didSelectListing = Signal<String?>()
  public let _didSelectMatch = Signal<String?>()
  
  private var matchTapGesture: UITapGestureRecognizer?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupBookImageView()
    setupBookPriceLabel()
    setupMatchInfoView()
    setupMatchUserImageView()
    setupMatchPriceLabel()
    setupMatchUserNameLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    bookImageView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 150)
    bookPriceLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: bookImageView!, padding: 4, height: 12)
    matchInfoView?.alignAndFillWidth(align: .UnderCentered, relativeTo: bookPriceLabel!, padding: 2, height: 24)
    matchUserImageView?.anchorInCorner(.TopLeft, xPad: 0, yPad: 0, width: 24, height: 24)
    matchPriceLabel?.alignAndFillWidth(align: .ToTheRightMatchingBottom, relativeTo: matchUserImageView!, padding: 2, height: 12)
    matchUserNameLabel?.alignAndFillWidth(align: .ToTheRightMatchingTop, relativeTo: matchUserImageView!, padding: 2, height: 12)
    
    bookImageView?.layer.shadowPath = UIBezierPath(roundedRect: bookImageView!.bounds, cornerRadius: 0).CGPath
  }
  
  private func setupBookImageView() {
    bookImageView = UIImageView()
    bookImageView?.userInteractionEnabled = true
    bookImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectedListing"))
    
    bookImageView?.layer.shadowColor = UIColor.clearColor().CGColor
    bookImageView?.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    bookImageView?.layer.shadowOpacity = 1.0
    bookImageView?.layer.shadowRadius = 2
    bookImageView?.layer.masksToBounds = true
    bookImageView?.clipsToBounds = false
    
    addSubview(bookImageView!)
  }
  
  private func setupBookPriceLabel() {
    bookPriceLabel = UILabel()
    bookPriceLabel?.textColor = UIColor.moneyGreen()
    bookPriceLabel?.font = UIFont.asapBold(12)
    bookPriceLabel?.adjustsFontSizeToFitWidth = true
    bookPriceLabel?.minimumScaleFactor = 0.1
    addSubview(bookPriceLabel!)
  }
  
  private func setupMatchInfoView() {
    matchInfoView = UIView()
    matchInfoView?.userInteractionEnabled = true
    matchInfoView?.layer.cornerRadius = 12
    matchInfoView?.layer.masksToBounds = true
    addSubview(matchInfoView!)
  }
  
  private func setupMatchUserImageView() {
    matchUserImageView = UIImageView()
    matchInfoView?.addSubview(matchUserImageView!)
  }
  
  private func setupMatchPriceLabel() {
    matchPriceLabel = UILabel()
    matchPriceLabel?.textColor = UIColor.moneyGreen()
    matchPriceLabel?.font = UIFont.asapBold(12)
    matchPriceLabel?.adjustsFontSizeToFitWidth = true
    matchPriceLabel?.minimumScaleFactor = 0.1
    matchInfoView?.addSubview(matchPriceLabel!)
  }
  
  private func setupMatchUserNameLabel() {
    matchUserNameLabel = UILabel()
    matchUserNameLabel?.textColor = UIColor.blackColor()
    matchUserNameLabel?.font = UIFont.asapRegular(12)
    matchUserNameLabel?.adjustsFontSizeToFitWidth = true
    matchUserNameLabel?.minimumScaleFactor = 0.1
    matchInfoView?.addSubview(matchUserNameLabel!)
  }
  
  public func selectedMatch() {
    _didSelectMatch => listing?.highestLister?._id
  }
  
  public func selectedListing() {
    _didSelectListing => listing?._id
  }
  
  public func setListing(listing: Listing?) {
    
    self.listing = listing
    
    setBook(listing?.book)
    _setListing(listing)
  }
  
  private func _setListing(listing: Listing?) {
    
    setBook(listing?.book)
    setHighestLister(listing?.highestLister)
    
    // set user price label
    bookPriceLabel?.text = nil
    if let price = listing?.price { bookPriceLabel?.text = "$\(price)" }
    
    // set highest listing info
    matchUserImageView?.image = nil
    matchUserImageView?.alpha = 0.0
    
    // set lister price label
    bookPriceLabel?.text = nil
    
    Async.background { [weak listing] in
      
      var coloredString: NSMutableAttributedString? = NSMutableAttributedString(string: "Price: $\(listing?.price ?? "")")
      coloredString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 6))
      coloredString?.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(12), range: NSRange(location: 0,length: 6))
      
      Async.main { [weak self] in
        
        self?.bookPriceLabel?.attributedText = coloredString
        
        coloredString = nil
      }
    }
  }
  
  public func setHighestLister(listing: Listing?) {
    
    // refresh match info view
    matchInfoView?.backgroundColor = .clearColor()
    
    // refresh lister labels
    matchPriceLabel?.text = nil
    matchUserNameLabel?.text = nil
    
    if matchTapGesture != nil {
      matchInfoView?.removeGestureRecognizer(matchTapGesture!)
      matchTapGesture = nil
    }
    
    // Highest Lister UI Setup
    if let highestLister = listing {
      
      // if highest lister exists, add tap gesture
      matchTapGesture = UITapGestureRecognizer(target: self, action: "selectedMatch")
      matchInfoView?.addGestureRecognizer(matchTapGesture!)
      
      matchInfoView?.backgroundColor = .sweetBeige()
      
      let duration: NSTimeInterval = 0.2
      
      if let image = highestLister.user?.image {
        
        matchUserImageView?.dl_setImageFromUrl(image) { [weak self] image, error, cache, url in
          Async.background { [weak self] in
            // NOTE: correct way to handle memory management with toucan
            // init toucan and pass in the arguments directly in the parameter headers
            // do the resizing in the background
            var toucan: Toucan? = Toucan(image: image).resize(self?.matchUserImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
            
            Async.main { [weak self] in
              
              // set the image view's image
              self?.matchUserImageView?.image = toucan?.image
              
              UIView.animateWithDuration(duration) { [weak self] in
                self?.matchUserImageView?.alpha = 1.0
              }
              
              // deinit toucan
              toucan = nil
            }
          }
        }
      } else {
        
        // image processing done in background
        Async.background { [weak self] in
          
          var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(self?.matchUserImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
          
          Async.main { [weak self] in
            
            self?.matchUserImageView?.image = toucan?.image
            
            UIView.animateWithDuration(duration) { [weak self] in
              self?.matchUserImageView?.alpha = 1.0
            }
            
            toucan = nil
          }
        }
      }
      
      Async.background { [weak highestLister] in
        
        //      let priceMatch: String? = listing?.price != nil ?
        var coloredString: NSMutableAttributedString? = NSMutableAttributedString(string: "Best \(highestLister?.getListTypeText2() ?? "Match"): $\(highestLister?.price ?? "")")
        coloredString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 11))
        coloredString?.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(12), range: NSRange(location: 0,length: 11))
        
        Async.main { [weak self] in
          
          self?.matchPriceLabel?.attributedText = coloredString
          
          coloredString = nil
        }
      }
      
      Async.background { [weak highestLister] in
        
        //      let priceMatch: String? = listing?.price != nil ?
        var coloredString: NSMutableAttributedString? = NSMutableAttributedString(string: "Best \(highestLister?.getListTypeText2() ?? "Match"): $\(highestLister?.price ?? "")")
        coloredString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 11))
        coloredString?.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(12), range: NSRange(location: 0,length: 11))
        
        Async.main { [weak self] in
          
          self?.matchUserNameLabel?.text = highestLister?.user?.getName()
          
          coloredString = nil
        }
      }
    }
  }
  
  public func setBook(book: Book?) {
    
    bookImageView?.image = nil
    bookImageView?.alpha = 0.0
    bookImageView?.layer.shadowColor = UIColor.clearColor().CGColor
    
    let duration: NSTimeInterval = 0.2
    
    // MARK: Images
    if book?.hasImageUrl() == true {
      bookImageView?.dl_setImageFromUrl(book?.largeImage ?? book?.mediumImage ?? book?.smallImage ?? nil) { [weak self] image, error, cache, url in
        Async.background { [weak self] in
          // NOTE: correct way to handle memory management with toucan
          // init toucan and pass in the arguments directly in the parameter headers
          // do the resizing in the background
          var toucan: Toucan? = Toucan(image: image).resize(self?.bookImageView?.frame.size)
          
          Async.main { [weak self] in
            
            // set the image view's image
            self?.bookImageView?.image = toucan?.image
            
            if self?.bookImageView?.image != nil { self?.bookImageView?.layer.shadowColor = UIColor.darkGrayColor().CGColor }
            
            UIView.animateWithDuration(duration) { [weak self] in
              self?.bookImageView?.alpha = 1.0
            }
            
            // deinit toucan
            toucan = nil
          }
        }
      }
    } else {
      
      Async.background { [weak self] in
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "book-placeholder")).resize(self?.bookImageView?.frame.size)
        
        Async.main { [weak self] in
          
          self?.bookImageView?.image = toucan?.image
          
          if self?.bookImageView?.image != nil { self?.bookImageView?.layer.shadowColor = UIColor.darkGrayColor().CGColor }
          
          UIView.animateWithDuration(duration) { [weak self] in
            self?.bookImageView?.alpha = 1.0
          }
          
          toucan = nil
        }
      }
    }
  }
}

public class BookViewCell: DLTableViewCell {
  
  public var bookView: BookView?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupBookView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    bookView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 150)
  }
  
  private func setupBookView() {
    bookView = BookView()
    addSubview(bookView!)
  }
  
  public func setBook(book: Book?) {
    bookView?.setBook(book)
  }
}

public class ListFeedCell: DLTableViewCell {
  
  public var listView: ListView?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupListView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    listView?.fillSuperview()
  }
  
  private func setupListView() {
    listView = ListView()
    listView?.tableView?.scrollEnabled = false
    addSubview(listView!)
  }
}

public class BookDetailCell: DLTableViewCell {
  
  public var authorsLabel: UILabel?
//  public var 
  public var view: UIView?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    view?.fillSuperview()
  }
  
  private func setupView() {
    
    view = UIView()
    
    addSubview(view!)
  }
}


public class ChangeImageCell: DLTableViewCell {
  
  public var label: UILabel?
  //public var profileImg: UIImage?
  public var profileImgT: Toucan?
  public var profileImgView: UIImageView?
  
  public let _didSelectCell = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutSubviews()
    setupLabel()
    setupProfileImgView()
    label?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
    //profileImgView?.anchorToEdge(.Right, padding: 0, width: 10, height: 10)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    hideBothTopAndBottomBorders()
  }
  
  private override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    let pressGesture = UILongPressGestureRecognizer(target: self, action: "pressed:")
    pressGesture.minimumPressDuration = 0.01
    addGestureRecognizer(pressGesture)
  }
  
  public func setupUser(user: User?){
    guard let user = user else { return }
    
    let duration: NSTimeInterval = 0.2
    
    // MARK: Images
    if user.image != nil {
      
      profileImgView?.dl_setImageFromUrl(user.image) { [weak self] image, error, cache, url in
        Async.background { [weak self] in
          // NOTE: correct way to handle memory management with toucan
          // init toucan and pass in the arguments directly in the parameter headers
          // do the resizing in the background
          var toucan: Toucan? = Toucan(image: image).resize(self?.profileImgView?.frame.size, fitMode: .Crop).maskWithEllipse()
          
          Async.main { [weak self] in
            
            self?.profileImgView?.alpha = 0.0
            
            // set the image view's image
            self?.profileImgView?.image = toucan?.image
            
            UIView.animateWithDuration(duration) { [weak self] in
              self?.profileImgView?.alpha = 1.0
            }
            
            // deinit toucan
            toucan = nil
          }
        }
      }
    } else {
      
      Async.background { [weak self] in
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(self?.profileImgView?.frame.size, fitMode: .Crop).maskWithEllipse()
        
        Async.main { [weak self] in
          
          self?.profileImgView?.alpha = 0.0
          
          self?.profileImgView?.image = toucan?.image
          
          UIView.animateWithDuration(duration) { [weak self] in
            self?.profileImgView?.alpha = 1.0
          }
          
          toucan = nil
        }
      }
    }
  }
  
  private func setupLabel() {
    label = UILabel()
    label?.textColor = .blackColor()
    label?.font = .asapRegular(16)
    addSubview(label!)
  }
  
  private func setupProfileImgView(){
    profileImgView = UIImageView()
    let arrowImgT = Toucan(image: UIImage(named: "Icon-OrangeChevron")).resize(CGSize(width: frame.width/20, height: frame.width/20))
    let arrowImgView = UIImageView()
    arrowImgView.image = arrowImgT.image
    let profileImg = UIImage(named: "profile-placeholder")
    profileImgT = Toucan(image: profileImg).resize(CGSize(width: frame.width/10, height: frame.width/10)).maskWithEllipse()
    profileImgView?.image = profileImgT?.image
    //profileImgView?.backgroundColor = UIColor.redColor()
    addSubview(arrowImgView)
    addSubview(profileImgView!)
    profileImgView?.anchorToEdge(.Right, padding: 0, width: frame.width/10, height: frame.width/10)
    arrowImgView.align(.ToTheRightCentered, relativeTo: profileImgView!, padding: frame.width/20, width: frame.width/20, height: frame.width/20)
  
  }
  
  public func select() { _didSelectCell => true }
  
  public func pressed(sender: UILongPressGestureRecognizer) {
    if (sender.state == .Began) {
      backgroundColor = .sweetBeige()
    } else if (sender.state == .Ended){
      backgroundColor = .whiteColor()
      if self.pointInside(sender.locationInView(self), withEvent: nil) { select() }
    }
  }
  
//  public func setupUserImage(user : User?){
//  
//    profileImgView?.alpha = 0.0
//    
//    Async.background { [weak self, weak user] in
//      guard let user = user else { return }
//      
//      let duration: NSTimeInterval = 0.5
//      
//      // MARK: Images
//      if user.image != nil {
//        
//        self?.profileImgView?.dl_setImageFromUrl(user.image) { [weak self] image, error, cache, url in
//          // NOTE: correct way to handle memory management with toucan
//          // init toucan and pass in the arguments directly in the parameter headers
//          // do the resizing in the background
//          var toucan: Toucan? = Toucan(image: image).resize(self?.profileImgView?.frame.size).maskWithEllipse()
//          
//          Async.main { [weak self] in
//            
//            // set the image view's image
//            self?.profileImgView?.image = toucan?.image
//            
//            // stop the loading animation
//            //self?.view.hideLoadingScreen()
//            
//            // animate
//            UIView.animateWithDuration(duration) { [weak self] in
//              self?.profileImgView?.alpha = 1.0
//            }
//            
//            // deinit toucan
//            toucan = nil
//          }
//        }
//      } else {
//        
//        var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(self?.profileImgView?.frame.size, fitMode: .Crop).maskWithEllipse()
//        
//        Async.main { [weak self] in
//          
//          self?.profileImgView?.image = toucan?.image
//          
//          // stop the loading animation
//          //self?.view.hideLoadingScreen()
//          
//          UIView.animateWithDuration(duration) { [weak self] in
//            self?.profileImgView?.alpha = 1.0
//          }
//          
//          toucan = nil
//        }
//      }
//  
//  }
//}
}


public class InputTextFieldCell: DLTableViewCell, UITextFieldDelegate {
  
  public var inputTextField: HoshiTextField?
  
  public let _inputTextFieldString = Signal<String?>()
  
  public let _isFirstResponder = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupInputTextField()
    
    inputTextField?.fillSuperview(left: 14, right: 14, top: 2, bottom: 2)
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    hideBothTopAndBottomBorders()
  }
  
  private override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
  }
  
  private func setupInputTextField() {
    inputTextField = HoshiTextField()
    inputTextField?.textColor = .blackColor()
    inputTextField?.font = .asapRegular(16)
    inputTextField?.borderInactiveColor = UIColor.tableViewNativeSeparatorColor()
    inputTextField?.borderActiveColor = UIColor.sweetBeige()
    inputTextField?.placeholderColor = UIColor.sexyGray()
    inputTextField?.delegate = self
    addSubview(inputTextField!)
  }
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    _isFirstResponder => true
  }
  
  public func textFieldDidEndEditing(textField: UITextField) {
    _isFirstResponder => false
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    inputTextField?.resignFirstResponder()
    
    return true
  }
  
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        _inputTextFieldString.fire(NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1)))
        // else, user has inputted some new strings
      } else { _inputTextFieldString.fire(text + string) }
    }
    return true
  }
}

public class InputTextViewCell: DLTableViewCell, UITextViewDelegate {
  
  
  public var titleLabel: UILabel?
  public var inputTextView: KMPlaceholderTextView?
  
  public let _inputTextViewString = Signal<String?>()
  
  public let _isFirstResponder = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupInputTextView()
    
    titleLabel?.anchorAndFillEdge(.Top, xPad: 14, yPad: 2, otherSize: 12)
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    inputTextView?.anchorAndFillEdge(.Top, xPad: 14, yPad: 16, otherSize: bounds.height - 16)
  }
  
  private override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    hideBothTopAndBottomBorders()
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel?.font = .asapRegular(10)
    titleLabel?.textColor = .sexyGray()
    addSubview(titleLabel!)
  }
  
  private func setupInputTextView() {
    inputTextView  = KMPlaceholderTextView()
    inputTextView?.font = .asapRegular(12)
    inputTextView?.placeholderColor = .sexyGray()
    inputTextView?.delegate = self
    addSubview(inputTextView!)
  }
  
  public func textViewDidBeginEditing(textView: UITextView) {
    _isFirstResponder => true
  }
  
  public func textViewDidEndEditing(textView: UITextView) {
    _isFirstResponder => false
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    inputTextView?.resignFirstResponder()
    
    return true
  }
  
  public func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
    if let string = textView.text {
      // this means the user inputted a backspace
      if text.characters.count == 0 && string.characters.count > 0 {
        _inputTextViewString.fire(NSString(string: string).substringWithRange(NSRange(location: 0, length: string.characters.count - 1)))
        // else, user has inputted some new strings
      } else { _inputTextViewString.fire(string + text) }
    }
    return true
  }
}

public class BigButtonCell: DLTableViewCell {
  
  private var indicator: UIActivityIndicatorView?
  public var button: SwiftyCustomContentButton?
  public var buttonLabel: UILabel?
  
  public let _onPressed = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupButton()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    button?.fillSuperview(left: 14, right: 14, top: 2, bottom: 2)
    indicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
    buttonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
  }
  
  private override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
  }
  
  private func setupButton() {
    
    button = SwiftyCustomContentButton()
    button?.buttonColor         = .sweetBeige()
    button?.highlightedColor    = .juicyOrange()
    button?.shadowColor         = .clearColor()
    button?.disabledButtonColor = .grayColor()
    button?.disabledShadowColor = .darkGrayColor()
    button?.shadowHeight        = 0
    button?.cornerRadius        = 8
    button?.buttonPressDepth    = 0.5 // In percentage of shadowHeight
    button?.addTarget(self, action: "pressed", forControlEvents: .TouchUpInside)
    
    indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    button?.customContentView.addSubview(indicator!)
    
    buttonLabel = UILabel()
    buttonLabel?.textAlignment = .Center
    buttonLabel?.textColor = UIColor.whiteColor()
    buttonLabel?.font = .asapRegular(16)
    button?.customContentView.addSubview(buttonLabel!)
    
    addSubview(button!)
  }
  
  public func pressed() {
    _onPressed => true
  }
}



public class ToggleCell: DLTableViewCell {
  
  public enum Toggle {
    case Left
    case Right
    public func getValue() -> Bool {
      switch self {
      case .Left: return true
      case .Right: return false
      }
    }
  }
  
  public var leftToggleButton: UIButton?
  public var rightToggleButton: UIButton?
  public var toggleSelector: UIView?
  public var toggleContainer: UIView?
  public var toggle: Toggle = .Left// setting default
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupToggleViews()
    
    toggleContainer?.fillSuperview()
    toggleContainer?.groupAndFill(group: .Horizontal, views: [leftToggleButton!, rightToggleButton!], padding: 8)
    
    toggleSelector?.frame = leftToggleButton!.frame
    //    leftToggleButton?.setTitleColor(.whiteColor(), forState: .Normal)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    hideBothTopAndBottomBorders()
  }
  
  private func setupToggleViews() {
    toggleContainer = UIView()
    toggleContainer?.backgroundColor = .whiteColor()
    toggleContainer?.multipleTouchEnabled = true
    addSubview(toggleContainer!)
    
    toggleSelector = UIView()
    toggleSelector?.backgroundColor = .sweetBeige()
    toggleSelector?.layer.cornerRadius = 8.0
    toggleContainer?.addSubview(toggleSelector!)
    
    let press = UILongPressGestureRecognizer(target: self, action: "dragSelector:")
    press.minimumPressDuration = 0.01
    
    toggleContainer?.addGestureRecognizer(press)
    
    leftToggleButton = UIButton()
    leftToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    leftToggleButton?.backgroundColor = .clearColor()
    leftToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(leftToggleButton!)
    
    rightToggleButton = UIButton()
    rightToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    rightToggleButton?.backgroundColor = .clearColor()
    rightToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(rightToggleButton!)
  }
  
  public func dragSelector(sender: UILongPressGestureRecognizer) {
    if (sender.state == .Began) {
    } else if (sender.state == .Ended){
      snapToToggle(sender.locationInView(self))
      //      animateToggleIntersections()
    } else  if pointInside(sender.locationInView(self), withEvent: nil),
      let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let rightToggleButton = rightToggleButton
    {
      let leftLimit = leftToggleButton.center.x
      let rightLimit = rightToggleButton.center.x
      let newCenter = selector.center.x - (selector.center.x - sender.locationInView(self).x)
      
      if newCenter > leftLimit && newCenter < rightLimit {
        UIView.animate({ [unowned selector] in selector.center.x = newCenter })
      }
    }
  }
  
  private func animateToggleIntersections() {
    if  let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let rightToggleButton = rightToggleButton
    {
      if CGRectIntersectsRect(leftToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.setTitleColor(.whiteColor(), forState: .Normal)
          self?.rightToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
          })
      } else if CGRectIntersectsRect(rightToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
          self?.rightToggleButton?.setTitleColor(.whiteColor(), forState: .Normal)
          })
      }
    }
  }
  
  private func snapToToggle(senderLocation: CGPoint) {
    if  let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let rightToggleButton = rightToggleButton
    {
      if CGRectContainsPoint(leftToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in
          selector.center.x = leftToggleButton.center.x
          })
        toggle = .Left
      } else if CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in
          selector.center.x = rightToggleButton.center.x
          })
        toggle = .Right
      } else {
        UIView.animate({ [unowned selector] in
          selector.center.x = leftToggleButton.center.x
          })
        toggle = .Left
      }
      
    }
    
    _didSelectCell => toggle
  }
}

public class TripleToggleCell: DLTableViewCell {
  
  public enum Toggle {
    case Left
    case Middle
    case Right
  }
  
  public var leftToggleButton: UIButton?
  public var middleToggleButton: UIButton?
  public var rightToggleButton: UIButton?
  public var toggleSelector: UIView?
  public var toggleContainer: UIView?
  public var toggle: Toggle = .Middle// setting default
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupToggleViews()
    
    toggleContainer?.fillSuperview()
    toggleContainer?.groupAndFill(group: .Horizontal, views: [leftToggleButton!, middleToggleButton!, rightToggleButton!], padding: 8)
    
    toggleSelector?.frame = middleToggleButton!.frame
    
    leftToggleButton?.imageView?.tintColor = .juicyOrange()
    middleToggleButton?.imageView?.tintColor = .blackColor()
    rightToggleButton?.imageView?.tintColor = .juicyOrange()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    leftToggleButton?.setImage(leftToggleButton?.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
    middleToggleButton?.setImage(middleToggleButton?.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
    rightToggleButton?.setImage(rightToggleButton?.imageView?.image?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
  }
  
  private override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    hideBothTopAndBottomBorders()
  }
  
  private func setupToggleViews() {
    toggleContainer = UIView()
    toggleContainer?.backgroundColor = .whiteColor()
    toggleContainer?.multipleTouchEnabled = true
    addSubview(toggleContainer!)
    
    toggleSelector = UIView()
    toggleSelector?.backgroundColor = .sweetBeige()
    toggleSelector?.layer.cornerRadius = 8.0
    toggleContainer?.addSubview(toggleSelector!)
    
    let press = UILongPressGestureRecognizer(target: self, action: "dragSelector:")
    press.minimumPressDuration = 0.01
    
    toggleContainer?.addGestureRecognizer(press)
    
    leftToggleButton = UIButton()
    leftToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    leftToggleButton?.backgroundColor = .clearColor()
    leftToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(leftToggleButton!)
    
    middleToggleButton = UIButton()
    middleToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    middleToggleButton?.backgroundColor = .clearColor()
    middleToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(middleToggleButton!)
    
    rightToggleButton = UIButton()
    rightToggleButton?.setTitleColor(.blackColor(), forState: .Normal)
    rightToggleButton?.backgroundColor = .clearColor()
    rightToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(rightToggleButton!)
  }
  
  public func dragSelector(sender: UILongPressGestureRecognizer) {
    if (sender.state == .Began) {
    } else if (sender.state == .Ended){
      snapToToggle(sender.locationInView(self))
      animateToggleIntersections(sender.locationInView(self))
    } else  if pointInside(sender.locationInView(self), withEvent: nil),
      let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let rightToggleButton = rightToggleButton
    {
      let leftLimit = leftToggleButton.center.x
      let rightLimit = rightToggleButton.center.x
      let newCenter = selector.center.x - (selector.center.x - sender.locationInView(self).x)
      
      if newCenter > leftLimit && newCenter < rightLimit {
        UIView.animate({ [unowned selector] in selector.center.x = newCenter })
      }
    }
  }
  
  private func animateToggleIntersections(senderLocation: CGPoint) {
    if  let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let middleToggleButton = middleToggleButton,
      let rightToggleButton = rightToggleButton
    {
      if CGRectIntersectsRect(leftToggleButton.frame, selector.frame) || CGRectContainsPoint(leftToggleButton.frame, senderLocation) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .blackColor()
          self?.middleToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.rightToggleButton?.imageView?.tintColor = .juicyOrange()
          })
      } else if CGRectIntersectsRect(rightToggleButton.frame, selector.frame) || CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.middleToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.rightToggleButton?.imageView?.tintColor = .blackColor()
          })
      } else if CGRectIntersectsRect(middleToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.middleToggleButton?.imageView?.tintColor = .blackColor()
          self?.rightToggleButton?.imageView?.tintColor = .juicyOrange()
          })
      }
    }
  }
  
  private func snapToToggle(senderLocation: CGPoint) {
    if  let selector = toggleSelector,
      let leftToggleButton = leftToggleButton,
      let middleToggleButton = middleToggleButton,
      let rightToggleButton = rightToggleButton
    {
      if CGRectContainsPoint(leftToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = leftToggleButton.center.x })
        toggle = .Left
      } else if CGRectContainsPoint(middleToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = middleToggleButton.center.x })
        toggle = .Middle
      } else if CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [unowned selector] in selector.center.x = rightToggleButton.center.x })
        toggle = .Right
      } else {
        UIView.animate({ [unowned selector] in selector.center.x = middleToggleButton.center.x })
        toggle = .Middle
      }
    }
    
    _didSelectCell => toggle
  }
}

























