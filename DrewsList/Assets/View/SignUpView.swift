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

import SwiftyButton


public class SignUpView: UIViewController, UITextFieldDelegate {
  
  // good job specifying all the function and variable class scopes!
  
  private let controller = SignUpController()
  private var model: SignUpModel{ get { return controller.model } }
  

  //MARK: Outlets for UI Elements.
  private let backgroundImage = UIImageView()
  private let containerView = UIView()
  private var SignedUpButton: SwiftyButton?
  var firstname:   HoshiTextField?
  var emailField:  HoshiTextField?
  var lastname:   HoshiTextField?
  var password: HoshiTextField?
  var signedUpButton:  SwiftyButton?  //UIButton?

  

  
  // the mark tag's syntax looks like this:
  //
  //    '// MARK: .....'
  //
  //   
  // MARK: View Controller LifeCycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupBackgroundImage()
    setupContainerView()
    setupfirstnameLabel()
    setuplastnameLabel()
    setupEmailLabel()
    setupPasswordlabel()
    
    
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
    firstname?.resignFirstResponder()
    emailField?.resignFirstResponder()
    lastname?.resignFirstResponder()
    password?.resignFirstResponder()
  }
  
  //MARK: Global Variables for Changing Image Functionality.
  private var idx: Int = 0
  private let backGroundArray = [UIImage(named: "img1-1.png"),UIImage(named:"book6.png"), UIImage(named: "book7.png")]
  
  public func setupfirstnameLabel() {
    //    usernameField.alpha = 0;
    //    usernameField.tag = 1
    //    usernameField.delegate = self
    firstname = HoshiTextField()
    firstname?.borderInactiveColor = UIColor.bareBlue()
    firstname?.borderActiveColor = UIColor.juicyOrange()
    firstname?.placeholderColor = UIColor.sexyGray()
    firstname?.placeholder = "Enter your first name"
    firstname?.delegate = self
    
    containerView.addSubview(firstname!)
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
  
  public func setuplastnameLabel() {
    //    passwordField.alpha = 0;
    //    passwordField.tag = 2
    //    passwordField.delegate = self
    lastname = HoshiTextField()
    lastname?.borderInactiveColor = UIColor.bareBlue()
    lastname?.borderActiveColor = UIColor.juicyOrange()
    lastname?.placeholderColor = UIColor.sexyGray()
    lastname?.placeholder = "Enter your last name"
    lastname?.delegate = self
    
    containerView.addSubview(lastname!)
  }
  
  public func setupPasswordlabel() {
    password = HoshiTextField()
    password?.borderInactiveColor = UIColor.bareBlue()
    password?.borderActiveColor = UIColor.juicyOrange()
    password?.placeholderColor = UIColor.sexyGray()
    password?.placeholder = "Enter a Password"
    password?.delegate = self
    
    containerView.addSubview(password!)
    
    
    
  }
  
  
//  //SignedUpButton???
//  private func SignedUpButton(view: UIView) {
//    SignedUpButton = SwiftyButton()
//    SignedUpButton?.buttonColor = .sexyGray()
//    SignedUpButton?.shadowColor = .juicyOrange()
//    SignedUpButton?.shadowHeight = 3
//    SignedUpButton?.cornerRadius = 3
//    SignedUpButton?.titleLabel?.font = UIFont(name: "HelveticaNeue", size: 12)
//    SignedUpButton?.setTitle("Next", forState: .Normal)
//    SignedUpButton?.frame = CGRectMake(48, screen.height - 124, 100, 24)
//    
//  }
  
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    backgroundImage.fillSuperview()
    backgroundImage.image = Toucan(image: UIImage(named: "DrewsList_WireFrames_iOS-21")!).resize(backgroundImage.frame.size).image
    
    containerView.fillSuperview(left: 40, right: 40, top: 128, bottom: 128)
    
    firstname?.anchorAndFillEdge(.Top, xPad: 0, yPad: 60, otherSize: 48)
    lastname?.alignAndFillWidth(align: .UnderCentered, relativeTo: firstname!, padding: 0, height: 48)
    emailField?.alignAndFillWidth(align: .UnderCentered, relativeTo: lastname!, padding: 0, height: 48)
    password?.alignAndFillWidth(align: .UnderCentered, relativeTo: emailField!, padding: 0, height: 48)
    
    
  
//    //NextButton//SignUpButton
//      next = UIButton(frame: CGRectMake(self.view.bounds.origin.x + (self.view.bounds.width * 0.325), self.view.bounds.origin.y + (self.view.bounds.height * 0.8), self.view.bounds.origin.x + (self.view.bounds.width * 0.35), self.view.bounds.origin.y + (self.view.bounds.height * 0.05)))
//      next?.layer.cornerRadius = 3.0
//      next?.layer.borderWidth = 2.0
//      next?.backgroundColor = UIColor.juicyOrange()
//      next?.layer.borderColor = UIColor.juicyOrange().CGColor
//      next?.setTitle("Next", forState: UIControlState.Normal)
//      next?.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
//     //add target on this button//
//    
//  
//       self.view.addSubview(next!)
    
    //SetupSwiftySignedUpButton
    signedUpButton = SwiftyButton()
    signedUpButton?.buttonColor = .juicyOrange()
    signedUpButton?.shadowColor = .bareBlue()
    signedUpButton?.shadowHeight = 2
    signedUpButton?.cornerRadius = 2
    signedUpButton?.titleLabel?.font = UIFont(name: "Asap-Bold", size: 18)
    signedUpButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
    signedUpButton?.setTitle("Next", forState: .Normal)
    signedUpButton?.frame = CGRectMake(screen.width / 2 - 100, screen.height - 35 - 35, 200, 45)
    
    view.addSubview(signedUpButton!)
    
    
  }
  
  
  public func signupButtonPressed () {

  }
  
  
  public func changeImage(){
    if idx == backGroundArray.count-1{
      
      idx = 0
      
    } else{
      
      idx++
    }
    
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
  
  
  
  func buttonPressed(sender: AnyObject) {
    //        self.performSegueWithIdentifier("login", sender: self)
  }
  
  func signupPressed(sender: AnyObject) {
  }
  
  
  func backgroundPressed(sender: AnyObject) {
    firstname?.resignFirstResponder()
    lastname?.resignFirstResponder()
    emailField?.resignFirstResponder()
    password?.resignFirstResponder()
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


