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

class BookListViewController: UIViewController {
  static let shared = BookListViewController()
  let tableView = UITableView(frame: .zero, style: .plain)
  var listings: [Listing] = []
  var currentLocation: CLLocation?
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    tableView.delegate = self
    tableView.dataSource = self
    tableView.separatorColor = .clear
    tableView.registerBookListCell()
    view.addSubview(tableView)
    tableView.fillSuperview(left: 0, right: 0, top: 20, bottom: 0)
    
    Listing.fetch()
    .then { [weak self] listings -> () in
      self?.listings = listings
    }
    .catch { log.error($0) }
  }
}

extension BookListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 48
  }
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return listings.count
  }
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = UITableViewCell()
    let listing = listings[indexPath.row]
    if let zipcode = listing.zipcode {
      LocationManager.shared.location(from: zipcode)
      .then { location -> () in
        log.debug(zipcode)
        log.debug(location)
        if
          let location = location,
          let distance = LocationManager.shared.currentLocation?.distance(from: location).description.doubleValue
        {
          let rounded = round((distance / 1609.344) * 10) / 10
          cell.textLabel?.text = rounded.description + " miles"
        }
      }
      .catch { log.error($0) }
    }
    return cell
//    return .bookListCell(at: indexPath, using: tableView)
  }
}
