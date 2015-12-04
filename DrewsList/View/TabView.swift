//
//  TabView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/4/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class TabView: RAMAnimatedTabBarController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    
  }
  
  private func setupFeedView() {
    let item = RAMAnimatedTabBarItem(tabBarSystemItem: .TopRated, tag: 1)
  }
  
  private func setupActivityView() {
    let item = RAMAnimatedTabBarItem(tabBarSystemItem: .Recents, tag: 2)
  }
  
  private func setupISBNScannerView() {
    let item = RAMAnimatedTabBarItem(tabBarSystemItem: .Search, tag: 3)
  }
  
  private func setupChatView() {
    let item = RAMAnimatedTabBarItem(tabBarSystemItem: .Contacts, tag: 4)
  }
  
  private func setupUserProfileView() {
    let item = RAMAnimatedTabBarItem(tabBarSystemItem: .Featured, tag: 5)
  }
}