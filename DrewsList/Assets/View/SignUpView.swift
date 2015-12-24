//
//  ViewController.swift
//  Swifty
//
///  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///

import Foundation
import UIKit
import TextFieldEffects
import Neon
import SwiftyButton
import RealmSwift

public class SignUpView: UIViewController, UITextFieldDelegate {
  
  // good job specifying all the function and variable class scopes!
  
  private let controller = LoginController()
  private var model: LoginModel { get { return controller.model } }
  
  private var scrollView: UIScrollView?
  
  //MARK: Outlets for UI Elements.
  private var backgroundImage: UIImageView?
  private var containerView: UIView?
  private var drewslistLogo: UIImageView?
  private var emailField:      HoshiTextField?
  private var passwordField:   HoshiTextField?
  private var rePasswordField: HoshiTextField?
  private var schoolTextField: HoshiTextField?
  private var signupButton:     SwiftyCustomContentButton?          //UIButton?
  private var signupButtonIndicator: UIActivityIndicatorView?
  private var signupButtonLabel: UILabel?
  private var orLabel: UILabel?
  private var optionsContrainer: UIView?
  private var signUpOption: UIButton?
  
//  private var idx: Int = 0
//  private let backGroundArray = [UIImage(named: "img1-1.png"),UIImage(named:"book6.png"), UIImage(named: "book7.png")]
  
  // MARK: View Controller LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupBackgroundImage()
    setupScrollView()
    setupContainerView()
    setupDrewslistLogo()
    setupEmailLabel()
    setupPasswordLabel()
    setupSchoolTextField()
    setupSignupButton()
    setupOptions()
    resetSchoolInput()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    resignFirstResponder()
    setSchool()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    
    backgroundImage?.fillSuperview()
    backgroundImage?.image = Toucan(image: UIImage(named: "background-image2")).resize(backgroundImage?.frame.size, fitMode: .Clip).image
    
    scrollView?.fillSuperview()
    scrollView?.contentSize = CGSizeMake(screen.width, screen.height + 200)
    
    containerView?.fillSuperview(left: 40, right: 40, top: 128, bottom: 128)
    
