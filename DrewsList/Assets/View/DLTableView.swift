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
import Async
import SwiftDate

public class DLTableView: UITableView {
  
  public init() {
    super.init(frame: CGRectZero, style: .Plain)
    setupSelf()
  }
  
  private func setupSelf() {
    
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
  
  public var titleLabel: UILabel?
  public var rightImageView: UIImageView?
  
  public let _didSelectCell = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupRightImageView()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 14, yPad: 8, otherSize: 200)
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
  
  public func setupRightImageView() {
    rightImageView = UIImageView()
    rightImageView?.tintColor = .sexyGray()
    addSubview(rightImageView!)
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


public class ListerProfileViewCell: DLTableViewCell {
  
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
    
    listDateTitle?.anchorInCorner(.TopRight, xPad: 16, yPad: 6, width: 100, height: 16)
    
    listDateLabel?.anchorInCorner(.BottomRight, xPad: 16, yPad: 6, width: 100, height: 16)
  }
  
  private override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .whiteColor()
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
    guard let listing = listing, let user = listing.user else { return }
    
    let duration: NSTimeInterval = 0.5
    
    // MARK: Images
    if user.image != nil {
      
      userImageView?.dl_setImageFromUrl(user.image) { [weak self] image, error, cache, url in
        // NOTE: correct way to handle memory management with toucan
        // init toucan and pass in the arguments directly in the parameter headers
        // do the resizing in the background
        var toucan: Toucan? = Toucan(image: image).resize(self?.userImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
        
        Async.main { [weak self] in
          
          // set the image view's image
          self?.userImageView?.image = toucan?.image
          
          // animate
          UIView.animateWithDuration(duration) { [weak self] in
            self?.userImageView?.alpha = 1.0
          }
          
          // deinit toucan
          toucan = nil
        }
      }
    } else {
      
      var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(userImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
      
      Async.main { [weak self] in
        
        self?.userImageView?.image = toucan?.image
        
        UIView.animateWithDuration(duration) { [weak self] in
          self?.userImageView?.alpha = 1.0
        }
        
        toucan = nil
      }
    }
    
    Async.background { [weak self] in
      
      Async.main { [weak self] in
        self?.nameLabel?.text = user.username ?? user.getName()
        self?.listTypeLabel?.text = listing.getListTypeText() ?? ""
      }
      
      // NOTE: DONT FORGET THESE CODES OMFG
      // converts the date strings sent from the server to local time strings
      if  let dateString = listing.createdAt?.toRegion(.ISO8601, region: Region.LocalRegion())?.toShortString(true, time: false),
        let relativeString = listing.createdAt?.toDateFromISO8601()?.toRelativeString(abbreviated: true, maxUnits: 2)
      {
        let coloredString = NSMutableAttributedString(string: "Listed At \(dateString)")
        coloredString.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 10))
        
        Async.main { [weak self] in
          self?.listDateTitle?.attributedText = coloredString
          self?.listDateLabel?.text = 60.seconds.ago > listing.createdAt?.toDateFromISO8601() ? "\(relativeString) ago" : "just now"
        }
      }
      
    }.main { [weak self] in
      // not really sure, but the book view covers this view.
      // so I had to set the z position to go over the book view
      // then set the background color to clear
      self?.backgroundColor = .clearColor()
      self?.layer.zPosition = 1
    }
  }
}

public class ListerAttributesViewCell: DLTableViewCell {
  
  private var priceLabel: UILabel?
  private var conditionLabel: UILabel?
  private var notesTitle: UILabel?
  private var notesTextViewContainer: UIView?
  private var notesTextView: UITextView?
  
  private var chatButton: UIButton?
  private var callButton: UIButton?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
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
    
    chatButton?.align(.ToTheLeftCentered, relativeTo: callButton!, padding: 24, width: 24, height: 24)
    
    conditionLabel?.align(.UnderMatchingLeft, relativeTo: priceLabel!, padding: 8, width: 200, height: 12)
    
