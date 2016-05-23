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
    registerClass(LabelCell.self, forCellReuseIdentifier: "LabelCell")
 
    // MARK: Settings Cells
    registerClass(ChangeImageCell.self, forCellReuseIdentifier: "ChangeImageCell")
    registerClass(PickerCell.self, forCellReuseIdentifier: "PickerCell")

    // MARK: User Profile
    registerClass(UserProfileListView.self, forCellReuseIdentifier: "UserProfileListView")
    registerClass(BigImageCell.self, forCellReuseIdentifier: "BigImageCell")
    
    // MARK: Regular Static View Cell
    registerClass(PaddingCell.self, forCellReuseIdentifier: "PaddingCell")
    registerClass(TitleCell.self, forCellReuseIdentifier: "TitleCell")
    registerClass(FullTitleCell.self, forCellReuseIdentifier: "FullTitleCell")
    registerClass(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
    registerClass(ImageCell.self, forCellReuseIdentifier: "ImageCell")
    
    // MARK: Create Listing View Cells
    registerClass(BookViewCell.self, forCellReuseIdentifier: "BookViewCell")
    registerClass(ToggleCell.self, forCellReuseIdentifier: "ToggleCell")
    registerClass(TripleToggleCell.self, forCellReuseIdentifier: "TripleToggleCell")
    registerClass(SliderCell.self, forCellReuseIdentifier: "SliderCell")
    
    registerClass(InputTextFieldCell.self, forCellReuseIdentifier: "InputTextFieldCell")
    registerClass(InputTextViewCell.self, forCellReuseIdentifier: "InputTextViewCell")
    registerClass(BigButtonCell.self, forCellReuseIdentifier: "BigButtonCell")
    
    // MARK: List View Cells
    registerClass(ListerProfileViewCell.self, forCellReuseIdentifier: "ListerProfileViewCell")
    registerClass(ListerAttributesViewCell.self, forCellReuseIdentifier: "ListerAttributesViewCell")
    
    // MARK: List Feed Cells
    registerClass(ListFeedCell.self, forCellReuseIdentifier: "ListFeedCell")
    
    // MARK: Search Users
    registerClass(UserCell.self, forCellReuseIdentifier: "UserCell")
    
    // MARK: Edit Listing
    //registerClass(EditListingCell.self, forCellReuseIdentifier: "EditListingCell")
    
    // MARK: Chat History
    registerClass(ChatHistoryCell.self, forCellReuseIdentifier: "ChatHistoryCell")
    
    // MARK: Activity Feed
    registerClass(ActivityCell.self, forCellReuseIdentifier: "ActivityCell")
    
    // MARK: Book Profile
    registerClass(RatingsCell.self, forCellReuseIdentifier: "RatingsCell")
   
    // MARK: Payments
    registerClass(CardInfoCell.self, forCellReuseIdentifier: "CardInfoCell")
    registerClass(PaymentInputCell.self, forCellReuseIdentifier: "PaymentInputCell")
    
    // MARK: Listings
    registerClass(SelectableTitleCell.self, forCellReuseIdentifier: "SelectableTitleCell")
    
    allowsSelection = false
    showsVerticalScrollIndicator = false
    backgroundColor = .whiteColor()
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
    
    separatorLine.frame = CGRectMake(14, bounds.size.height, bounds.size.width - 1, 0.5)
  }
  
  public func setupSelf() {
    backgroundColor = .whiteColor()
    
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
  
  public override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .paradiseGray()
    
    showBothTopAndBottomBorders()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    paddingLabel?.anchorAndFillEdge(.Left, xPad: 14, yPad: 4, otherSize: 300)
  }
  
  private func setupPaddingLabel() {
    paddingLabel = UILabel()
    paddingLabel?.textColor = .coolBlack()
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

public class LabelCell: DLTableViewCell {
  
  public var label: UILabel?
  public var title: String?
  public var subTitle: String?
  public var fullTitle: String?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func setupSelf() {
    super.setupSelf()
    hideBothTopAndBottomBorders()
    super.backgroundColor = .whiteColor()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    label?.fillSuperview(left: 8, right: 8, top: 0, bottom: 0)
  }
  
  private func setupLabel() {
    label = UILabel()
    label?.textColor = .sexyGray()
    label?.textAlignment = .Left
    label?.font = .asapRegular(12)
    label?.adjustsFontSizeToFitWidth = true
    label?.minimumScaleFactor = 0.8
    label?.numberOfLines = 2
    addSubview(label!)
    
    label?.backgroundColor = .whiteColor()
  }
  
  public func setLabelTitle(title: String){
    self.title = title
  }
  
  public func setLabelSubTitle(subTitle: String){
    self.subTitle = subTitle
  }
  
  public func setLabelFullTitle(){
    if let title = title, subTitle = subTitle {
      fullTitle = title + subTitle
      var mutstring = NSMutableAttributedString()
      mutstring = NSMutableAttributedString(string: fullTitle!, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
      mutstring.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: title.characters.count, length: subTitle.characters.count))
      label?.attributedText = mutstring
    } else {
      label?.attributedText = nil
    }
  }
  
  public func alignTextLeft() {
    label?.textAlignment = .Left
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
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 8, yPad: 0, otherSize: 80)
    titleTextLabel?.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: titleLabel!, padding: 8, height: 24)
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
}

