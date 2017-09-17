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

class RootController: BasicViewController {
  static let shared = RootController()
  override func viewDidLoad() {
    super.viewDidLoad()
    HeaderView.moveToWindow()
    headerView.backgroundColor = .dlBlue
    headerView.leftButton.setTitleColor(.white, for: .normal)
    headerView.rightButton.setTitleColor(.white, for: .normal)
    RootNavigationController.shared
    .pushViewController(BookListViewController.shared, animated: true) { [weak self] in
      self?.isPresenting = false
    }
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
  }
  private var isPresenting: Bool = false
  func presentBookListVC() {
    guard !isPresenting else { return }; isPresenting = true
    RootNavigationController.shared
    .popToViewController(BookListViewController.shared, animated: true) { [weak self] in
      self?.isPresenting = false
    }
  }
  func presentListBookVC() {
    guard !isPresenting else { return }; isPresenting = true
    RootNavigationController.shared
    .pushViewController(ListBookViewController.shared, animated: true) { [weak self] in
      self?.isPresenting = false
    }
  }
}
