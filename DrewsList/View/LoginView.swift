//
//  ViewController.swift
//  Swifty
//
///  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///


import UIKit
import QuartzCore





public class ViewController: UIViewController, UITextFieldDelegate {
    
    //MARK: Outlets for UI Elements.
    @IBOutlet weak var usernameField:   UITextField!
    @IBOutlet weak var imageView:       UIImageView!
    @IBOutlet weak var passwordField:   UITextField!
    @IBOutlet weak var loginButton:     UIButton!
    @IBOutlet weak var emailField: UITextField!
  


  

    //MARK: Global Variables for Changing Image Functionality.
    private var idx: Int = 0
    private let backGroundArray = [UIImage(named: "img1-1.png"),UIImage(named:"book6.png"), UIImage(named: "book7.png")]
  


  public func setupUsernameLabel() {
    usernameField.alpha = 0;
    usernameField.tag = 1
    usernameField.delegate = self
  }
  
  public func setupPasswordLabel() {
    passwordField.alpha = 0;
    passwordField.tag = 2
    passwordField.delegate = self
  }
  
  public func setupEmailLabel() {
    emailField.alpha    = 0;
    emailField.tag = 3
//    emailField.delegate = self
  }
  

    //MARK: View Controller LifeCycle
  public override func viewDidLoad() {
      super.viewDidLoad()
    
    setupUsernameLabel()
    setupPasswordLabel()
    setupEmailLabel()
    
      loginButton.alpha   = 0;
    
      UIView.animateWithDuration(0.7, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
          self.usernameField.alpha = 1.0
          self.emailField.alpha = 1.0
          self.passwordField.alpha = 1.0
          self.loginButton.alpha   = 0.9
          }, completion: nil)
      
      // Notifiying for Changes in the textFields
//        usernameField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
//        passwordField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
//        emailField.addTarget(self, action: "textFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
    
    
    
      
      // Visual Effect View for background
      let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: UIBlurEffectStyle.Dark)) as UIVisualEffectView
      visualEffectView.frame = self.view.frame
      visualEffectView.alpha = 0.5
      imageView.image = UIImage(named: "img1-1.png")
      imageView.addSubview(visualEffectView)
      
      
      NSTimer.scheduledTimerWithTimeInterval(6, target: self, selector: "changeImage", userInfo: nil, repeats: true)
      self.loginButton(false)
      
    }
  
    
    public func loginButton(enabled: Bool) -> () {
        func enable(){
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {
                self.loginButton.backgroundColor = UIColor.colorWithHex("#F9C676", alpha: 1)
                }, completion: nil)
            loginButton.enabled = true
        }
        func disable(){
            loginButton.enabled = false
            UIView.animateWithDuration(0.3, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {
                self.loginButton.backgroundColor = UIColor.colorWithHex("#F08B23",alpha :1)
                }, completion: nil)
        }
        return enabled ? enable() : disable()
    }
    
    public func changeImage(){
        if idx == backGroundArray.count-1{
            idx = 0
        }
        else{
            idx++
        }
        let toImage = backGroundArray[idx];
        UIView.transitionWithView(self.imageView, duration: 3, options: .TransitionCrossDissolve, animations: {self.imageView.image = toImage}, completion: nil)
        
    }
    
    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
  
    @IBAction func buttonPressed(sender: AnyObject) {
//        self.performSegueWithIdentifier("login", sender: self)
    }
    
    @IBAction func signupPressed(sender: AnyObject) {
    }
    
    
    @IBAction func backgroundPressed(sender: AnyObject) {
        usernameField.resignFirstResponder()
        passwordField.resignFirstResponder()
        emailField.resignFirstResponder()
      
        
    }
    
    
}

//Extension for Color to take Hex Values
extension UIColor{
    
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





