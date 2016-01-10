//
//  EditListingView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class EditListingView: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = EditListingController()
  private var model: EditListingModel { get { return controller.model } }
  
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupTableView()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  public func setListing(listing: Listing?) -> Self {
    if let listing = listing { model.listing = listing }
    return self
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("EditListingCell") as? EditListingCell {
      cell.setBook(model.listing?.book)
      return cell
    }
    return DLTableViewCell()
  }
}

public class EditListingCell: DLTableViewCell {
  
  public var bookView: BookView?
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupBookView()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    bookView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 150)
  }
  
  private func setupBookView() {
    bookView = BookView()
    addSubview(bookView!)
  }
  
  public func setBook(book: Book?) {
    bookView?.setBook(book)
  }
}





















