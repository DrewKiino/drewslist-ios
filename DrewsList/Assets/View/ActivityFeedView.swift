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
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .whiteColor()
    
    setRootViewTitle("Activity")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    view.showComingSoonScreen()
  }
}