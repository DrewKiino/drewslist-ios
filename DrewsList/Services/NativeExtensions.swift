//
//  NativeExtensions.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/4/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
  
  class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
    var rgb: CUnsignedInt = 0;
    let scanner = NSScanner(string: hex)
    
    if hex.hasPrefix("#") {
      // skip '#' character
      scanner.scanLocation = 1
    }
    scanner.scanHexInt(&rgb)
    
    let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
    let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
    let b = CGFloat(rgb & 0xFF) / 255.0
    
    return UIColor(red: r, green: g, blue: b, alpha: alpha)
  }
  
  // MARK: Main App Colors
  
  public class func sexyGray() -> UIColor {
    return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
  }
  
  public class func soothingBlue() -> UIColor {
    return UIColor(red: 59/255, green: 92/255, blue: 156/255, alpha: 1.0)
  }
  
  public class func bareBlue() -> UIColor {
    return UIColor(red: 49/255, green: 77/255, blue: 122/255, alpha: 1.0)
  }
  
  public class func sweetBeige() -> UIColor {
    return UIColor(red: 249/255, green: 198/255, blue: 118/255, alpha: 1.0)
  }
  
  // NOTE: Highlight Color
  
  public class func juicyOrange() -> UIColor {
    return UIColor(red: 240/255, green: 139/255, blue: 35/255, alpha: 1.0)
  }
  
  public class func darkJuicyOrange() -> UIColor {
    return UIColor(red: 210/255, green: 113/255, blue: 14/255, alpha: 1.0)
  }
  
  public class func moneyGreen() -> UIColor {
    return UIColor(red: 32/255, green: 108/255, blue: 42/255, alpha: 1.0)
  }
  
  // NOTE: TableView Padding Color
  
  public class func paradiseGray() -> UIColor {
    return UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 0.5)
  }
  
  public class func tableViewNativeSeparatorColor() -> UIColor {
    return UIColor(red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
  }
}

extension UIFont {
  
  /**
   * Asap-Bold
   * Asap-Italic
   * Asap-Regular
   * Asap-BoldItalic
   */
  
  public class func asapBold(size: CGFloat) -> UIFont {
    return UIFont(name: "Asap-Bold", size: size)!
  }
  
  public class func asapItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Asap-Italic", size: size)!
  }
  
  public class func asapRegular(size: CGFloat) -> UIFont {
    return UIFont(name: "Asap-Regular", size: size)!
  }

  public class func asapBoldItalic(size: CGFloat) -> UIFont {
    return UIFont(name: "Asap-BoldItalic", size: size)!
  }
}

extension String {
  
  public func convertToOrdinal() -> String {
    if  let last = characters.last where Int(String(last)) != nil && self.lowercaseString.rangeOfString("edition") == nil {
      if last == "1" {
        return "\(self)st"
      } else if last == "2" {
        return "\(self)nd"
      } else if last == "3" {
        return "\(self)rd"
      } else {
        return "\(self)th"
      }
    }
    return self
  }
  
  public func isValidName() -> Bool {
    if let _ = try! NSRegularExpression(pattern: ".*[^A-Za-z-].*", options: .CaseInsensitive).firstMatchInString(self, options: .ReportCompletion, range: NSMakeRange(0, self.characters.count)) { return false }
    return true
  }
  
  public func isValidPassword() -> Bool {
    if  let _ = self.rangeOfCharacterFromSet(.uppercaseLetterCharacterSet()),
        let _ = self.rangeOfCharacterFromSet(.lowercaseLetterCharacterSet()),
        let _ = self.rangeOfCharacterFromSet(.decimalDigitCharacterSet()),
        let _ = self.rangeOfCharacterFromSet(NSCharacterSet.alphanumericCharacterSet().invertedSet)
        where self.rangeOfCharacterFromSet(.whitespaceCharacterSet()) == nil && !self.isEmpty
    {
      return true
    }
    return false
  }
  
  func isValidEmail() -> Bool {
    let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
    let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
    return emailTest.evaluateWithObject(self) && !self.isEmpty
  }
}

import NVActivityIndicatorView
import LTMorphingLabel
import SwiftyTimer
import CWStatusBarNotification

extension UIView {
  
  public class func animate(animationBlock: () -> Void, completionBlock: ((bool: Bool) -> Void)? = nil) {
    UIView.animateWithDuration(0.7, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.10, options: .CurveEaseInOut, animations: animationBlock, completion: completionBlock)
  }
  
