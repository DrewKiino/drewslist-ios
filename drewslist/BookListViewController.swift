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
import ImageViewer
import PromiseKit

class DLViewController: BasicViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
  }
}

class BookListViewController: DLViewController {
  static let shared = BookListViewController()
  private let tableView = UITableView(frame: .zero, style: .plain)
  var listings: [Listing] = []
  var visibleListings: [Listing] = []
  // search bar
  var searchBarYConstraint: NSLayoutConstraint?
  let searchBar = SearchBar()
  var currentState: String = "CA"
  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .white
    
    searchBar.didTapSearchHandler = { [weak self] text in
      when(fulfilled: [
//        Listing.fetch(inBook: "title", value: text),
        Listing.fetch(inBook: "author", value: text),
//        Listing.fetch(inAddress: "city", value: text),
//        Listing.fetch(key: "country", value: text),
//        Listing.fetch(key: "state", value: text),
//        Listing.fetch(key: "subLocality", value: text),
//        Listing.fetch(key: "subAdminArea", value: text)
      ])
      .then { [weak self] results -> () in
        var listings = results.reduce([], { (f, i) in f + i })
        log.debug(listings.count)
        listings = listings.prune(where: { lhs, rhs in lhs.id == rhs.id })
        log.debug(listings.count)
        self?.visibleListings = listings
//          .flatMap({ listing -> Listing? in
//            // make sure we only allow listings with images
//            guard listing.media.first != nil else { return nil }
//            if
//              let location = location,
//              let long = listing.address?.longitude,
//              let lat = listing.address?.latitude
//            {
//              var distance = CLLocation(latitude: lat, longitude: long).distance(from: location)
//              // meters to miles rounde to nearest hundreths
//              distance = round(distance * 100 * 0.000621371) / 100
//              listing.distance = distance
//            }
//            return listing
//          })
//          .sorted(by: { lhs, rhs in
//            if let lhsD = lhs.distance, let rhsD = rhs.distance {
//              return lhsD < rhsD
//            }
//            return false
//          })
        self?.tableView.reloadData()
      }
      .catch { log.error($0) }
    }
    searchBar.didChangeTextHandler = { [weak self] text in
//      guard let listings = self?.listings else { return }
//      guard var text = text, !text.isEmpty else {
//        self?.visibleListings = listings
//        self?.tableView.reloadData()
//        return 
//      }
//      self?.visibleListings = listings
//      .filter({ listing -> Bool in
//        if let title = listing.book?.title?
//          .components(separatedBy: CharacterSet.alphanumerics.inverted)
//          .flatMap({ $0.isEmpty ? nil : $0 })
//          .reduce("", { (f, i) in "\(f) \(i)" })
//          .lowercased()
//        {
//          text = text
//            .components(separatedBy: CharacterSet.alphanumerics.inverted)
//            .flatMap({ $0.isEmpty ? nil : $0 })
//            .reduce("", { (f, i) in "\(f) \(i)" })
//            .lowercased()
//          return title.contains(text)
//        }
//        return false
//      })
//      self?.tableView.reloadData()
    }
    view.addSubview(searchBar)
    searchBar
    .anchor(.left, .right)
    .anchor(.bottom) { [weak self] (constraint) in
      self?.searchBarYConstraint = constraint
    }
    .height(44)
    
    tableView.delegate = self
    tableView.dataSource = self
    tableView.backgroundColor = .clear
    tableView.separatorColor = .clear
    tableView.showsVerticalScrollIndicator = false
    tableView.registerBookListCell()
    view.addSubview(tableView)
    tableView.anchor(.top, padding: 44).anchor(.left, .right).anchor(.top, of: searchBar)
    
    Listing.shared.visibleListingsSignal.subscribe(on: self) { [weak self] (listings) in
      self?.process(listings: listings)
    }
    
    LocationManager.shared.currentLocationSignal.subscribeOnce(on: self) { [weak self](location) in
      LocationManager.shared.address(from: location)
      .then { address -> () in
        if let state = address?.state {
          self?.currentState = state
        }
      }
      .catch { log.error($0) }
    }
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    resetViewState()
  }
  
  func process(listings: [Listing]) {
    if visibleListings.count == 0 || visibleListings.count == listings.count {
      visibleListings = listings
    }
    self.listings = listings
    tableView.reloadData()
  }
  
  func resetViewState() {
    headerView.leftButtonTappedHandler = { [weak self] in
      self?.showStateFilterOptions()
    }
    headerView.rightButtonTappedHandler = {
      RootController.shared.presentListBookVC()
    }
    headerView.setLeftButtonText("State: CA")
    headerView.setRightButtonText("List Book")
    
    keyboardWillShowHandler = { [weak self] height in
      UIView.animate(
        withDuration: 0.5,
        delay: 0.0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 0.5,
        options: [
          .curveEaseInOut,
          .allowUserInteraction
        ],
        animations: { [weak self] in
          self?.searchBarYConstraint?.constant = -height
        }
      ) { _ in
      }
    }
    keyboardWillHideHandler = { [weak self] in
      UIView.animate(
        withDuration: 0.5,
        delay: 0.0,
        usingSpringWithDamping: 1.0,
        initialSpringVelocity: 0.5,
        options: [
          .curveEaseInOut,
          .allowUserInteraction
        ],
        animations: { [weak self] in
          self?.searchBarYConstraint?.constant = 0
        }
      ) { _ in
      }
    }
  }
  
  func showStateFilterOptions() {
    let vc = StateSearchViewController.shared
    vc.didSelectStateHandler = { [weak vc, weak self] state in
      self?.headerView.setLeftButtonText("State: \(state)")
      vc?.dismiss(animated: true) {
      }
    }
    BookListViewController.shared.present(vc, animated: true) { 
    }
  }
}

extension BookListViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let point = scrollView.panGestureRecognizer.location(in: view)
    if point.y > searchBar.frame.origin.y + 44 {
      searchBar.resignFirstResponder()
    }
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
