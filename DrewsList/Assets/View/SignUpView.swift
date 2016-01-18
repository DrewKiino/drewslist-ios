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
import Async
import Signals

public class SignUpView: UIViewController, UITextFieldDelegate {
  
  // good job specifying all the function and variable class scopes!
  
  private let controller = SignUpController()
  private var model: SignUpModel { get { return controller.model } }
  
  //MARK: Outlets for UI Elements.
  private var scrollView: UIScrollView?
  private var activityView: UIActivityIndicatorView?
  private var backgroundImage: UIImageView?
  private var containerView: UIView?
  private var drewslistLogo: UIImageView?
  private var firstNameField: HoshiTextField?
  private var lastNameField: HoshiTextField?
  private var emailField:      HoshiTextField?
  private var passwordField:   HoshiTextField?
  private var rePasswordField: HoshiTextField?
  private var schoolTextField: HoshiTextField?
  private var signupButton:     SwiftyCustomContentButton?          //UIButton?
  private var signupButtonIndicator: UIActivityIndicatorView?
  private var signupButtonLabel: UILabel?
  private var optionsContrainer: UIView?
  private var loginOption: UIButton?
  
  // MARK: View Controller LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupBackgroundImage()
    setupScrollView()
    setupContainerView()
    hideUI()
    setupDrewslistLogo()
    setupNameFields()
    setupEmailLabel()
    setupPasswordLabel()
    setupSchoolTextField()
    setupSignupButton()
    setupOptions()
    resetSchoolInput()
    
    activityView?.anchorInCorner(.TopRight, xPad: 8, yPad: 8, width: 24, height: 24)
    
    backgroundImage?.fillSuperview()
    backgroundImage?.image = Toucan(image: UIImage(named: "background-image2")).resize(backgroundImage?.frame.size, fitMode: .Clip).image
    
    scrollView?.fillSuperview()
    scrollView?.contentSize = CGSizeMake(screen.width, screen.height + 200)
    
    containerView?.fillSuperview(left: 40, right: 40, top: 32, bottom: 40)
    
