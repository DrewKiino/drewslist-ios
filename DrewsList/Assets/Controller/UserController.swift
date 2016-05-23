//
//  UserController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import RealmSwift
import Alamofire
import SwiftyJSON

public typealias UserControllerServerResponseBlock = (user: User?) -> Void

public class UserController {
  
  private struct Singleton {
    static let userController = UserController()
  }
  
  public static func sharedInstance() -> UserController { return Singleton.userController }
  public class func setSharedUser(user: User?) { if let user = user { UserModel.setSharedUser(user) } }
  
  private let socket = Sockets.sharedInstance()
  
  public let model = UserModel()
  
  public class func sharedUser() -> (_user: Signal<User?>, user: User?) { return UserModel.sharedUser() }
  
  // MARK: Realm Functions
  func readRealmUser() -> RealmUser? { if let realmUser =  try! Realm().objects(RealmUser.self).first { return realmUser } else { return nil } }
  func writeRealmUser(user: User?) -> User? { if let user = user { try! Realm().write { try! Realm().add(RealmUser().setRealmUser(user), update: true) }; return user } else { return nil } }
  
  // MARK: User Functions
  public class func updateUserToServer(updateBlock: (user: User?) -> User?, completionBlock: UserControllerServerResponseBlock? = nil) {
    if let user = updateBlock(user: UserModel.sharedUser().user), let user_id = user._id {
      
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
      let hasAgreedToUserAgreement: Bool = user.hasAgreedToUserAgreement ?? false
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
      
      Alamofire.request(.POST, ServerUrl.Default.getValue() + "/user/update?_id=\(user_id)", parameters: [
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
        "hasAgreedToUserAgreement": hasAgreedToUserAgreement,
        "currentUUID": currentUUID,
        // referral system
        "referralCode": referralCode,
      ] as [String: AnyObject], encoding: .JSON)
      .response { req, res, data, error in
        if let error = error {
          log.error(error)
        } else if let data = data, let json: JSON! = JSON(data: data) {
          if let error = json["error"].string {
            log.error(error)
          } else {
            UserModel.setSharedUser(User(json: json))
            completionBlock?(user: User(json: json))
          }
        }
      }
    }
  }
  
  public class func deleteUserInServer(user_id: String?) {
    let alertController = UIAlertController(title: "Delete Account", message: "Are you sure you want to delete your account? This process is irreversable and all your data will be lost.", preferredStyle: .Alert)
    alertController.addAction(UIAlertAction(title: "Yes, I'm sure.", style: .Default) { action in
      guard let user_id = user_id else { return }
      Alamofire.request(
        .DELETE,
        ServerUrl.Default.getValue() + "/user/\(user_id)"
      )
      .response { req, res, data, error in
        if let error = error {
          log.error(error)
        } else {
          LoginController.logOut()
        }
      }
    })
    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
    })
    TabView.currentView()?.presentViewController(alertController, animated: true, completion: nil)
  }
  
  public class func getUserFromServer() {
    if let user_id = UserModel.sharedUser().user?._id {
      DLHTTP.GET("/user/find", parameters: [ "_id": user_id ] as [ String: AnyObject ]) { (json, error) in
        if let json = json {
          UserModel.setSharedUser(User(json: json))
        }
      }
    }
  }
}