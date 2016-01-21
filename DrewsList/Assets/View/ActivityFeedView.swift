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
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 56
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("ActivityCell") as? ActivityCell {
      cell.setActivity(model.activities[indexPath.row])
      cell.showBottomBorder()
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
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupLeftImageView()
    setupRightImageView()
    setupMiddleContainer()
    setupActivityLabel()
    setupTimestampLabel()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    leftImageView?.anchorToEdge(.Left, padding: 4, width: 36, height: 36)
    rightImageView?.anchorToEdge(.Right, padding: 4, width: 36, height: 36)
    middleContainer?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: leftImageView!, padding: 4, width: frame.width - 48 - 40)
    activityLabel?.anchorAndFillEdge(.Top, xPad: 4, yPad: 4, otherSize: 30)
    timestampLabel?.alignAndFill(align: .UnderMatchingLeft, relativeTo: activityLabel!, padding: 0)
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
  
  public func setActivity(activity: Activity) {
    
    leftImageView?.dl_setImageFromUrl(activity.leftImage, maskWithEllipse: true)
    
    activityLabel?.attributedText = activity.getMessage()
    
    let attributedString = NSMutableAttributedString(string: (activity.message?["createdAt"].string?.toRelativeString() ?? ""), attributes: [
      NSFontAttributeName: UIFont.asapRegular(12),
      NSForegroundColorAttributeName: UIColor.sexyGray()
    ])
    
    timestampLabel?.attributedText = attributedString
  }
}