  public func showLoadingScreen(heightOffset: CGFloat? = nil, bgOffset: CGFloat? = nil, fadeIn: Bool = false, completionHandler: (() -> Void)? = nil) {
  
    subviews.forEach {
      if let view = $0 as? NVActivityIndicatorView { view.removeFromSuperview() }
      else if let view = $0 as? LTMorphingLabel { view.removeFromSuperview() }
    }
    
    let backgroundView = UIView(frame: CGRectMake(0, heightOffset != nil ? 0 : bgOffset ?? 64, screen.width, screen.height))
    backgroundView.alpha = 0.0
    backgroundView.backgroundColor = .whiteColor()
    backgroundView.tag = 1337
    addSubview(backgroundView)
    
    let activityView = NVActivityIndicatorView(
      frame: CGRectMake(0, heightOffset != nil ? heightOffset! : 0, screen.width, screen.height),
      type: .Pacman,
      color: UIColor.sweetBeige(),
      size: CGSizeMake(48, 48)
    )
    activityView.alpha = 0.0
    activityView.backgroundColor = .clearColor()
    activityView.startAnimation()
    addSubview(activityView)
    
    let loadingLabel = LTMorphingLabel(frame: CGRectMake((screen.width / 2) - 56, (screen.height / 2) + 8 + (heightOffset != nil ? heightOffset! : 0), 100, 48))
    loadingLabel.alpha = 0.0
    loadingLabel.text = "Loading"
    loadingLabel.textAlignment = .Center
    loadingLabel.font = UIFont.asapBold(16)
    loadingLabel.textColor = .blackColor()
    loadingLabel.morphingEffect = .Evaporate
    addSubview(loadingLabel)
    
    if fadeIn == true {
      UIView.animateWithDuration(0.2, delay: 0, options: .CurveEaseInOut, animations: { [weak backgroundView, weak activityView, weak loadingLabel] in
        backgroundView?.alpha = 1.0
        activityView?.alpha = 1.0
        loadingLabel?.alpha = 1.0
      }, completion: { bool in
        completionHandler?()
      })
    } else {
      backgroundView.alpha = 1.0
      activityView.alpha = 1.0
      loadingLabel.alpha = 1.0
    }
    
    NSTimer.every(0.5) { [weak loadingLabel] in
      switch loadingLabel?.text {
      case .Some("Loading"): loadingLabel?.text = "Loading ."
      case .Some("Loading ."): loadingLabel?.text = "Loading . ."
      case .Some("Loading . ."): loadingLabel?.text = "Loading . . ."
      case .Some("Loading . . ."): loadingLabel?.text = "Loading"
      default: break
      }
    }
    
    NSTimer.after(30.0) { [weak self] in self?.hideLoadingScreen() }
//    let randomInt = arc4random_uniform(10) + 0
  }
  
  public func hideLoadingScreen() {
    subviews.forEach {
      if let view: UIView? = $0 where $0.tag == 1337 {
        UIView.animateWithDuration(0.5, delay: 0.7, options: .CurveEaseInOut, animations: { [weak view] in
          view?.alpha = 0.0
        }, completion: { [weak view] bool in
          view?.removeFromSuperview()
        })
      } else if let view = $0 as? NVActivityIndicatorView {
        UIView.animateWithDuration(1.0, delay: 0, options: .CurveEaseInOut, animations: { [weak view] in
          view?.alpha = 0.0
        }, completion: { [weak view] bool in
          view?.removeFromSuperview()
        })
      }
      else if let view = $0 as? LTMorphingLabel {
        UIView.animateWithDuration(1.0, delay: 0.2, options: .CurveEaseInOut, animations: { [weak view] in
          view?.alpha = 0.0
        }, completion: { [weak view] bool in
          view?.removeFromSuperview()
        })
      }
    }
  }
  
  public func displayNotification(text: String) {
    
    let notification = CWStatusBarNotification()
    notification.notificationAnimationInStyle = .Bottom
    notification.notificationAnimationOutStyle = .Bottom
    notification.notificationStyle = .StatusBarNotification

    let loadingLabel = LTMorphingLabel(frame: CGRectMake(0, 0, screen.width, 64))
    loadingLabel.text = text
    loadingLabel.textAlignment = .Center
    loadingLabel.font = UIFont.asapBold(12)
    loadingLabel.textColor = .whiteColor()
    loadingLabel.morphingEffect = .Evaporate
    loadingLabel.backgroundColor = .bareBlue()
    
    NSTimer.every(0.5) { [weak loadingLabel] in
      switch loadingLabel?.text {
      case .Some(text): loadingLabel?.text = "\(text) ."
      case .Some("\(text) ."): loadingLabel?.text = "\(text) . ."
      case .Some("\(text) . ."): loadingLabel?.text = "\(text) . . ."
      case .Some("\(text) . . ."): loadingLabel?.text = text
      default: break
      }
    }
    
    notification.displayNotificationWithView(loadingLabel, forDuration: 3.0)
  }
  
  public func showComingSoonScreen() {
    subviews.forEach { if let view: UILabel? = $0 as? UILabel where $0.tag == 1337 { view?.removeFromSuperview() } }
    
    let label = UILabel(frame: CGRectMake(0, 0, frame.width, frame.height))
    label.text = "Coming Soon!"
    label.textAlignment = .Center
    label.font = .asapRegular(16)
    label.tag = 1337
    
    addSubview(label)
  }
}

import SDWebImage

extension UIImageView {
  
  public func dl_setImageFromUrl(url: String?, completionHandler: SDWebImageCompletionBlock?) {
    guard let url = url, let nsurl = NSURL(string: url) else { return }
    sd_setImageWithURL(nsurl, placeholderImage: nil, options: [
      .CacheMemoryOnly,
      .ContinueInBackground,
//      .ProgressiveDownload,
      .AvoidAutoSetImage,
      .LowPriority
    ]) { image, error, cache, url in
      completionHandler?(image, error, cache, url)
    }
  }
  
  public class func dl_setImageFromUrl(url: String?, completionHandler: SDWebImageCompletionWithFinishedBlock?) {
    guard let url = url, let nsurl = NSURL(string: url) else { return }
    SDWebImageManager.sharedManager().downloadImageWithURL(nsurl, options: [], progress: { (received: NSInteger, actual: NSInteger) -> Void in
    }) { (image, error, cache, finished, nsurl) -> Void in
      if image != nil && finished == true { completionHandler?(image, error, cache, finished, nsurl) }
    }
  }
}

extension NSAttributedString {
  
  func heightWithConstrainedWidth(width: CGFloat) -> CGFloat {
    let constraintRect = CGSize(width: width, height: CGFloat.max)
    let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
    
    return ceil(boundingBox.height)
  }
  
  func widthWithConstrainedHeight(height: CGFloat) -> CGFloat {
    let constraintRect = CGSize(width: CGFloat.max, height: height)
    
    let boundingBox = self.boundingRectWithSize(constraintRect, options: NSStringDrawingOptions.UsesLineFragmentOrigin, context: nil)
    
    return ceil(boundingBox.width)
  }
}



