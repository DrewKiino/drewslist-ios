//
//  ViewController.swift
//  Swifty
//
///  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///

import Foundation
import UIKit
import QuartzCore
import TextFieldEffects
import Neon
import Toucan
import SwiftyButton

public class LoginView: UIViewController, UITextFieldDelegate {
  
  // good job specifying all the function and variable class scopes!
  
  private let controller = LoginController()
  private var model: LoginModel { get { return controller.model } }
  
  //MARK: Outlets for UI Elements.
  private let backgroundImage = UIImageView()
  private let containerView = UIView()
  var usernameField:   HoshiTextField?
  var emailField:      HoshiTextField?
  var passwordField:   HoshiTextField?
  var loginButton:     SwiftyButton?          //UIButton?
  var signupButton:    SwiftyButton?         //UIButton?
  
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
    usernameField?.placeholder = "Username"
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
    passwordField?.placeholder = "Password"
    passwordField?.delegate = self
    
    containerView.addSubview(passwordField!)
  }
  
  public func setupEmailLabel() {
    //    emailField.alpha    = 0;
    //    emailField.tag = 3
    //    emailField.delegate = self
    
  }
  

  //9261 299999 2562 5479 5314
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    backgroundImage.fillSuperview()
    backgroundImage.image = Toucan(image: UIImage(named: "DrewsList_WireFrames_iOS-21")!).resize(backgroundImage.frame.size).image

    containerView.fillSuperview(left: 40, right: 40, top: 128, bottom: 128)
    usernameField?.anchorAndFillEdge(.Top, xPad: 0, yPad: 60, otherSize: 48)
    passwordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: usernameField!, padding: 0, height: 48)
  
    
    
 /*
    
    //Mark: Temp Login/Signup Buttons
    
    
//    //loginButton
//    loginButton = UIButton(frame: CGRectMake(self.view.bounds.origin.x + (self.view.bounds.width * 0.325), self.view.bounds.origin.y + (self.view.bounds.height * 0.8), self.view.bounds.origin.x + (self.view.bounds.width * 0.35), self.view.bounds.origin.y + (self.view.bounds.height * 0.05)))
//    loginButton!.layer.cornerRadius = 3.0
//    loginButton!.layer.borderWidth = 2.0
//    loginButton!.center = CGPoint(x: 85, y: 480)
//    loginButton!.backgroundColor = UIColor.juicyOrange()
//    loginButton!.layer.borderColor = UIColor.juicyOrange().CGColor
//    loginButton!.setTitle("Log In", forState: UIControlState.Normal)
//    loginButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//
//  
//
//    self.view.addSubview(loginButton!)
//    
//    //SignUpButton
//    signupButton = UIButton(frame: CGRectMake(self.view.bounds.origin.x + (self.view.bounds.width * 0.325), self.view.bounds.origin.y + (self.view.bounds.height * 0.8),
//    self.view.bounds.origin.x + (self.view.bounds.width * 0.35), self.view.bounds.origin.y + (self.view.bounds.height * 0.05)))
//    signupButton!.layer.cornerRadius = 3.0
//    signupButton!.layer.borderWidth = 2.0
//    signupButton!.center = CGPoint(x: 230 , y: 480)
//    signupButton!.backgroundColor = UIColor.bareBlue()
//    signupButton!.layer.backgroundColor = UIColor.bareBlue().CGColor
//    signupButton!.setTitle("Sign Up", forState: UIControlState.Normal)
//    signupButton!.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//    
//    
//    self.view.addSubview(signupButton!)
    
*/


    //SetupSwitfyloginButton
    loginButton = SwiftyButton()
    loginButton?.buttonColor = .juicyOrange()
    loginButton?.shadowColor = .bareBlue()
    loginButton?.shadowHeight = 2
    loginButton?.cornerRadius = 2
    loginButton?.titleLabel?.font = UIFont(name: "Asap-Bold", size: 13)
    loginButton?.setTitle("Log In", forState: .Normal)
    loginButton?.frame = CGRectMake(60, screen.height - 150, 110, 30)
    
    view.addSubview(loginButton!)
    
    
    
    
//    //SetupSwiftySignupButton //Need to DBG
//    signupButton = SwiftyButton()
//    signupButton?.buttonColor = .bareBlue()
//    signupButton?.shadowColor = .juicyOrange()
//    signupButton?.shadowHeight = 2
//    signupButton?.cornerRadius = 2
//    signupButton?.titleLabel?.font = UIFont(name: "Asap-Bold", size:  13)
//    signupButton?.setTitle("Sign Up", forState: .Normal)
//    signupButton?.frame = CGRectMake(60, screen.height - 150, 110, 30)
//    //signupButton?.addTarget(self, action: "SignUpView", forControlEvents: .TouchUpInside)
//    
//    view.addSubview(signupButton!)

    
  
  }
  
  
  public func loginButton(enabled: Bool) -> () {
    
  }
  
  
  public func signupButton(enabled: Bool) -> () {
    
    self.performSegueWithIdentifier("SignUpView", sender: self)
    
  }
  
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    
  }
  

  //TextFieldCaseCode
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

//Extension for Color to take Hex Values
extension UIColor{
  
  // this is nice.
    
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
}





