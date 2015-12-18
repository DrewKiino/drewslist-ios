//
//  ListFeedView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class ListFeedView: DLNavigationController, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = ListFeedController()
  private var model: ListFeedModel { get { return controller.getModel() } }
  
  public var tableView: UITableView?

  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    setupTableView()
    setupSelf()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  private func setupDataBinding() {
    model._listings.listen(self) { [weak self] listings in
      self?.tableView?.reloadData()
    }
  }
  
  private func setupTableView() {
    tableView = UITableView()
    tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView?.registerClass(ListFeedCell.self, forCellReuseIdentifier: "ListFeedCell")
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.separatorColor = .clearColor()
    rootView?.view.addSubview(tableView!)
  }
  
  private func setupSelf() {
    setRootViewTitle("Listings Feed")
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
    if let tableView = tableView where (tableView.contentOffset.y >= (tableView.contentSize.height - tableView.frame.size.height)) &&
        tableView.frame.height > 0 && controller.getModel().shouldLockView == false && controller.getModel().shouldRefrainFromCallingServer == false
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