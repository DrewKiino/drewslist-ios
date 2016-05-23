//
//  ProfileImagePickerController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKCoreKit
import Alamofire

public class ProfileImagePickerController {
  
  public let model = ProfileImagePickerModel()
  private let fbsdkController = FBSDKController()
  
  public init() {
    model.user = UserModel.sharedUser().user
    model.fbProfileImageURL = model.user?.facebook_image
  }
 
  public func setupFBProfile(){
    let pictureRequest = FBSDKGraphRequest(graphPath: "me/picture?type=large&redirect=false", parameters: nil)
    pictureRequest.startWithCompletionHandler({
      (connection, result, error: NSError!) -> Void in
      if error == nil {
        if let url = result["data"]??["url"]{
          self.model.fbProfileImageURL = "\(url)"
        }
      } else {
        print("\(error)")
        self.model.fbProfileImageURL = nil
      }
    })
  }
  
  public func setFirstName(string: String?) {
    model.user?.firstName = string
  }
  
  public func setLastName(string: String?) {
    model.user?.lastName = string
  }
  
  public func setUsername(string: String?) {
    model.user?.username = string
  }
}