public class FullTitleCell: DLTableViewCell {
  
  public var titleButton: UIButton?
  public var rightImageView: UIImageView?
  
  public var onClick: (() -> Void)?
  
  public let _didSelectCell = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupRightImageView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    titleButton?.anchorAndFillEdge(.Left, xPad: 8, yPad: 0, otherSize: screen.width - 48)
    rightImageView?.anchorToEdge(.Right, padding: 8, width: 16, height:  16)
    rightImageView?.dl_setImage(UIImage(named: "Icon-GreyChevron")?.imageWithRenderingMode(.AlwaysTemplate))
  }
  
  public override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .whiteColor()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellTapped"))
  }
  
  private func setupTitleLabel() {
    titleButton = UIButton()
    titleButton?.setTitleColor(.sexyGray(), forState: .Normal)
    titleButton?.contentHorizontalAlignment = .Left
    titleButton?.titleLabel?.font = .asapRegular(12)
    titleButton?.titleLabel?.adjustsFontSizeToFitWidth = true
    titleButton?.titleLabel?.minimumScaleFactor = 0.8
    titleButton?.addTarget(self, action: "cellPressed:", forControlEvents: .TouchDown)
    titleButton?.addTarget(self, action: "cellPressReleased:", forControlEvents: .TouchUpOutside)
    titleButton?.addTarget(self, action: "cellSelected:", forControlEvents: .TouchUpInside)
    addSubview(titleButton!)
  }
  
  public func setupRightImageView() {
    rightImageView = UIImageView()
    rightImageView?.tintColor = .sexyGray()
    rightImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellTapped"))
    rightImageView?.userInteractionEnabled = true
    addSubview(rightImageView!)
  }
  
  public func cellPressed(sender: UIButton) {
    backgroundColor = .tableViewNativeSeparatorColor()
  }
  
  public func cellPressReleased(sender: UIButton) {
    UIView.animate { [weak self] in
      self?.backgroundColor = .whiteColor()
    }
  }
  
  public func cellSelected(sender: UIButton) {
    UIView.animate { [weak self] in
      self?.backgroundColor = .whiteColor()
    }
    cellTapped()
  }
  
  public func cellTapped() {
    _didSelectCell => true
    onClick?()
  }
  
  public func hideArrowIcon() {
    rightImageView?.hidden = true
  }
  
  public func showArrowIcon() {
    rightImageView?.hidden = false
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
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 8, yPad: 0, otherSize: screen.width - 48)
    switchImageView?.anchorToEdge(.Right, padding: 8, width: frame.height - 8, height: frame.height - 8)
    switchImageViewReferenceFrame = switchImageView?.frame
  }
  
  public override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .whiteColor()
    multipleTouchEnabled = true
    
    let pressGesture = UILongPressGestureRecognizer(target: self, action: "pressed:")
    pressGesture.minimumPressDuration = 0.01
    addGestureRecognizer(pressGesture)
  }
  
  private func setupTitleLabel() {
    titleLabel = UILabel()
    titleLabel?.textColor = .sexyGray()
    titleLabel?.font = .asapRegular(12)
    titleLabel?.adjustsFontSizeToFitWidth = true
    titleLabel?.minimumScaleFactor = 0.8
    titleLabel?.multipleTouchEnabled = true
    addSubview(titleLabel!)
  }
  
  public func setupSwitchImageView() {
    switchImageView = UIImageView(image: UIImage(named: "check")?.imageWithRenderingMode(.AlwaysTemplate))
    switchImageView?.tintColor = .juicyOrange()
    switchImageView?.multipleTouchEnabled = true
    addSubview(switchImageView!)
  }
  
  public func select() {
    _didSelectCell => toggle.getValue()
  }
  
  public func isOn() -> Bool {
    return toggle == .On
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

    switch toggle {
    case .On:
      switchImageView?.tintColor = .juicyOrange()
      break
    case .Off:
      switchImageView?.tintColor = .sexyGray()
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

public class ImageCell: DLTableViewCell {
  
  public var imageUrl: String?
  
  public override func setupSelf() {
    super.setupSelf()
    
    backgroundColor = .whiteColor()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView?.anchorInCenter(width: 100, height: 150)
    imageView?.dl_setImageFromUrl(imageUrl)
  }
}

public class BookViewCell: DLTableViewCell {
  
  public var bookView: BookView?
  
  public let _cellPressed = Signal<Bool>()
  
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
    bookView?._bookViewPressed.removeAllListeners()
    bookView?._bookViewPressed.listen(self) { [weak self] bool in
      self?._cellPressed.fire(true)
    }
    addSubview(bookView!)
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellPressed"))
  }
  
  
  public func setBook(book: Book?) {
    bookView?.setBook(book)
  }
  
  public func cellPressed() {
    TabView.currentView()?.pushViewController(BookProfileView().setBook(bookView?.book), animated: true)
    _cellPressed => true
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
  public var arrowImgView: UIImageView?
  
  public let _didSelectCell = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLabel()
    setupProfileImgView()
    layoutSubviews()
    //profileImgView?.anchorToEdge(.Right, padding: 0, width: 10, height: 10)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    hideBothTopAndBottomBorders()
    label?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
    
    arrowImgView?.anchorToEdge(.Right, padding: screen.width / 20, width: screen.width / 20, height: screen.width / 20)
    profileImgView?.align(.ToTheLeftCentered, relativeTo: arrowImgView!, padding: screen.width / 20, width: frame.height * (4 / 5), height: frame.height * (4 / 5))
    
  }
  
  public override func setupSelf() {
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
    if user.imageUrl != nil {
      
      profileImgView?.dl_setImageFromUrl(user.imageUrl, maskWithEllipse: true, animated: true)
      
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
    label?.textColor = .coolBlack()
    label?.font = .asapRegular(16)
    addSubview(label!)
  }
  
  private func setupProfileImgView(){
    profileImgView = UIImageView()
    let arrowImgT = Toucan(image: UIImage(named: "Icon-OrangeChevron")).resize(CGSize(width: frame.width/20, height: frame.width/20))
    arrowImgView = UIImageView()
    arrowImgView?.image = arrowImgT.image
    let profileImg = UIImage(named: "profile-placeholder")
    profileImgT = Toucan(image: profileImg).resize(CGSize(width: frame.width/10, height: frame.width/10)).maskWithEllipse()
    profileImgView?.image = profileImgT?.image
    addSubview(arrowImgView!)
    addSubview(profileImgView!)
    
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

public class PickerCell: DLTableViewCell {
  
  public var label: UILabel?
  //public var profileImg: UIImage?
  
  public var schoolName: String?
  public var schoolNameLabel: UILabel?
  public var arrowImgView: UIImageView?
  
  public let _didSelectCell = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  
    setupLabel()
    setupSchoolNameLabel()
    layoutSubviews()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    label?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
    
    arrowImgView?.anchorToEdge(.Right, padding: screen.width / 20, width: screen.width / 20, height: screen.width / 20)
    schoolNameLabel?.align(.ToTheLeftCentered, relativeTo: arrowImgView!, padding: screen.width / 20, width: frame.width * (2 / 3) - 20, height: frame.height)
    
    
    hideBothTopAndBottomBorders()
  }
  
  public override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    let pressGesture = UILongPressGestureRecognizer(target: self, action: "pressed:")
    pressGesture.minimumPressDuration = 0.01
    addGestureRecognizer(pressGesture)
  }
  
  private func setupLabel() {
    label = UILabel()
    label?.textColor = .coolBlack()
    label?.font = .asapRegular(16)
    addSubview(label!)
  }
  
  private func setupSchoolNameLabel(){
    schoolNameLabel = UILabel()
    let arrowImgT = Toucan(image: UIImage(named: "Icon-OrangeChevron")).resize(CGSize(width: frame.width/20, height: frame.width/20))
    arrowImgView = UIImageView()
    arrowImgView?.image = arrowImgT.image
    // FIXME: Default School name is Cal State LA
    schoolName = "Cal State LA"
    schoolNameLabel?.text = schoolName
    schoolNameLabel?.textAlignment = .Right
    schoolNameLabel?.textColor = .coolBlack()
    addSubview(arrowImgView!)
    addSubview(schoolNameLabel!)
    
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


public class BigImageCell: DLTableViewCell {
  
  public var label: UILabel?
  public var imageURL: String?
  public var bigImageView: UIImageView?
  
  public let _didSelectCell = Signal<Bool>()
  
  public var imageUrl: String?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    setupProfileImgView()
    
    hideBothTopAndBottomBorders()
    
    let yPad = screen.width / 50
    bigImageView?.anchorAndFillEdge(.Left, xPad: screen.width / 10, yPad: yPad, otherSize: frame.height - yPad * 2)
    label?.anchorAndFillEdge(.Right, xPad: screen.width / 10, yPad: screen.width / 30, otherSize: screen.width * (2 / 3))
    
    downloadImageFromURL()
  }
  
  public override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pressed:"))
  }
  
  private func setupLabel() {
    label = UILabel()
    label?.textColor = .coolBlack()
    label?.font = .asapRegular(16)
    addSubview(label!)
  }
  
  private func setupProfileImgView(){
    bigImageView?.removeFromSuperview()
    bigImageView = UIImageView()
    addSubview(bigImageView!)
    
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
  
  public func downloadImageFromURL(){
    bigImageView?.dl_setImageFromUrl(imageUrl, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
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
  private var toggleSelector: UIView?
  private var toggleContainer: UIView?
  private var toggle: Toggle = .Left// setting default
  
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
  
  public override func setupSelf() {
    backgroundColor = .whiteColor()
    hideBothTopAndBottomBorders()
  }
  
  private func setupToggleViews() {
    toggleContainer = UIView()
    toggleContainer?.backgroundColor = .whiteColor()
    toggleContainer?.multipleTouchEnabled = true
    addSubview(toggleContainer!)
    
    toggleSelector = UIView()
    toggleSelector?.backgroundColor = .juicyOrange()
    toggleSelector?.layer.cornerRadius = 8.0
    toggleContainer?.addSubview(toggleSelector!)
    
    let press = UILongPressGestureRecognizer(target: self, action: "dragSelector:")
    press.minimumPressDuration = 0.01
    
    toggleContainer?.addGestureRecognizer(press)
    
    leftToggleButton = UIButton()
    leftToggleButton?.setTitleColor(.coolBlack(), forState: .Normal)
    leftToggleButton?.backgroundColor = .clearColor()
    leftToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(leftToggleButton!)
    
    rightToggleButton = UIButton()
    rightToggleButton?.setTitleColor(.coolBlack(), forState: .Normal)
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
          self?.rightToggleButton?.setTitleColor(.coolBlack(), forState: .Normal)
          })
      } else if CGRectIntersectsRect(rightToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.setTitleColor(.coolBlack(), forState: .Normal)
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
  
  private var leftToggleButton: UIButton?
  private var middleToggleButton: UIButton?
  private var rightToggleButton: UIButton?
  private var toggleSelector: UIView?
  private var toggleContainer: UIView?
  private var toggle: Toggle = .Middle // setting default
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupToggleViews()
    
    toggleContainer?.fillSuperview()
    toggleContainer?.groupAndFill(group: .Horizontal, views: [leftToggleButton!, middleToggleButton!, rightToggleButton!], padding: 8)
    
    toggleSelector?.frame = middleToggleButton!.frame
    
    leftToggleButton?.imageView?.tintColor = .juicyOrange()
    middleToggleButton?.imageView?.tintColor = .coolBlack()
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
  
  public override func setupSelf() {
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
    leftToggleButton?.setTitleColor(.coolBlack(), forState: .Normal)
    leftToggleButton?.backgroundColor = .clearColor()
    leftToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(leftToggleButton!)
    
    middleToggleButton = UIButton()
    middleToggleButton?.setTitleColor(.coolBlack(), forState: .Normal)
    middleToggleButton?.backgroundColor = .clearColor()
    middleToggleButton?.titleLabel?.font = UIFont.asapRegular(16)
    toggleContainer?.addSubview(middleToggleButton!)
    
    rightToggleButton = UIButton()
    rightToggleButton?.setTitleColor(.coolBlack(), forState: .Normal)
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
          self?.leftToggleButton?.imageView?.tintColor = .coolBlack()
          self?.middleToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.rightToggleButton?.imageView?.tintColor = .juicyOrange()
          })
      } else if CGRectIntersectsRect(rightToggleButton.frame, selector.frame) || CGRectContainsPoint(rightToggleButton.frame, senderLocation) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.middleToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.rightToggleButton?.imageView?.tintColor = .coolBlack()
          })
      } else if CGRectIntersectsRect(middleToggleButton.frame, selector.frame) {
        UIView.animate({ [weak self] in
          self?.leftToggleButton?.imageView?.tintColor = .juicyOrange()
          self?.middleToggleButton?.imageView?.tintColor = .coolBlack()
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

public class SliderCell: DLTableViewCell {
  
  // Could add toggle to switch highlight
  public enum Toggle {
    case left
    case middle
    case right
  }
  
  private var container = UIView?()
  private var slider = UISlider?()
  private var leftFace = UIImageView?()
  private var middleFace = UIImageView?()
  private var rightFace = UIImageView?()
  private var toggle: Toggle = .middle // setting default
  
  public let _didSelectCell = Signal<Toggle>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    backgroundColor = .whiteColor()
    
    setupSlider()
    setupFaces()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    container?.fillSuperview()
    slider?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 48)
    leftFace?.anchorInCorner(.BottomLeft, xPad: 0, yPad: 0, width: 24, height: 24)
    leftFace?.align(.UnderMatchingLeft, relativeTo: slider!, padding: 0, width: 24, height: 24)
    middleFace?.anchorInCenter(width: 24, height: 24)
    middleFace?.align(.UnderCentered, relativeTo: slider!, padding: 0, width: 24, height: 24)
    rightFace?.anchorInCorner(.BottomRight, xPad: 0, yPad: 0, width: 24, height: 24)
    rightFace?.align(.UnderMatchingRight, relativeTo: slider!, padding: 0, width: 24, height: 24)
  }
  
  public func setupSlider() {
    container = UIView()
    slider = UISlider()
    slider!.minimumValue = 0
    slider!.minimumTrackTintColor = .juicyOrange()
    slider!.maximumValue = 2
    slider!.maximumTrackTintColor = .juicyOrange()
    slider!.setValue(1.0, animated: false)
    slider!.addTarget(self, action: "sliderChanged:", forControlEvents: .ValueChanged)
    container!.addSubview(slider!)
  }
  
  public func setupFaces() {
    leftFace = UIImageView(image:Toucan(image: UIImage(named: "Icon-Condition1")).image)
    leftFace?.frame = CGRect(x: 0,y: 0,width: 25,height: 25)
    container?.addSubview(leftFace!)
    
    middleFace = UIImageView(image:Toucan(image: UIImage(named: "Icon-Condition2")).image)
    middleFace?.frame = CGRect(x: 0,y: 0,width: 25,height: 25)
    container?.addSubview(middleFace!)
    
    rightFace = UIImageView(image:Toucan(image: UIImage(named: "Icon-Condition3")).image)
    rightFace?.frame = CGRect(x: 0,y: 0,width: 25,height: 25)
    container?.addSubview(rightFace!)
    
    addSubview(container!)
  }
  
  public func sliderChanged(sender: UISlider) {
    slider!.value = roundf(slider!.value)
    switch slider!.value {
    case 0:
      toggle = .left
      break
    case 1:
      toggle = .middle
      break
    case 2:
      toggle = .right
      break
    default:
      break
    }
    self._didSelectCell.fire(toggle)
  }
  
}

public class InputTextFieldCell: DLTableViewCell, UITextFieldDelegate {
  
  public var inputTextField: HoshiTextField?
  
  public let _inputTextFieldString = Signal<String?>()
  
  public let _isFirstResponder = Signal<Bool>()
  
  public var didBeginEditingBlock: (() -> Void)?
  public var didEndEditingBlock: (() -> Void)?
  
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
  
  public override func setupSelf() {
    backgroundColor = .whiteColor()
  }
  
  private func setupInputTextField() {
    inputTextField = HoshiTextField()
    inputTextField?.textColor = .coolBlack()
    inputTextField?.font = .asapRegular(16)
    inputTextField?.borderInactiveColor = .soothingBlue()
    inputTextField?.borderActiveColor = .juicyOrange()
    inputTextField?.placeholderColor = .sexyGray()
    inputTextField?.delegate = self
    addSubview(inputTextField!)
  }
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    _isFirstResponder => true
    didBeginEditingBlock?()
  }
  
  public func textFieldDidEndEditing(textField: UITextField) {
    _isFirstResponder => false
    didEndEditingBlock?()
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
  
  public func dismissKeyboard() {
    inputTextField?.resignFirstResponder()
  }
}

public class InputTextViewCell: DLTableViewCell, UITextViewDelegate {
  
  public var titleLabel: UILabel?
  public var inputTextView: KMPlaceholderTextView?
  
  public let _inputTextViewString = Signal<String?>()
  
  public let _isFirstResponder = Signal<Bool>()
  
  public var didBeginEditingBlock: (() -> Void)?
  public var didEndEditingBlock: (() -> Void)?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupInputTextView()
    
    titleLabel?.anchorAndFillEdge(.Top, xPad: 8, yPad: 2, otherSize: 12)
    
    separatorLine.frame = CGRectMake(8, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    inputTextView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 0, otherSize: bounds.height)
  }
  
  public override func setupSelf() {
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
    didBeginEditingBlock?()
  }
  
  public func textViewDidEndEditing(textView: UITextView) {
    didEndEditingBlock?()
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
  
  public func dismissKeyboard() {
    inputTextView?.resignFirstResponder()
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
    
    button?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 48)
    indicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
    buttonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
  }
  
  public override func setupSelf() {
    backgroundColor = .whiteColor()
  }
  
  private func setupButton() {
    
    button = SwiftyCustomContentButton()
    button?.buttonColor         = .juicyOrange()
    button?.highlightedColor    = .lightJuicyOrange()
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
    buttonLabel?.textColor = .whiteColor()
    buttonLabel?.font = .asapRegular(16)
    button?.customContentView.addSubview(buttonLabel!)
    
    addSubview(button!)
  }
  
  public func pressed() {
    _onPressed => true
  }
}

