//
//  RootNavigationController.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

class RootNavigationController: UINavigationController {
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBar.isHidden = true
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  static var topPresentedViewController: UIViewController? {
    return RootController.shared.navigationController?.topViewController
  }
}

extension RootNavigationController {
  class func presented(with window: inout UIWindow?) {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = RootNavigationController(rootViewController: RootController.shared)
    window?.makeKeyAndVisible()
  }
}