    drewslistLogo?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: containerView!.frame.width * 0.11)
    drewslistLogo?.image = Toucan(image: UIImage(named: "DrewsListLogo_Login-1")).resize(drewslistLogo?.frame.size).image
    
    firstNameField?.alignAndFillWidth(align: .UnderCentered, relativeTo: drewslistLogo!, padding: 0, height: 48)
    lastNameField?.alignAndFillWidth(align: .UnderCentered, relativeTo: firstNameField!, padding: 0, height: 48)
    emailField?.alignAndFillWidth(align: .UnderCentered, relativeTo: lastNameField!, padding: 0, height: 48)
    passwordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: emailField!, padding: 0, height: 48)
    rePasswordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: passwordField!, padding: 0, height: 48)
    schoolTextField?.alignAndFillWidth(align: .UnderCentered, relativeTo: rePasswordField!, padding: 0, height: 48)
    
    signupButton?.align(.UnderCentered, relativeTo: schoolTextField!, padding: 32, width: passwordField!.frame.width, height: 36)
    signupButtonIndicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
    signupButtonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
    
    optionsContrainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: signupButton!, padding: 0, height: 48)
    loginOption?.fillSuperview()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    resignFirstResponder()
    setSchool()
    
    if drewslistLogo?.image == nil {
      Async.background { [weak self] in
        var toucan: Toucan? = Toucan(image: UIImage(named: "DrewsListLogo_Login-1")).resize(self?.drewslistLogo?.frame.size)
        Async.main { [weak self] in
          self?.drewslistLogo?.image = toucan?.image
          toucan = nil
        }
      }
    }
    showUI()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "dismissKeyboard"))
    
    activityView = UIActivityIndicatorView(activityIndicatorStyle: .White)
    activityView?.layer.zPosition = 3
    view.addSubview(activityView!)
  }
  
  private func setupDataBinding() {
    model._isValidFirstName.removeAllListeners()
    model._isValidFirstName.listen(self) { [weak self] bool in
      if bool != true { self?.firstNameField?.placeholder = "First name can only contain letters or -" }
      else { self?.firstNameField?.placeholder = "First Name" }
    }
    model._isValidLastName.removeAllListeners()
    model._isValidLastName.listen(self) { [weak self] bool in
      if bool != true { self?.lastNameField?.placeholder = "Last name can only contain letters or -" }
      else { self?.lastNameField?.placeholder = "Last Name" }
    }
    model._school.removeAllListeners()
    model._school.listen(self) { [weak self] string in
      self?.schoolTextField?.text = string
    }
    model._isValidEmail.removeAllListeners()
    model._isValidEmail.listen(self) { [weak self] bool in
      if bool != true { self?.emailField?.placeholder = "Must be a valid email" }
      else { self?.emailField?.placeholder = "Email" }
    }
    model._isValidPassword.removeAllListeners()
    model._isValidPassword.listen(self) { [weak self] bool in
      if bool != true { self?.passwordField?.placeholder = "Password, at least 6 characters and 1 number" }
      else { self?.passwordField?.placeholder = "Password" }
    }
    model._isValidRepassword.removeAllListeners()
    model._isValidRepassword.listen(self) { [weak self] bool in
      if bool != true { self?.rePasswordField?.placeholder = "Passwords must match" }
      else { self?.rePasswordField?.placeholder = "Retype Password" }
    }
    model._isValidSchool.removeAllListeners()
    model._isValidSchool.listen(self) { [weak self] bool in
      if bool != true { self?.schoolTextField?.placeholder = "Must input school" }
      else { self?.schoolTextField?.placeholder = "School" }
    }
    model._isValidForm.removeAllListeners()
    model._isValidForm.listen(self) { [weak self] bool in
      if bool == true { self?.controller.createNewUserInServer() }
    }
    model._serverError.removeAllListeners()
    model._serverError.listen(self) { [weak self] bool in
      if bool == true { self?.signupButtonLabel?.text = "Email already exists" }
      NSTimer.after(3.0) { [weak self] in self?.signupButtonLabel?.text = "Signup" }
    }
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
      if bool != true { self?.signupButtonIndicator?.stopAnimating() }
      else { self?.signupButtonIndicator?.startAnimating() }
    }
    
    model._user.removeAllListeners()
    model._user.listen(self) { user in
      if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView { tabView.dismissViewControllerAnimated(true, completion: nil) }
    }
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
  
  private func setupNameFields() {
    firstNameField = HoshiTextField()
    firstNameField?.borderInactiveColor = .bareBlue()
    firstNameField?.borderActiveColor = .juicyOrange()
    firstNameField?.placeholderColor = .whiteColor()
    firstNameField?.placeholderLabel.font = .asapRegular(12)
    firstNameField?.placeholder = "First Name"
    firstNameField?.delegate = self
    firstNameField?.font = .asapRegular(16)
    firstNameField?.textColor = .whiteColor()
    firstNameField?.spellCheckingType = .No
    firstNameField?.autocorrectionType = .No
    firstNameField?.autocapitalizationType = .Words
    firstNameField?.clearButtonMode = .WhileEditing
    firstNameField?.tag = 2
    
    containerView?.addSubview(firstNameField!)
    
    lastNameField = HoshiTextField()
    lastNameField?.borderInactiveColor = .bareBlue()
    lastNameField?.borderActiveColor = .juicyOrange()
    lastNameField?.placeholderColor = .whiteColor()
    lastNameField?.placeholderLabel.font = .asapRegular(12)
    lastNameField?.placeholder = "Last Name"
    lastNameField?.delegate = self
    lastNameField?.font = .asapRegular(16)
    lastNameField?.textColor = .whiteColor()
    lastNameField?.spellCheckingType = .No
    lastNameField?.autocorrectionType = .No
    lastNameField?.autocapitalizationType = .Words
    lastNameField?.clearButtonMode = .WhileEditing
    lastNameField?.tag = 3
    
    containerView?.addSubview(lastNameField!)
  }
  
  public func dismissKeyboard() {
    firstNameField?.resignFirstResponder()
    lastNameField?.resignFirstResponder()
    emailField?.resignFirstResponder()
    passwordField?.resignFirstResponder()
    rePasswordField?.resignFirstResponder()
    schoolTextField?.resignFirstResponder()
  }
  
  public func setupEmailLabel() {
    emailField = HoshiTextField()
    emailField?.borderInactiveColor = .bareBlue()
    emailField?.borderActiveColor = .juicyOrange()
    emailField?.placeholderColor = .whiteColor()
    emailField?.placeholderLabel.font = .asapRegular(12)
    emailField?.placeholder = "Email"
    emailField?.delegate = self
    emailField?.font = .asapRegular(16)
    emailField?.textColor = .whiteColor()
    emailField?.spellCheckingType = .No
    emailField?.autocorrectionType = .No
    emailField?.autocapitalizationType = .None
    emailField?.clearButtonMode = .WhileEditing
    emailField?.tag = 4
    
    containerView?.addSubview(emailField!)
  }
  
  public func setupPasswordLabel() {
    passwordField = HoshiTextField()
    passwordField?.borderInactiveColor = .bareBlue()
    passwordField?.borderActiveColor = .juicyOrange()
    passwordField?.placeholderColor = .whiteColor()
    passwordField?.placeholder = "Password"
    passwordField?.placeholderLabel.font = .asapRegular(12)
    passwordField?.delegate = self
    passwordField?.secureTextEntry = true
    passwordField?.font = .asapRegular(16)
    passwordField?.spellCheckingType = .No
    passwordField?.autocorrectionType = .No
    passwordField?.textColor = .whiteColor()
    passwordField?.clearButtonMode = .WhileEditing
    passwordField?.tag = 5
    
    containerView?.addSubview(passwordField!)
    
    rePasswordField = HoshiTextField()
    rePasswordField?.borderInactiveColor = .bareBlue()
    rePasswordField?.borderActiveColor = .juicyOrange()
    rePasswordField?.placeholderColor = .whiteColor()
    rePasswordField?.placeholder = "Retype Password"
    rePasswordField?.placeholderLabel.font = .asapRegular(12)
    rePasswordField?.delegate = self
    rePasswordField?.secureTextEntry = true
    rePasswordField?.font = .asapRegular(16)
    rePasswordField?.spellCheckingType = .No
    rePasswordField?.autocorrectionType = .No
    rePasswordField?.textColor = .whiteColor()
    rePasswordField?.tag = 6
    rePasswordField?.clearButtonMode = .WhileEditing
    
    containerView?.addSubview(rePasswordField!)
  }
  
  private func setupSchoolTextField() {
    schoolTextField = HoshiTextField()
    schoolTextField?.borderInactiveColor = .bareBlue()
    schoolTextField?.borderActiveColor = .juicyOrange()
    schoolTextField?.placeholderLabel.font = .asapRegular(12)
    schoolTextField?.placeholderColor = .whiteColor()
    schoolTextField?.placeholder = "School"
    schoolTextField?.delegate = self
    schoolTextField?.font = .asapRegular(16)
    schoolTextField?.spellCheckingType = .No
    schoolTextField?.autocorrectionType = .No
    schoolTextField?.textColor = .whiteColor()
    schoolTextField?.tag = 7
    schoolTextField?.clearButtonMode = .WhileEditing
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
    signupButton?.addSubview(signupButtonIndicator!)
    
    signupButtonLabel = UILabel()
    signupButtonLabel?.text =  "Sign up"
    signupButtonLabel?.textAlignment = .Center
    signupButtonLabel?.textColor = .whiteColor()
    signupButtonLabel?.font = .asapRegular(12)
    signupButton?.addSubview(signupButtonLabel!)
    
    containerView?.addSubview(signupButton!)
  }
  
  private func setupOptions() {
    optionsContrainer = UIView()
    containerView?.addSubview(optionsContrainer!)
    
    loginOption = UIButton()
    loginOption?.titleLabel?.font = .asapRegular(10)
    loginOption?.setTitleColor(.whiteColor(), forState: .Normal)
    loginOption?.setTitle("Login", forState: .Normal)
    loginOption?.contentHorizontalAlignment = .Center
    loginOption?.addTarget(self, action: "loginButtonPressed", forControlEvents: .TouchUpInside)
    optionsContrainer?.addSubview(loginOption!)
  }
  
  public func signupButtonPressed() {
    dismissKeyboard()
    controller.validateInputs()
  }
  
  public func loginButtonPressed() {
    activityView?.startAnimating()
    hideUI { [weak self] bool in
      self?.containerView?.hidden = true
      NSTimer.after(0.1) { [weak self] in
        self?.activityView?.stopAnimating()
        self?.presentingViewController?.dismissViewControllerAnimated(false, completion: nil)
      }
    }
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
    controller.resetSchoolInput()
  }
  
  public func setSchool() {
    controller.setSchool()
  }
  
  public func hideUI() {
    containerView?.hidden = true
    containerView?.alpha = 0.0
  }
  
  public func hideUI(callback: Bool -> Void) {
    UIView.animateWithDuration(0.2, animations: { [weak self] in
      self?.containerView?.alpha = 0.0
    }, completion: callback)
  }
  
  public func showUI() {
    containerView?.hidden = false
    UIView.animateWithDuration(0.2, animations: { [weak self] in
      self?.containerView?.alpha = 1.0
    })
  }
  
  // MARK: TextView Delegates 
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    switch textField.tag {
    case 4...6:
      scrollView?.setContentOffset(CGPointMake(0, 110), animated: true)
      break
    case 7:
      textField.resignFirstResponder()
      searchSchools()
      break
    default:
      break
    }
  }
  
  public func textFieldDidEndEditing(textField: UITextField) {
    scrollView?.setContentOffset(CGPointMake(0, 0), animated: true)
  }
  
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        var _string: String? = NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1))
        switch textField.tag {
          // firstName
        case 2:
          model.firstName = _string
          break
          // lastName
        case 3:
          model.lastName = _string
          break
          // email
        case 4:
          model.email = _string
          break
          // password
        case 5:
          model.password = _string
          // repassword
        case 6:
          model.repassword = _string
        default: break
        }
        _string = nil
        // else, user has inputted some new strings
      } else {
        var _string: String? = text + string
        switch textField.tag {
          // firstName
        case 2:
          model.firstName = _string
          break
          // lastName
        case 3:
          model.lastName = _string
          break
          // email
        case 4:
          model.email = _string
          break
          // password
        case 5:
          model.password = _string
          // repassword
        case 6:
          model.repassword = _string
        default: break
        }
        _string = nil
      }
    }
    return true
  }
  
  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
      // firstName
    case 2:
      lastNameField?.becomeFirstResponder()
      break
      // lastName
    case 3:
      emailField?.becomeFirstResponder()
      break
      // email
    case 4:
      passwordField?.becomeFirstResponder()
      break
      // password
    case 5:
      rePasswordField?.becomeFirstResponder()
      // repassword
    case 6:
      schoolTextField?.becomeFirstResponder()
    default: break
    }
    return false
  }
}