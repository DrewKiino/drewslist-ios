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
    titleTextLabel?.textColor = .blackColor()
    titleTextLabel?.font = .asapRegular(12)
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
    
    titleButton?.anchorAndFillEdge(.Left, xPad: 10, yPad: 0, otherSize: screen.width)
    rightImageView?.anchorToEdge(.Right, padding: 0, width: 12, height: 16)
    rightImageView?.image = Toucan(image: UIImage(named: "Icon-GreyChevron")?.imageWithRenderingMode(.AlwaysTemplate)).resize(rightImageView?.frame.size, fitMode: .Clip).image
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
    _didSelectCell => true
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
    multipleTouchEnabled = false
    
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
    addSubview(bookView!)
  }
  
  public func setBook(book: Book?) {
    bookView?.setBook(book)
  }
  
  public func cellPressed() {
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
    label?.textColor = .blackColor()
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
//      if user.imageUrl != nil {
//        
//        self?.profileImgView?.dl_setImageFromUrl(user.imageUrl) { [weak self] image, error, cache, url in
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
  
  public func setupUser(user: User?){
    guard let user = user else { return }
    
    let duration: NSTimeInterval = 0.2
   // FIXME: grab user from server for school name
  }
  
  private func setupLabel() {
    label = UILabel()
    label?.textColor = .blackColor()
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
  
  // FIXME: Setup the User's School
  
//  public func setupUserSchool(user : User?){
//  
//  
//  }
}


public class BigImageCell: DLTableViewCell {
  
  public var label: UILabel?
  public var imageURL: String?
  public var imageToucan: Toucan?
  public var bigImageView: UIImageView?
  
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
    
    let yPad = screen.width / 50
    bigImageView?.anchorAndFillEdge(.Left, xPad: screen.width / 10, yPad: yPad, otherSize: frame.height - yPad * 2)
    label?.anchorAndFillEdge(.Right, xPad: screen.width / 10, yPad: screen.width / 30, otherSize: screen.width * (2 / 3))
    
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
    label?.textColor = .blackColor()
    label?.font = .asapRegular(16)
    addSubview(label!)
  }
  
  private func setupProfileImgView(){
    bigImageView = UIImageView()
    let defaultImg = UIImage(named: "profile-placeholder")
    imageToucan = Toucan(image: defaultImg).resize(CGSize(width: frame.width, height: frame.width)).maskWithEllipse()
//    imageToucan = Toucan(image: defaultImg).maskWithEllipse()

    bigImageView?.image = imageToucan?.image
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
  
  public func downloadImageFromURL(url: String?){
    bigImageView?.dl_setImageFromUrl(url, size: bigImageView?.frame.size, maskWithEllipse: true) { [weak self] image in
      
      self?.bigImageView?.alpha = 0.0
      self?.bigImageView?.image = image
      
      UIView.animateWithDuration(0.1) { [weak self] in
        self?.bigImageView?.alpha = 1.0
      }
    }
  }
  
}
