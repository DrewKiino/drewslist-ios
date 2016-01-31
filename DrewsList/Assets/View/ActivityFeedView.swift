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
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
  }
  
  private func setupDataBinding() {
    model._activity.removeListener(self)  
    model._activity.listen(self) { [weak self] activity in
      // show the notification
      self?.view.displayNotification(activity?.message?["message"].string) { [weak self] in
      }
      // reload the tableview
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
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.activities.count
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
  public var middleContainer: UIView?
  public var activityLabel: UILabel?
  public var timestampLabel: UILabel?
  
  public var activity: Activity?
  
  public var _containerPressed = Signal<Activity?>()
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupLeftImageView()
    setupRightImageView()
    setupMiddleContainer()
    setupActivityLabel()
//    setupTimestampLabel()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    leftImageView?.anchorToEdge(.Left, padding: 4, width: 36, height: 36)
    rightImageView?.anchorToEdge(.Right, padding: 4, width: 36, height: 36)
    middleContainer?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: leftImageView!, padding: 4, width: frame.width - 48 - 40)
//    activityLabel?.anchorAndFillEdge(.Top, xPad: 4, yPad: 4, otherSize: 30)
    activityLabel?.anchorInCorner(.TopLeft, xPad: 4, yPad: 4, width: middleContainer!.width - 8, height: 30)
    timestampLabel?.alignAndFill(align: .UnderMatchingLeft, relativeTo: activityLabel!, padding: 0)
    
    setActivity(activity)
  }
  
  private func setupLeftImageView() {
    leftImageView = UIImageView()
    addSubview(leftImageView!)
  }
  
  private func setupRightImageView() {
    rightImageView = UIImageView()
    addSubview(rightImageView!)
  }
  
  private func setupMiddleContainer() {
    middleContainer = UIView()
    middleContainer?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "containerPressed"))
    addSubview(middleContainer!)
  }
  
  private func setupActivityLabel() {
    activityLabel = UILabel()
    activityLabel?.font = UIFont.asapRegular(12)
    activityLabel?.numberOfLines = 2
    middleContainer?.addSubview(activityLabel!)
  }
  
  private func setupTimestampLabel() {
    timestampLabel = UILabel()
    timestampLabel?.font = UIFont.asapRegular(12)
    timestampLabel?.numberOfLines = 1
    middleContainer?.addSubview(timestampLabel!)
  }
  
  public func setActivity(activity: Activity?) {
    guard let activity = activity else { return }
    
    leftImageView?.dl_setImageFromUrl(activity.leftImage, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
    
    var attributedString = activity.getDetailedMessage()
    let attributedString2 = NSMutableAttributedString(string: ((activity.getMessage()?.string.characters.count ?? 0) < 6 ? "\n" : " ") + (activity.message?["createdAt"].string?.toRelativeString() ?? ""), attributes: [
      NSFontAttributeName: UIFont.asapRegular(12),
      NSForegroundColorAttributeName: UIColor.sexyGray()
    ])
    
    if let message = activity.getMessage() where activity.getMessage()?.string.characters.count > 30 {
      attributedString = activity.getDetailedMessage(message.string.stringByPaddingToLength(30, withString: message.string, startingAtIndex: 0) + "...")
    }
    
    attributedString?.appendAttributedString(attributedString2)
    
    activityLabel?.attributedText = attributedString
  }
  
  public func containerPressed() {
    _containerPressed => activity
  }
}
