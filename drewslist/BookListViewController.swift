//
//  BookListViewController.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftLocation
import Firebase

class DLViewController: BasicViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

class BookListViewController: DLViewController {
  static let shared = BookListViewController()
  private let tableView = UITableView(frame: .zero, style: .plain)
  var visibleListings: [Listing] = []
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .clear
    tableView.separatorColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.registerBookListCell()
    view.addSubview(tableView)
    tableView.fillSuperview(left: 0, right: 0, top: 44, bottom: 0)
    
    Listing.shared.listingsSignal.subscribe(on: self) { [weak self] (listings) in
      self?.visibleListings = listings
      self?.tableView.reloadData()
    }
    
    DataManager.fetch()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    headerView.rightButtonTappedHandler = {
      RootController.shared.presentListBookVC()
    }
    headerView.setLeftButtonText(nil)
    headerView.setRightButtonText("List Book")
  }
}

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return BookListCell.height
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return visibleListings.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    return .bookListCell(visibleListings, at: indexPath, using: tableView)
  }
}