    notesTitle?.align(.UnderMatchingLeft, relativeTo: conditionLabel!, padding: 8, width: 200, height: 12)
  }
  
  private override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .whiteColor()
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
    notesTextViewContainer?.layer.mask = nil
    notesTextViewContainer?.addSubview(notesTextView!)
  }
  
  public func setListing(listing: Listing?) {
    
    Async.background { [weak self, weak listing] in
      
      let string1 = "Desired Price: $\(listing?.price ?? "")"
      let coloredString1 = NSMutableAttributedString(string: string1)
      coloredString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 13))
      coloredString1.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 13))
      
      Async.main { [weak self] in self?.priceLabel?.attributedText = coloredString1 }
      
      // NOTE: correct way to handle memory management with toucan
      // init toucan
      var toucan1: Toucan? = Toucan(image: UIImage(named: "Icon-CallButton")!).resize(self?.callButton?.frame.size)
      
      Async.main { [weak self] in
        self?.callButton?.setImage(toucan1?.image, forState: .Normal)
        // deinit toucan
        toucan1 = nil
      }
      
      var toucan2: Toucan? = Toucan(image: UIImage(named: "Icon-MessageButton")!).resize(self?.chatButton?.frame.size)
      
      Async.main { [weak self] in
        self?.chatButton?.setImage(toucan2?.image, forState: .Normal)
        toucan2 = nil
      }
      
      let string2 = "Condition: \(listing?.getConditionText() ?? "")"
      let coloredString2 = NSMutableAttributedString(string: string2)
      coloredString2.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 10))
      
      Async.main { [weak self] in
        self?.conditionLabel?.attributedText = coloredString2
      }
      
      
      if let notes = listing?.notes {
        Async.main { [weak self] in
          self?.notesTitle?.text = !notes.isEmpty ? "Notes:" : nil
        }
      }
      
      // create paragraph style class
      var paragraphStyle: NSMutableParagraphStyle? = NSMutableParagraphStyle()
      paragraphStyle?.alignment = .Justified
      
      let attributedString: NSAttributedString = NSAttributedString(string: listing?.notes ?? "", attributes: [
        NSParagraphStyleAttributeName: paragraphStyle!,
        NSBaselineOffsetAttributeName: NSNumber(float: 0),
        NSForegroundColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont.asapRegular(12)
        ])
      
      // dealloc paragraph style
      paragraphStyle = nil
      
      Async.main { [weak self] in
        
        self?.notesTextView?.attributedText = attributedString
        
        self?.notesTextView?.sizeToFit()
        
        let height: CGFloat! = self?.notesTextView!.frame.size.height < 100 ? self?.notesTextView!.frame.size.height : 100
        var notesTitle: UILabel! = self?.notesTitle!
        
        self?.notesTextViewContainer?.alignAndFillWidth(
          align: .UnderCentered,
          relativeTo: notesTitle,
          padding: 11,
          height: height
        )
        
        notesTitle = nil
        
        self?.notesTextView?.fillSuperview()
        
        self?.notesTextViewContainer?.layer.mask = nil
        
        Async.background { [weak self] in
          let layer: CALayer! = self?.notesTextViewContainer?.layer
          let bounds: CGRect! = self?.notesTextViewContainer?.bounds
          var gradient: CAGradientLayer? = CAGradientLayer(layer: layer)
          gradient?.frame = bounds
          gradient?.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
          gradient?.startPoint = CGPoint(x: 0.0, y: 1.0)
          gradient?.endPoint = CGPoint(x: 0.0, y: 0.85)
          
          Async.main { [weak self] in
            self?.notesTextViewContainer?.layer.mask = gradient
            gradient = nil
          }
        }
      }
    
    }.main { [weak self] in
      // same things is happening as the view view before this
      self?.layer.zPosition = 2
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
        self?._didSelectListing.fire(list_id)
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
































