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
import Async

public class ActivityFeedView: DLNavigationController, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = ActivityFeedController()
  private var model: ActivityFeedModel { get { return controller.model } }
  
  private var tableView: DLTableView?
  
  private var refreshControl: UIRefreshControl?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setRootViewTitle("Activity")
    setupSelf()
    setupDataBinding()
    setupTableView()
    setupRefreshControl()
    
    view.showActivityView()
    
    FBSDKController.createCustomEventForName("UserActivityFeed")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    setupRefreshControl()
    
    controller.viewDidAppear()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  public override func setupDataBinding() {
    super.setupDataBinding()
    controller.didGetActivityHistoryFromServer.removeAllListeners()
    controller.didGetActivityHistoryFromServer.listen(self) { [weak self] didGet in
      if didGet {
        
        self?.tableView?.reloadData()
        
        NSTimer.after(1.0) { [weak self] in
          self?.refreshControl?.endRefreshing()
        }
      }
        
      self?.view.dismissActivityView()
    }
    model._badgeCount.removeAllListeners()
    model._badgeCount.listen(self) { [weak self] count in
      if let string: String! = String(count ?? 0) where count > 0 { self?.tabBarItem.badgeValue = string }
      else { self?.tabBarItem.badgeValue = nil }
    }
  }

  private func setupTableView() {
    tableView = DLTableView()
    tableView?.showsVerticalScrollIndicator = true
    tableView?.backgroundColor = .whiteColor()
    tableView?.delegate = self
    tableView?.dataSource = self
    rootView?.view.addSubview(tableView!)
  }
  
  private func setupRefreshControl() {
    refreshControl?.removeFromSuperview()
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    tableView?.addSubview(refreshControl!)
  }
  
  // MARK: UIRefreshControl methods 
  
  public func refresh(sender: UIRefreshControl) {
    controller.readRealmUser()
    controller.getActivityFeedFromServer()
  }
  
  // MARK: UITableView delegate methods
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 58
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.activities.count < 50 ? model.activities.count : 50
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell", forIndexPath: indexPath) as? ActivityCell {
      cell.activity = model.activities[indexPath.row]
      cell.showSeparatorLine()
      cell._containerPressed.removeAllListeners()
      cell._containerPressed.listen(self) { [weak self] activity in
        if let activity = activity {
          self?.controller.readRealmUser()
          self?.pushViewController(ChatView().setUsers(self?.model.user, friend: activity.user), animated: true)
        }
      }
      
      cell.backgroundColor = (model.activities[indexPath.row].timestamp ?? "").isRecent() ? .paradiseGray() : .whiteColor()
      
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
    activityLabel?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: leftImageView!, padding: 12, width: screen.width - 72)
    
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
    activityLabel?.textColor = .coolBlack()
    activityLabel?.font = UIFont.asapRegular(12)
    activityLabel?.numberOfLines = 3
    activityLabel?.userInteractionEnabled = true
    activityLabel?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "containerPressed"))
    addSubview(activityLabel!)
  }
  
  public func set(activity: Activity?) {
    guard let activity = activity else { return }
    
    if activity.isBot {
      leftImageView?.image = UIImage(named: "mrfreeto-profile-icon")
      activity.user?.username = "Jarvis"
      
    } else {
      leftImageView?.dl_setImageFromUrl(activity.leftImage, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
      
    }
    
    if activity.isLocationActivity() {
      Async.background { [weak self, weak activity] in
        LocationController.sharedInstance().getAddressString(activity?.location) { [weak self, weak activity] string in
          var attributedString: NSMutableAttributedString? = activity?.getDetailedMessage()?.append(NSMutableAttributedString(string: string))
          Async.main { [weak self] in
            self?.activityLabel?.attributedText = attributedString
            attributedString = nil
          }
        }
      }
    } else {
      activityLabel?.attributedText = activity.getDetailedMessage()
    }
  }
  
  public func containerPressed() {
    _containerPressed => activity
  }
}
