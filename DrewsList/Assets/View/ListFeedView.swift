//
//  ListFeedView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class ListFeedViewContainer: UIScrollView {
  
  public var saleListFeedView: ListFeedView?
  public var wishListFeedView: ListFeedView?
  
  public init() {
    super.init(frame: CGRectZero)
    
    setupSaleListFeed()
    setupWishListFeed()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  public func setupSaleListFeed() {
    saleListFeedView = ListFeedView()
    addSubview(saleListFeedView!)
  }
  
  public func setupWishListFeed() {
    wishListFeedView = ListFeedView()
    addSubview(wishListFeedView!)
  }
}

public class ListFeedView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = ListFeedController()
  private var model: ListFeedModel { get { return controller.getModel() } }
  
  public init() {
    super.init(frame: CGRectZero, style: .Plain)
    
    setupDataBinding()
    setupTableView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func setupDataBinding() {
    model._listings.listen(self) { [weak self] listings in
      self?.reloadData()
    }
  }
  
  private func setupTableView() {
    registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    registerClass(ListFeedCell.self, forCellReuseIdentifier: "ListFeedCell")
    delegate = self
    dataSource = self
    separatorColor = .clearColor()
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 420
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.listings.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let listing = model.listings[indexPath.row]
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("ListFeedCell", forIndexPath: indexPath) as? ListFeedCell {
      cell.listView?.setListing(listing)
    }
    
    return cell
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if contentOffset.y >= (contentSize.height - frame.size.height) &&
        frame.height > 0 && controller.getModel().shouldLockView == false && controller.getModel().shouldRefrainFromCallingServer == false
    {
      // user has scrolled to the bottom!
      // begin getting more data
      controller.getListingsFromServer(model.listings.count)
    }
  }
}

public class ListFeedCell: UITableViewCell {
  
  public var listView: ListView?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupListView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    listView?.fillSuperview()
  }
  
  private func setupListView() {
    listView = ListView()
    listView?.tableView?.scrollEnabled = false
    addSubview(listView!)
  }
}