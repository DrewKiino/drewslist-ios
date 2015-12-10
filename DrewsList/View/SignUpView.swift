//
//  SignUpView.swift
//  DrewsList
//
//  Created by Starflyer on 12/6/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import QuartzCore
import TextFieldEffects
import Neon
import Toucan


public class SignUpView: UIViewController, UITextFieldDelegate {
  
  // good job specifying all the function and variable class scopes!
  
  private let controller = SignUpController()
  private var model: SignUpModel{ get { return controller.model } }
  

  //MARK: Outlets for UI Elements.
  private let backgroundImage = UIImageView()
  private let containerView = UIView()
  var usernameField:   HoshiTextField?
  var emailField:      HoshiTextField?
  var passwordField:   HoshiTextField?
  var next:     UIButton?
  
  
  // the mark tag's syntax looks like this:
  //
  //    '// MARK: .....'
  //
  // and that they should be placed in its own space because if
  // tags are places right on top of variables and functions they would
  // get attached to those things instead
  // Steven's 'marking' of different class features is a great example
  // Check out his ISBNScannerView
  
  // MARK: View Controller LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBackgroundImage()
    setupContainerView()
    setupUsernameLabel()
    setupPasswordLabel()
    setupEmailLabel()
    
    
    // remember to modularize each setup function to it's distinct functionality
    
    //      loginButton.alpha   = 0;
    
    //      UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
    //        self.usernameField.alpha = 1.0
    //        self.emailField.alpha = 1.0
    //        self.passwordField.alpha = 1.0
    //        self.loginButton.alpha   = 0.9
    //      }, completion: nil)
    
