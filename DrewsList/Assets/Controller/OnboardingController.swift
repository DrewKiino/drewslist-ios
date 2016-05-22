//
//  OnboardingController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import PermissionScope

public class OnboardingController {
  
  private let model = OnboardingModel()
  
  private let fbsdkController = FBSDKController()
  
  public func loginThroughFBSDK(completionHandler: (User? -> Void)) {
    fbsdkController.getUserAttributesFromFacebook(completionHandler)
  }
}