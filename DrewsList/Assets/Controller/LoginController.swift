//
//  ViewController.swift
//  Swifty
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 Flowers Designs. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import SwiftyJSON
import Signals
import FBSDKLoginKit

public class LoginController {
  
  // MARK: Singleton
  
  private struct Singleton { static let loginController = LoginController() }
  public class func sharedInstance() -> LoginController { return Singleton.loginController }
  
  public let model = LoginModel()
  
  private let userController = UserController()
  private let fbsdkController = FBSDKController()
  
  public let shouldPresentPhoneInputView = Signal<Bool>()
  public let shouldPresentSchoolInputView = Signal<()>()
  public var shouldPresentReferralInputView: (() -> Void)?
  public var shouldDismissView: ((title: String?, message: String?) -> Void)?
  
  private var refrainTimer: NSTimer?
  
  public init() {
    setupDataBinding()
  }
  
  private func setupDataBinding() {
    model._shouldLogout.removeAllListeners()
    model._shouldLogout.listen(self) { [weak self] shouldLogout in
      if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView where shouldLogout {
        tabView.presentViewController(OnboardingView(), animated: false, completion: nil)
      }
    }
  }
  
  public func checkIfUserIsLoggedIn() -> Bool {
    // check if user is already logged in
    if let user = try! Realm().objects(RealmUser.self).first?.getUser() where user._id != nil {
      
      log.debug("user is logged in\(user.getName() != nil ? ": \(user.getName()!)" : "")")
    
      // set the user's model
      model.user = user
      
      getUserFromServer()
      
      // dismiss the view
      shouldDismissView?(title: nil, message: nil)
      
    // check if user is logged into facebook
    } else if fbsdkController.userIsLoggedIntoFacebook() {
      
      log.debug("user is logged in facebook")
      
      FBSDKController.getUser()
      
    // if we already have a user, attempt to call the server to update the current user
    // if not show login view
    } else if let tabView = UIApplication.sharedApplication().keyWindow?.rootViewController as? TabView {
      
      log.debug("user is not logged in")
      
      tabView.presentViewController(OnboardingView(), animated: false) { bool in
        // else, log use out of facebook
        FBSDKLoginManager().logOut()
      }
    }
    
    return false
  }
  
  public func getUserFromServer() {
    if let user = UserModel.sharedUser().user, let user_id = user._id {
      DLHTTP.GET("/user?_id=\(user_id)") { [weak self] (json, error) in
        if let json = json {
          if json["error"].isExists() {
            log.warning(json)
            LoginController.logOut()
          } else {
            log.info(json)
            self?.model.user = User(json: json)
            UserModel.setSharedUser(User(json: json))
          }
        }
      }
    }
  }
  
  public func getUserAttributesFromFacebook() {
    fbsdkController.getUserAttributesFromFacebook()
  }
  
  public class func logOut() {
    // remove all shared models
    SearchSchoolController.clearCache()
    // deletes the current user, then will log user out.
    UserModel.unsetSharedUser()
    // log out of facebook if they are logged in
    FBSDKController.logout()
    // since the current user does not exist anymore
    // we ask the tab view to check any current user, since we have no current user
    // it will present the login screen
    LoginController.sharedInstance().checkIfUserIsLoggedIn()
  }
  
  public class func authenticateUserToServer(user: User?, completionHandler: (User? -> Void)? = nil) {
    if let user = user {
      
      log.debug("authenticating user...")
      
      let email: String = user.email ?? ""
      let school: String = user.school ?? ""
      let state: String = user.state ?? ""
      
      // NOTE: password is not given by facebook
      // facebook attributes
      let facebook_id: String = user.facebook_id ?? ""
      let facebook_link: String = user.facebook_link ?? ""
      let facebook_update_time: String = user.facebook_update_time ?? ""
      let facebook_verified: String = user.facebook_verified ?? ""
      let facebook_image: String = user.imageUrl ?? ""
      let gender: String = user.gender ?? ""
      let age_min: String = user.age_min ?? ""
      let age_max: String = user.age_max ?? ""
      let locale: String = user.locale ?? ""
      let image: String = user.imageUrl ?? ""
      let bgImage: String = user.bgImage ?? ""
      let timezone: String = user.timezone ?? ""
      let firstName: String = user.firstName ?? ""
      let lastName: String = user.lastName ?? ""
      
      // user settings
      let deviceToken: String = user.deviceToken ?? ""
      let hasSeenTermsAndPrivacy: Bool = user.hasSeenTermsAndPrivacy ?? false
      let hasSeenOnboardingView: Bool = user.hasSeenOnboardingView ?? false
      let currentUUID: String = NSUUID().UUIDString
      
      var friends = [[String: AnyObject]]()
      
      for friend in user.friends {
        let friend_facebook_id: String = friend.facebook_id ?? ""
        let friend_firstName: String = friend.firstName ?? ""
        let friend_lastName: String = friend.lastName ?? ""
        friends.append([
          "facebook_id": friend_facebook_id,
          "firstName": friend_firstName,
          "lastName": friend_lastName
          ] as [String: AnyObject ])
      }
      
      // referral system
      let referralCode: String = user.referralCode ?? ""
      
      DLHTTP.POST("/user/authenticateUser", parameters: [
        "email": email,
        "school": school,
        "state": state,
        // NOTE: password is not given by facebook
        // facebook attributes
        "facebook_id": facebook_id,
        "facebook_link": facebook_link,
        "facebook_update_time": facebook_update_time,
        "facebook_verified": facebook_verified,
        "facebook_image": facebook_image,
        "gender": gender,
        "age_min": age_min,
        "age_max": age_max,
        "locale": locale,
        "image": image,
        "bgImage": bgImage,
        "timezone": timezone,
        "firstName": firstName,
        "lastName": lastName,
        "friends": friends,
        "localAuth": false,
        // user setings
        "deviceToken": deviceToken,
        "hasSeenTermsAndPrivacy": hasSeenTermsAndPrivacy,
        "hasSeenOnboardingView": hasSeenOnboardingView,
        "currentUUID": currentUUID,
        // referral system
        "referralCode": referralCode,
      ]) { (json, error) in
        if let json = json {
          log.debug("user authenticated.")
          UserController.setSharedUser(User(json: json))
          Sockets.sharedInstance().setOnlineStatus(true)
          completionHandler?(User(json: json))
        } else {
          completionHandler?(nil)
        }
      }
    } else {
      completionHandler?(nil)
    }
  }
}











