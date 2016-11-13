//
//  KeyboardManager.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class KeyboardManager: NSObject {
  
  public static let keyboardWillShowSignal = Signal<(CGRect)>()
  public static let keyboardWillHideSignal = Signal<()>()
  
  private static let manager = KeyboardManager()
  public class func sharedInstance() -> KeyboardManager { let manager = KeyboardManager.manager; manager.setup(); return manager }
  
  deinit {
    NSNotificationCenter.defaultCenter().removeObserver(self)
  }
  
  private func setup() {
    NSNotificationCenter.defaultCenter().removeObserver(self)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
  }
  
  public func keyboardWillShow(sender: NSNotification) {
    if let userInfo = sender.userInfo, frame = userInfo[UIKeyboardFrameEndUserInfoKey]?.CGRectValue {
      log.debug("keyboard will show")
      KeyboardManager.keyboardWillShowSignal => frame
    }
  }
  
  public func keyboardWillHide(sender: NSNotification) {
    log.debug("keyboard will hide")
    KeyboardManager.keyboardWillHideSignal => ()
  }
}