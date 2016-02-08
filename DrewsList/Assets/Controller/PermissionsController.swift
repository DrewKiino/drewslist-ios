//
//  PermissionsController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import PermissionScope

public class PermissionsController {
  
  // MARK: Singleton instance
  
  private struct Singleton { static let permissionController = PermissionsController() }
  public class func sharedInstance() -> PermissionsController { return Singleton.permissionController }
}