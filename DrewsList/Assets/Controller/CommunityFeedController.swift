//
//  CommunityController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift

public class CommunityFeedController {
  
  let model = CommunityFeedModel()
  
  // MARK: Realm Functions
  
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser() { try! Realm().write { try! Realm().add(RealmUser().setRealmUser( self.model.user), update: true) } }
}
