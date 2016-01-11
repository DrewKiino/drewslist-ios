//
//  ActivityView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/24/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon

public class ActivityFeedView: DLNavigationController {
  
  private let controller = ActivityFeedController()
  private var model: ActivityFeedModel { get { return controller.model } }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setRootViewTitle("Activity")
    setupSelf()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    view.showComingSoonScreen()
  }
  
  private func setupSelf() {
    
    view.backgroundColor = .whiteColor()
  }
}