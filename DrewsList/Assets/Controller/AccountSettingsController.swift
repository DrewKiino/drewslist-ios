//
//  AccountSettingsController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/21/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift

public class AccountSettingsController {
  
  private let model = AccountSettingsModel()
  
  public func getModel() -> AccountSettingsModel { return model }
  
  // MARK: Realm Functions
  
  public func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(model.user), update: true) } }
}