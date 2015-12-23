//
//  ListView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Gifu
import SDWebImage
import SwiftDate
import Async

public class ListViewContainer: UIViewController {
  
  public var listView: ListView?
  public var listing: Listing?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupListView()
    setupSelf()
    
    listView?.fillSuperview()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupListView() {
    listView = ListView()
    listView?.setListing(listing)
    view.addSubview(listView!)
  }
  
  private func setupSelf() {
    
    view.backgroundColor = .whiteColor()
    
    title = "View Listing"
  }
  
  public func setListing(listing: Listing?) -> Self {
    self.listing = listing
    return self
  }
  
  public func setList_id(listing: String?) -> Self {
    
    return self
  }
}

public class ListView: UIView, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = ListController()
  private var model: ListModel { get { return controller.getModel() } }
  private var defaultSeperatorColor: UIColor?
  
  public var tableView: DLTableView?
  
  public init() {
    super.init(frame: CGRectZero)
    setupDataBinding()
    setupTableView()
    
    backgroundColor = UIColor.whiteColor()
  }
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  public func setListing(listing: Listing?) -> Bool {
    guard let listing = listing else { return false }
    
    controller.setListing(listing)
    
    tableView?.reloadData()
    
    return true
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.backgroundColor = .whiteColor()
    
    addSubview(tableView!)
  }
  
  private func setupDataBinding() {
    controller.get_Listing().listen(self) { [weak self] listing in
      self?.tableView?.reloadData()
    }
  }
  
  // MARK: UITableView Delegates 
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 166
    case 1: return 48
    case 2: return 200
    default: return 0
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // get listing reference
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        
        cell.bookView?.setBook(model.listing?.book)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.bookView?.setBook(listing?.book)
        }
        
        return cell
      }
    case 1:
      
      if  let cell = tableView.dequeueReusableCellWithIdentifier("ListerProfileViewCell", forIndexPath: indexPath) as? ListerProfileViewCell {
        cell.setListing(model.listing)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.setListing(listing)
        }
        
        return cell
      }
    case 2:
      if  let cell = tableView.dequeueReusableCellWithIdentifier("ListerAttributesViewCell", forIndexPath: indexPath) as? ListerAttributesViewCell {
        
        cell.setListing(model.listing)
        controller.get_Listing().removeListener(self)
        controller.get_Listing().listen(self) { [weak cell] listing in
          cell?.setListing(listing)
        }
        
        return cell
      }
    default: break
    }
    
    return DLTableViewCell()
  }
}










