//
//  ActivityView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/24/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon

public class ActivityFeedView: DLNavigationController, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = ActivityFeedController()
  private var model: ActivityFeedModel { get { return controller.model } }
  
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setRootViewTitle("Activity")
    setupSelf()
    setupDataBinding()
    setupTableView()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupDataBinding() {
    model._activity.removeAllListeners()
    model._activity.listen(self) { [weak self] activity in
      self?.view.displayNotification(activity?.message) { [weak self] in
      }
    }
  }

  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    rootView?.view.addSubview(tableView!)
    
    tableView?.fillSuperview()
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    return DLTableViewCell()
  }
}

public class ActivityCell: DLTableViewCell {
  
  public var leftImageView: UIImageView?
  public var rightImageView: UIImageView?
  public var activityLabel: UILabel?
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupLeftImageView()
    setupRightImageView()
    setupActivityLabel()
  }
  
  private func setupLeftImageView() {
    leftImageView = UIImageView()
    addSubview(leftImageView!)
  }
  
  private func setupRightImageView() {
    rightImageView = UIImageView()
    addSubview(rightImageView!)
  }
  
  private func setupActivityLabel() {
    activityLabel = UILabel()
    addSubview(activityLabel!)
  }
}