    // Notifiying for Changes in the textFields
    //        usernameField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
    //        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
    //        emailField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
    
    
    
    
    // Visual Effect View for background
    //      let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark)) as UIVisualEffectView
    //      visualEffectView.frame = self.view.frame
    //      visualEffectView.alpha = 0.5
    //      imageView.image = UIImage(named: "img1-1.png")
    //      imageView.addSubview(visualEffectView)
    //
    //
    //      NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "changeImage", userInfo: nil, repeats: true)
    //      self.loginButton(false)
  }
  
  private func setupBackgroundImage() {
    view.addSubview(backgroundImage)
  }
  
  private func setupContainerView() {
    containerView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    view.addSubview(containerView)
  }
  
  public func dismissKeyboard() {
    usernameField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    emailField?.resignFirstResponder()
  }
  
  //MARK: Global Variables for Changing Image Functionality.
  private var idx: Int = 0
  private let backGroundArray = [UIImage(named: "img1-1.png"),UIImage(named:"book6.png"), UIImage(named: "book7.png")]
  
  public func setupUsernameLabel() {
    //    usernameField.alpha = 0;
    //    usernameField.tag = 1
    //    usernameField.delegate = self
    usernameField = HoshiTextField()
    usernameField?.borderInactiveColor = UIColor.bareBlue()
    usernameField?.borderActiveColor = UIColor.juicyOrange()
    usernameField?.placeholderColor = UIColor.sexyGray()
    usernameField?.placeholder = "Enter a Username"
    usernameField?.delegate = self
    
    containerView.addSubview(usernameField!)
  }
  
  public func setupPasswordLabel() {
    //    passwordField.alpha = 0;
    //    passwordField.tag = 2
    //    passwordField.delegate = self
    passwordField = HoshiTextField()
    passwordField?.borderInactiveColor = UIColor.bareBlue()
    passwordField?.borderActiveColor = UIColor.juicyOrange()
    passwordField?.placeholderColor = UIColor.sexyGray()
    passwordField?.placeholder = "Create a Password"
    passwordField?.delegate = self
    
    containerView.addSubview(passwordField!)
  }
  
  public func setupEmailLabel() {
    emailField = HoshiTextField()
    emailField?.borderInactiveColor = UIColor.bareBlue()
    emailField?.borderInactiveColor = UIColor.juicyOrange()
    emailField?.borderInactiveColor = UIColor.sexyGray()
    emailField?.placeholder = "Enter an Email"
    emailField?.delegate = self
    
    containerView.addSubview(emailField!)
    
  }
  
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    backgroundImage.fillSuperview()
    backgroundImage.image = Toucan(image: UIImage(named: "DrewsList_WireFrames_iOS-21")!).resize(backgroundImage.frame.size).image
    
    containerView.fillSuperview(left: 40, right: 40, top: 128, bottom: 128)
    
    usernameField?.anchorAndFillEdge(.Top, xPad: 0, yPad: 30, otherSize: 48)
    passwordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: usernameField!, padding: 0, height: 48)
    emailField?.alignAndFillWidth(align: .UnderCentered, relativeTo: passwordField!, padding: 0, height: 48)
    
    
    //NextButton
    
      next = UIButton(frame: CGRectMake(self.view.bounds.origin.x + (self.view.bounds.width * 0.325), self.view.bounds.origin.y + (self.view.bounds.height * 0.8), self.view.bounds.origin.x + (self.view.bounds.width * 0.35), self.view.bounds.origin.y + (self.view.bounds.height * 0.05)))
    
      next!.layer.cornerRadius = 0.0
      next!.layer.borderWidth = 2.0
      next!.backgroundColor = UIColor.juicyOrange()
      next!.layer.borderColor = UIColor.juicyOrange().CGColor
      next!.setTitle("Next", forState: UIControlState.Normal)
      next!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
  
       self.view.addSubview(next!)
  

    
  }
  
  
  public func SignupButton(enabled: Bool) -> () {
    
    //      func enable(){
    //        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
    //            self.loginButton.backgroundColor = UIColor.colorWithHex("#F9C676", alpha: 1)
    //            }, completion: nil)
    //        loginButton.enabled = true
    //      }
    //      func disable(){
    //        loginButton.enabled = false
    //        UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
    //            self.loginButton.backgroundColor = UIColor.colorWithHex("#F08B23",alpha :1)
    //            }, completion: nil)
    //      }
    //      return enabled ? enable() : disable()
  }
  
  
  public func changeImage(){
    if idx == backGroundArray.count-1{
      
      idx = 0
      
    } else{
      
      idx++
    }
    //        let toImage = backGroundArray[idx];
    //        UIView.transitionWithView(self.imageView, duration: 3, options: .TransitionCrossDissolve, animations: {self.imageView.image = toImage}, completion: nil)
    
  }
  
  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public func textFieldDidBeginEditing(textField: UITextField) {
  }
  
  
  
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    switch textField.tag {
      // username
    case 1:
      print("Hello \(textField.text!)")
      break
      // password
    case 2:
      print("Hi \(textField.text!)")
      break
      // email
    case 3:
      print(textField.text)
      break
    default: break
    }
    return true
  }
  
  //   public func textFieldDidChange() {
  //        if usernameField.text!.isEmpty || passwordField.text!.isEmpty || emailField.text!.isEmpty
  //        {
  //            self.loginButton(false)
  //        }
  //        else
  //        {
  //            self.loginButton(true)
  //        }
  //    }
  
  func buttonPressed(sender: AnyObject) {
    //        self.performSegueWithIdentifier("login", sender: self)
  }
  
  func signupPressed(sender: AnyObject) {
  }
  
  
  func backgroundPressed(sender: AnyObject) {
    usernameField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    emailField?.resignFirstResponder()
  }
  
  
}
//
////Extension for Color to take Hex Values
//extension UIColor{
//  
//  // this is nice.
//  
//  class func colorWithHex(hex: String, alpha: CGFloat = 1.0) -> UIColor {
//    var rgb: CUnsignedInt = 0;
//    let scanner = NSScanner(string: hex)
//    
//    if hex.hasPrefix("#") {
//      // skip '#' character
//      scanner.scanLocation = 1
//    }
//    scanner.scanHexInt(&rgb)
//    
//    let r = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
//    let g = CGFloat((rgb & 0xFF00) >> 8) / 255.0
//    let b = CGFloat(rgb & 0xFF) / 255.0
//    
//    return UIColor(red: r, green: g, blue: b, alpha: alpha)
//  }
//}
//
//
//
//


