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
import SwiftyButton

public class LoginView: UIViewController, UITextFieldDelegate {
  
  // good job specifying all the function and variable class scopes!
  
  private let controller = LoginController()
  private var model: LoginModel { get { return controller.model } }
  
  //MARK: Outlets for UI Elements.
  private var backgroundImage: UIImageView?
  private var containerView: UIView?
  private var drewslistLogo: UIImageView?
  private var emailField:      HoshiTextField?
  private var passwordField:   HoshiTextField?
  private var loginButton:     SwiftyCustomContentButton?          //UIButton?
  private var loginButtonIndicator: UIActivityIndicatorView?
  private var loginButtonLabel: UILabel?
  private var orLabel: UILabel?
  var signupButton:    SwiftyCustomContentButton?         //UIButton?
  
  private var idx: Int = 0
  private let backGroundArray = [UIImage(named: "img1-1.png"),UIImage(named:"book6.png"), UIImage(named: "book7.png")]

  // MARK: View Controller LifeCycle
  
  public override func viewDidLoad() {
      super.viewDidLoad()
    
    
    setupSelf()
    setupBackgroundImage()
    setupContainerView()
    setupDrewslistLogo()
    setupPasswordLabel()
    setupEmailLabel()
    setupLoginButton()
    setupOrLabel()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    
    backgroundImage?.fillSuperview()
    backgroundImage?.image = Toucan(image: UIImage(named: "background-image2")).resize(backgroundImage?.frame.size, fitMode: .Clip).image
    
    containerView?.fillSuperview(left: 40, right: 40, top: 128, bottom: 128)
    
    drewslistLogo?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: containerView!.frame.width * 0.11)
    drewslistLogo?.image = Toucan(image: UIImage(named: "DrewsListLogo_Login-1")).resize(drewslistLogo?.frame.size).image
    
    emailField?.alignAndFillWidth(align: .UnderCentered, relativeTo: drewslistLogo!, padding: 0, height: 48)
    passwordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: emailField!, padding: 0, height: 48)
    
    loginButton?.alignAndFillWidth(align: .UnderCentered, relativeTo: passwordField!, padding: 8, height: 48)
    loginButtonIndicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
    loginButtonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
    
    orLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: loginButton!, padding: 0, height: 24)
  }
  
  private func setupSelf() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
  }
  
  private func setupBackgroundImage() {
    backgroundImage = UIImageView()
    view.addSubview(backgroundImage!)
  }
  
  private func setupContainerView() {
    containerView = UIView()
    view.addSubview(containerView!)
  }

  private func setupDrewslistLogo() {
    drewslistLogo = UIImageView()
    containerView?.addSubview(drewslistLogo!)
  }
  
  public func dismissKeyboard() {
    emailField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
  }

  public func setupEmailLabel() {
    emailField = HoshiTextField()
    emailField?.borderInactiveColor = .bareBlue()
    emailField?.borderActiveColor = .juicyOrange()
    emailField?.placeholderColor = .whiteColor()
    emailField?.placeholder = "Email"
    emailField?.delegate = self
    emailField?.font = .asapRegular(16)
    emailField?.textColor = .whiteColor()
    
    containerView?.addSubview(emailField!)
  }
  
  public func setupPasswordLabel() {
    passwordField = HoshiTextField()
    passwordField?.borderInactiveColor = .bareBlue()
    passwordField?.borderActiveColor = .juicyOrange()
    passwordField?.placeholderColor = .whiteColor()
    passwordField?.placeholder = "Password"
    passwordField?.delegate = self
    passwordField?.secureTextEntry = true
    passwordField?.font = .asapRegular(16)
    passwordField?.textColor = .whiteColor()
    
    containerView?.addSubview(passwordField!)
  }
  
  private func setupLoginButton() {
    //SetupSwitfyloginButton
    loginButton = SwiftyCustomContentButton()
    loginButton?.buttonColor         = .juicyOrange()
    loginButton?.highlightedColor    = .darkJuicyOrange()
    loginButton?.shadowColor         = .clearColor()
    loginButton?.disabledButtonColor = .clearColor()
    loginButton?.disabledShadowColor = .clearColor()
    loginButton?.shadowHeight        = 0.0
    loginButton?.cornerRadius        = 0.0
    loginButton?.buttonPressDepth    = 0.0 // In percentage of shadowHeight
    loginButton?.addTarget(self, action: "loginButtonPressed", forControlEvents: .TouchUpInside)
    
    loginButtonIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    loginButton?.customContentView.addSubview(loginButtonIndicator!)
    
    loginButtonLabel = UILabel()
    loginButtonLabel?.text =  "Login"
    loginButtonLabel?.textAlignment = .Center
    loginButtonLabel?.textColor = .whiteColor()
    loginButtonLabel?.font = .asapRegular(12)
    loginButton?.customContentView.addSubview(loginButtonLabel!)
    
    containerView?.addSubview(loginButton!)
  }
  
  private func setupOrLabel() {
    orLabel = UILabel()
    orLabel?.text =  "Or"
    orLabel?.textAlignment = .Center
    orLabel?.textColor = .sexyGray()
    orLabel?.font = .asapRegular(12)
    containerView?.addSubview(orLabel!)
  }
  
  public func loginButtonPressed() {
    log.debug("mark")
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
        passwordField?.resignFirstResponder()
        emailField?.resignFirstResponder()
    }
    
  
  public override func prefersStatusBarHidden() -> Bool {
    return true
  }
}
