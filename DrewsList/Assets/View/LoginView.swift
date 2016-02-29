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
import FBSDKLoginKit

public class LoginView: UIViewController, UITextFieldDelegate, FBSDKLoginButtonDelegate {
  
  // good job specifying all the function and variable class scopes!
  
  private let controller = LoginController()
  private var model: LoginModel { get { return controller.model } }
  
  //MARK: Outlets for UI Elements.
  private var activityView: UIActivityIndicatorView?
  private var backgroundImage: UIImageView?
  private var containerView: UIView?
  private var drewslistLogo: UIImageView?
  private var emailField:      HoshiTextField?
  private var passwordField:   HoshiTextField?
  private var loginButton:     SwiftyCustomContentButton?          //UIButton?
  private var loginButtonIndicator: UIActivityIndicatorView?
  private var loginButtonLabel: UILabel?
  private var orLabel: UILabel?
  private var fbLoginButton: FBSDKLoginButton?
  private var optionsContrainer: UIView?
  private var signUpOption: UIButton?
  private var forgotPasswordOption: UIButton?
  
//  private var idx: Int = 0
//  private let backGroundArray = [UIImage(named: "img1-1.png"),UIImage(named:"book6.png"), UIImage(named: "book7.png")]

  // MARK: View Controller LifeCycle
  
  public override func viewDidLoad() {
      super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupBackgroundImage()
    setupContainerView()
    hideUI()
    setupDrewslistLogo()
    setupPasswordLabel()
    setupEmailLabel()
    setupLoginButton()
    setupOrLabel()
    setupFBLoginButton()
    setupOptions()
    
    view.showLoadingScreen(0, bgOffset: 64)
    
    activityView?.anchorInCorner(.TopRight, xPad: 8, yPad: 8, width: 24, height: 24)
    
    backgroundImage?.fillSuperview()
    backgroundImage?.image = Toucan(image: UIImage(named: "background-image2")).resize(backgroundImage?.frame.size, fitMode: .Clip).image
    
    containerView?.fillSuperview(left: 40, right: 40, top: 128, bottom: 128)
    
    drewslistLogo?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: containerView!.frame.width * 0.11)
    
    emailField?.alignAndFillWidth(align: .UnderCentered, relativeTo: drewslistLogo!, padding: 0, height: 48)
    passwordField?.alignAndFillWidth(align: .UnderCentered, relativeTo: emailField!, padding: 0, height: 48)
    
    loginButton?.align(.UnderCentered, relativeTo: passwordField!, padding: 30, width: passwordField!.frame.width, height: 36)
    loginButtonIndicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
    loginButtonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
    
    orLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: loginButton!, padding: 12, height: 24)
    
    fbLoginButton?.align(.UnderCentered, relativeTo: orLabel!, padding: 18, width: passwordField!.frame.width, height: 36)
    
    optionsContrainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: fbLoginButton!, padding: 0, height: 48)
    signUpOption?.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: 60)
    forgotPasswordOption?.alignAndFill(align: .ToTheRightCentered, relativeTo: signUpOption!, padding: 0)
    
    FBSDKController().createCustomEventForName("UserLogin")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
   
    // Google Analytics
    let name = "LoginView" // Get view name
    
    // [START screen_view_hit_swift]
    let tracker = GAI.sharedInstance().defaultTracker
    tracker.set(kGAIScreenName, value: name)
    
    let builder = GAIDictionaryBuilder.createScreenView()
    tracker.send(builder.build() as [NSObject : AnyObject])
    // [END screen_view_hit_swift]
    
    checkIfUserHasSeenOnboardingView()
    
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
    model._isValidEmail.removeAllListeners()
    model._isValidEmail.listen(self) { [weak self] bool in
      if bool != true { self?.loginButtonLabel?.text = "Email does not exist!" }
      NSTimer.after(3.0) { [weak self] in self?.loginButtonLabel?.text = "Login" }
    }
    model._isValidPassword.removeAllListeners()
    model._isValidPassword.listen(self) { [weak self] bool in
      if bool != true { self?.loginButtonLabel?.text = "Password does not match!" }
      NSTimer.after(3.0) { [weak self] in self?.loginButtonLabel?.text = "Login" }
    }
    model._serverError.removeAllListeners()
    model._serverError.listen(self) { [weak self] bool in
      if bool == true { self?.loginButtonLabel?.text = "Server Error. Sorry." }
      NSTimer.after(3.0) { [weak self] in self?.loginButtonLabel?.text = "Login" }
    }
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
      if bool != true { self?.loginButtonIndicator?.stopAnimating() }
      else { self?.loginButtonIndicator?.startAnimating() }
    }
    controller.shouldDismissView.removeAllListeners()
    controller.shouldDismissView.listen(self) { [weak self] user in
      self?.dismissKeyboard()
      if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView {
        tabView.selectedIndex = 0
        tabView.dismissViewControllerAnimated(true, completion: nil)
      }
    }
    controller.shouldPresentPhoneInputView.removeAllListeners()
    controller.shouldPresentPhoneInputView.listen(self) { [weak self] bool in
      self?.presentPhoneNumberInputView()
    }
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
    passwordField?.delegate = self
    passwordField?.secureTextEntry = true
    passwordField?.font = .asapRegular(16)
    passwordField?.spellCheckingType = .No
    passwordField?.autocorrectionType = .No
    passwordField?.textColor = .whiteColor()
    passwordField?.clearButtonMode = .WhileEditing
    passwordField?.tag = 5
    
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
    loginButton?.addSubview(loginButtonIndicator!)
    
    loginButtonLabel = UILabel()
    loginButtonLabel?.text =  "Login"
    loginButtonLabel?.textAlignment = .Center
    loginButtonLabel?.textColor = .whiteColor()
    loginButtonLabel?.font = .asapRegular(12)
    loginButton?.addSubview(loginButtonLabel!)
    
    containerView?.addSubview(loginButton!)
  }
  
  private func setupFBLoginButton() {
    fbLoginButton = FBSDKLoginButton()
    fbLoginButton?.delegate = self
    fbLoginButton?.readPermissions = ["public_profile","email","user_friends"]
    containerView?.addSubview(fbLoginButton!)
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
    signUpOption?.setTitle("Sign-Up", forState: .Normal)
    signUpOption?.contentHorizontalAlignment = .Right
    signUpOption?.addTarget(self, action: "signupButtonPressed", forControlEvents: .TouchUpInside)
    optionsContrainer?.addSubview(signUpOption!)
    
    forgotPasswordOption = UIButton()
    forgotPasswordOption?.titleLabel?.font = .asapRegular(10)
    forgotPasswordOption?.setTitleColor(.whiteColor(), forState: .Normal)
    forgotPasswordOption?.setTitle("|\tForgot Password?", forState: .Normal)
    forgotPasswordOption?.contentHorizontalAlignment = .Center
    optionsContrainer?.addSubview(forgotPasswordOption!)
  }

  public func loginButtonPressed() {
    dismissKeyboard()
    controller.loginUserToServer()
    FBSDKController().createCustomEventForName("Login_LoginButtonPressed")
  }
  
  public func signupButtonPressed() {
    activityView?.startAnimating()
    hideUI { [weak self] bool in
      self?.containerView?.hidden = true
      self?.presentViewController(SignUpView(), animated: false) { [weak self] in
        self?.activityView?.stopAnimating()
      }
    }
  }
  
  public override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  public func checkIfUserHasSeenOnboardingView() {
    if let userDefaults = try! Realm().objects(UserDefaults.self).first {
      if !userDefaults.didShowOnboarding {
        presentViewController(OnboardingView(), animated: true) { [weak self] in
          self?.view.hideLoadingScreen()
        }
      } else {
        view.hideLoadingScreen()
      }
    }
    NSTimer.after(1.0) { [weak self] in self?.view.hideLoadingScreen() }
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
  
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        var _string: String? = NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1))
        switch textField.tag {
          // email
        case 4:
          model.email = _string
          break
          // password
        case 5:
          model.password = _string
          break
        default: break
        }
        _string = nil
        // else, user has inputted some new strings
      } else {
        var _string: String? = text + string
        switch textField.tag {
          // email
        case 4:
          model.email = _string
          break
          // password
        case 5:
          model.password = _string
          break
        default: break
        }
        _string = nil
      }
    }
    return true
  }
  
  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    switch textField.tag {
    case 4:
      passwordField?.becomeFirstResponder()
      break
      // password
    case 5:
      loginButtonPressed()
      break
    default: break
    }
    return false
  }
  
  // MARK: Delegates
  public func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    
    // show the user there was an error if the fbsdk login did not succeed
    if let error = error {
      log.error(error)
      
    // else, if the login was cancelled show the user as well that the fbsdk login did not succeed
    } else if result.isCancelled {
      
      // Handle cancellations
      log.debug("FB login has been cancelled")
      
    // else, the user has successfully logged in
    } else {
      
      controller.getUserAttributesFromFacebook()
      
      log.info("User is logged in")
      
      // disallow the user from clicking the facebook button 
      // until the authentication process has been resolved
      fbLoginButton?.userInteractionEnabled = false
    }
  }
  
  public func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    log.info("User Logged Out")
  }
  
  public func presentPhoneNumberInputView() {
    let alertController = UIAlertController(title: "Call Me Maybe?", message: "Please input your phone number, this will help other users get in touch with you much quicker.", preferredStyle: .Alert)
    alertController.addTextFieldWithConfigurationHandler() { textField in
      textField.font = .asapRegular(16)
      textField.textColor = .blackColor()
      textField.spellCheckingType = .No
      textField.autocorrectionType = .No
      textField.autocapitalizationType = .None
      textField.clearButtonMode = .WhileEditing
      textField.keyboardType = .PhonePad
    }
    alertController.addAction(UIAlertAction(title: "Done", style: .Default) { [weak self, weak alertController] action in
      if let phoneNumber = alertController?.textFields?.first?.text where phoneNumber.isValidPhoneNumber() == true {
        self?.model.phone = phoneNumber
        self?.controller.authenticateUserToServer(false)
      } else {
        self?.logUserOutOfFacebook()
        self?.dismissKeyboard()
        let alertController2 = UIAlertController(title: "Sorry", message: "The number you entered didn't seem to be a valid phone number.", preferredStyle: .Alert)
          alertController2.addAction(UIAlertAction(title: "Ok", style: .Cancel) { [weak self] action in
        })
        self?.presentViewController(alertController2, animated: true, completion: nil)
      }
    })
    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { [weak self] action in
    })
    presentViewController(alertController, animated: true, completion: nil)
  }
  
  public func logUserOutOfFacebook() {
    // if theres an error, log the user out
    FBSDKLoginManager().logOut()
    // disallow the user from clicking the facebook button
    // until the authentication process has been resolved
    fbLoginButton?.userInteractionEnabled = true
  }
}


