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
import Signals

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
    
    controller.loadActivityFeed()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    controller.saveActivityFeed()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupDataBinding() {
//    model._activity.removeListener(self)  
//    model._activity.listen(self) { [weak self] activity in
//      // show the notification
//      self?.view.displayNotification(activity?.message?["message"].string) { [weak self] in
//      }
//      // reload the tableview
//      self?.tableView?.reloadData()
//    }
    model._activities.removeAllListeners()
    model._activities.listen(self) { [weak self] activities in
      self?.tableView?.reloadData()
    }
  }

  private func setupTableView() {
    tableView = DLTableView()
    tableView?.backgroundColor = .whiteColor()
    tableView?.delegate = self
    tableView?.dataSource = self
    rootView?.view.addSubview(tableView!)
  
    tableView?.fillSuperview()
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 58
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.activities.count < 20 ? model.activities.count : 20
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as? ActivityCell {
      cell.activity = model.activities[indexPath.row]
      cell.showBottomBorder()
      cell._containerPressed.removeAllListeners()
      cell._containerPressed.listen(self) { [weak self] activity in
        if let activity = activity {
          self?.controller.readRealmUser()
          TabView.presentChatView(ChatView().setUsers(self?.model.user, friend: activity.getUser()))
        }
      }
      return cell
    }
    return DLTableViewCell()
  }
}

public class ActivityCell: DLTableViewCell {
  
  public var leftImageView: UIImageView?
  public var rightImageView: UIImageView?
  public var activityLabel: UILabel?
  
  public var activity: Activity?
  
  public var _containerPressed = Signal<Activity?>()
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupLeftImageView()
    setupRightImageView()
    setupActivityLabel()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    leftImageView?.anchorToEdge(.Left, padding: 8, width: 36, height: 36)
    rightImageView?.anchorToEdge(.Right, padding: 8, width: 36, height: 36)
    activityLabel?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: leftImageView!, padding: 8, width: frame.width - 48 - 48)
    
    set(activity)
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
    activityLabel?.font = UIFont.asapRegular(12)
    activityLabel?.numberOfLines = 3
    activityLabel?.userInteractionEnabled = true
    activityLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "containerPressed"))
    addSubview(activityLabel!)
  }
  
  public func set(activity: Activity?) {
    guard let activity = activity else { return }
    
    leftImageView?.dl_setImageFromUrl(activity.leftImage, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
    
    activityLabel?.attributedText = activity.getDetailedMessage()
  }
  
  public func containerPressed() {
    _containerPressed => activity
  }
}
