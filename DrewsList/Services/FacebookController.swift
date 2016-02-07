//
//  Facebook.swift
//  DrewsList
//
//  Created by Steven Yang on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import RealmSwift
import FBSDKCoreKit
import FBSDKLoginKit

public class Facebook {
  private struct Singleton {
    static let facebook = Facebook()
  }
  
  public func sharedInstance() -> Facebook { return Singleton.facebook }
  
  // MARK: Realm Functions
  
  private var user: User?
  
  private func readRealmUser(){ if let realmUser =  try! Realm().objects(RealmUser.self).first { user = realmUser.getUser() } }
  private func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.user), update: true) } }
}
