//
//  RootController.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import SwiftyTimer

class RootController: UIViewController {
  static let shared = RootController()
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    let headerView = HeaderView.shared
    UIApplication.shared.keyWindow?.addSubview(headerView)
    headerView.anchor(.top).matching(.width).height(44)
    navigationController?.pushViewController(ListingViewController.shared, animated: false)
//    navigationController?.pushViewController(BookListViewController.shared, animated: false)
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
}