    drewslistLogo?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: containerView!.frame.width * 0.11)
    drewslistLogo?.image = Toucan(image: UIImage(named: "DrewsListLogo_Login-1")).resize(drewslistLogo?.frame.size).image
    
    emailField?.alignAndFillWidth(align: .UnderCentered, relativeTo: drewslistLogo!, padding: 0, height: 48)
    passwordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: emailField!, padding: 0, height: 48)
    rePasswordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: passwordField!, padding: 0, height: 48)
    schoolTextField?.alignAndFillWidth(align: .UnderCentered, relativeTo: rePasswordField!, padding: 0, height: 48)
    
    signupButton?.align(.UnderCentered, relativeTo: schoolTextField!, padding: 32, width: passwordField!.frame.width, height: 36)
    signupButtonIndicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
    signupButtonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
    
    orLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: signupButton!, padding: 0, height: 24)
    
    optionsContrainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: signupButton!, padding: 8, height: 24)
    optionsContrainer?.groupAndFill(group: .Horizontal, views: [signUpOption!], padding: 0)
  }
  
  private func setupSelf() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
  }
  
  private func setupBackgroundImage() {
    backgroundImage = UIImageView()
    view.addSubview(backgroundImage!)
  }
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView?.showsVerticalScrollIndicator = false
    scrollView?.scrollEnabled = false
    view.addSubview(scrollView!)
  }
  
  private func setupContainerView() {
    containerView = UIView()
    scrollView?.addSubview(containerView!)
  }
  
  private func setupDrewslistLogo() {
    drewslistLogo = UIImageView()
    containerView?.addSubview(drewslistLogo!)
  }
  
  public func dismissKeyboard() {
    emailField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    rePasswordField?.resignFirstResponder()
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
    emailField?.spellCheckingType = .No
    emailField?.autocorrectionType = .No
    emailField?.autocapitalizationType = .None
    
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
    passwordField?.spellCheckingType = .No
    passwordField?.autocorrectionType = .No
    passwordField?.textColor = .whiteColor()
    
    containerView?.addSubview(passwordField!)
    
    rePasswordField = HoshiTextField()
    rePasswordField?.borderInactiveColor = .bareBlue()
    rePasswordField?.borderActiveColor = .juicyOrange()
    rePasswordField?.placeholderColor = .whiteColor()
    rePasswordField?.placeholder = "Retype Password"
    rePasswordField?.delegate = self
    rePasswordField?.secureTextEntry = true
    rePasswordField?.font = .asapRegular(16)
    rePasswordField?.spellCheckingType = .No
    rePasswordField?.autocorrectionType = .No
    rePasswordField?.textColor = .whiteColor()
    
    containerView?.addSubview(rePasswordField!)
  }
  
  private func setupSchoolTextField() {
    schoolTextField = HoshiTextField()
    schoolTextField?.borderInactiveColor = .bareBlue()
    schoolTextField?.borderActiveColor = .juicyOrange()
    schoolTextField?.placeholderColor = .whiteColor()
    schoolTextField?.placeholder = "School"
    schoolTextField?.delegate = self
    schoolTextField?.font = .asapRegular(16)
    schoolTextField?.spellCheckingType = .No
    schoolTextField?.autocorrectionType = .No
    schoolTextField?.textColor = .whiteColor()
    schoolTextField?.tag = 5
    containerView?.addSubview(schoolTextField!)
  }
  
  private func setupSignupButton() {
    //SetupSwitfysignupButton
    signupButton = SwiftyCustomContentButton()
    signupButton?.buttonColor         = .juicyOrange()
    signupButton?.highlightedColor    = .darkJuicyOrange()
    signupButton?.shadowColor         = .clearColor()
    signupButton?.disabledButtonColor = .clearColor()
    signupButton?.disabledShadowColor = .clearColor()
    signupButton?.shadowHeight        = 0.0
    signupButton?.cornerRadius        = 0.0
    signupButton?.buttonPressDepth    = 0.0 // In percentage of shadowHeight
    signupButton?.addTarget(self, action: "signupButtonPressed", forControlEvents: .TouchUpInside)
    
    signupButtonIndicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
    signupButton?.customContentView.addSubview(signupButtonIndicator!)
    
    signupButtonLabel = UILabel()
    signupButtonLabel?.text =  "Signup"
    signupButtonLabel?.textAlignment = .Center
    signupButtonLabel?.textColor = .whiteColor()
    signupButtonLabel?.font = .asapRegular(12)
    signupButton?.customContentView.addSubview(signupButtonLabel!)
    
    containerView?.addSubview(signupButton!)
  }
  
  private func setupOrLabel() {
    orLabel = UILabel()
    orLabel?.text =  "Or"
    orLabel?.textAlignment = .Center
    orLabel?.textColor = .sexyGray()
    orLabel?.font = .asapRegular(12)
    containerView?.addSubview(orLabel!)
  }
  
  private func setupOptions() {
    optionsContrainer = UIView()
    containerView?.addSubview(optionsContrainer!)
    
    signUpOption = UIButton()
    signUpOption?.titleLabel?.font = .asapRegular(10)
    signUpOption?.setTitleColor(.whiteColor(), forState: .Normal)
    signUpOption?.setTitle("Login", forState: .Normal)
    signUpOption?.titleLabel?.textAlignment = .Center
    signUpOption?.addTarget(self, action: "loginButtonPressed", forControlEvents: .TouchUpInside)
    optionsContrainer?.addSubview(signUpOption!)
  }
  
  public func loginButtonPressed() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  public override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  public func searchSchools() {
    presentViewController(SearchSchoolView(), animated: true, completion: nil)
  }
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    schoolTextField?.resignFirstResponder()
    return true
  }
  
  public func resetSchoolInput() {
    if let userDefaults = try! Realm().objects(UserDefaults.self).first {
      try! Realm().write { [weak self] in
        userDefaults.school = nil
        self?.schoolTextField?.text = nil
        try! Realm().add(userDefaults, update: true)
      }
    }
  }
  
  public func setSchool() {
    if let userDefaults = try! Realm().objects(UserDefaults.self).first {
      try! Realm().write { [weak self] in
        self?.schoolTextField?.text = userDefaults.school
        try! Realm().add(userDefaults, update: true)
      }
    }
  }
  
  // MARK: TextView Delegates 
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    if textField.tag == 5 {
      textField.resignFirstResponder()
      searchSchools()
    } else {
      scrollView?.setContentOffset(CGPointMake(0, 110), animated: true)
    }
  }
  
  public func textFieldDidEndEditing(textField: UITextField) {
    scrollView?.setContentOffset(CGPointMake(0, 0), animated: true)
  }
}