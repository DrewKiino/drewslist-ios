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

public class DLTableView: UITableView {
  
  public init() {
    super.init(frame: CGRectZero, style: .Plain)
    setupSelf()
  }
  
  private func setupSelf() {
    registerClass(PaddingCell.self, forCellReuseIdentifier: "PaddingCell")
    registerClass(TitleCell.self, forCellReuseIdentifier: "TitleCell")
    registerClass(FullTitleCell.self, forCellReuseIdentifier: "FullTitleCell")
    registerClass(SwitchCell.self, forCellReuseIdentifier: "SwitchCell")
    
    allowsSelection = false
    showsVerticalScrollIndicator = false
    backgroundColor = .paradiseGray()
    separatorColor = .clearColor()
  }
  
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}


public class PaddingCell: UITableViewCell {
  
  public var paddingLabel: UILabel?
  private let topBorder = CALayer()
  private let bottomBorder = CALayer()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupPaddingLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    paddingLabel?.anchorAndFillEdge(.Left, xPad: 14, yPad: 12, otherSize: 300)
    
    topBorder.frame = CGRectMake(0, 0, bounds.size.width, 1)
    bottomBorder.frame = CGRectMake(0, bounds.size.height - 1, bounds.size.width, 1)
  }
  
  private func setupSelf() {
    backgroundColor = .clearColor()
    
    topBorder.backgroundColor = UIColor.tableViewNativeSeparatorColor().CGColor
    topBorder.zPosition = 2
    layer.addSublayer(topBorder)
    
    bottomBorder.backgroundColor = UIColor.tableViewNativeSeparatorColor().CGColor
    bottomBorder.zPosition = 2
    layer.addSublayer(bottomBorder)
    
    hideSeparatorLine()
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
  
  public func hideSeparatorLine() {
    separatorInset = UIEdgeInsetsMake(0, width, 0, 0)
  }
  
  public func hideTopBorder() {
    topBorder.hidden = true
  }
  
  public func hideBottomBorder() {
    bottomBorder.hidden = true
  }
}

public class TitleCell: UITableViewCell {
  
  private let separatorLine = CALayer()
  
  public var titleLabel: UILabel?
  public var titleTextLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupTitleLabel()
    setupTitleTextLabel()
    
    titleLabel?.anchorAndFillEdge(.Left, xPad: 14, yPad: 8, otherSize: 80)
    titleTextLabel?.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: titleLabel!, padding: 8, height: 24)
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  private func setupSelf() {
    backgroundColor = .whiteColor()
    
    separatorLine.backgroundColor = UIColor.tableViewNativeSeparatorColor().CGColor
    separatorLine.zPosition = 2
    layer.addSublayer(separatorLine)
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
  
  public func hideSeparatorLine() {
    separatorInset = UIEdgeInsetsMake(0, width, 0, 0)
    separatorLine.hidden = true
  }
}

public class FullTitleCell: UITableViewCell {
  
  private let separatorLine = CALayer()
  
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
    
    separatorLine.frame = CGRectMake(14, 0, bounds.size.width - 1, 1)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
  }
  
  private func setupSelf() {
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
  
  public func hideSeparatorLine() {
    separatorInset = UIEdgeInsetsMake(0, width, 0, 0)
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

public class SwitchCell: UITableViewCell {
  
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
  
  private func setupSelf() {
    
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
  
  public func hideSeparatorLine() {
    separatorInset = UIEdgeInsetsMake(0, width, 0, 0)
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

