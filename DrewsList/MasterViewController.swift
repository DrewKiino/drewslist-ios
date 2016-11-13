//
//  MasterViewController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import Neon

public class MasterViewController: UINavigationController {
}

// MARK: Life Cycle
extension MasterViewController {
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationBarHidden = true
  }
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  public override func viewDidDisappear(animated: Bool) {
    super.viewDidAppear(animated)
  }
}

// MARK: Layouts
extension MasterViewController {
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
}

