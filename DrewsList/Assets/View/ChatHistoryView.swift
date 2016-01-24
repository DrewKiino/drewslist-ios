//
//  ChatListView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/19/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import SDWebImage

public class ChatHistoryView: DLNavigationController, UITableViewDelegate, UITableViewDataSource {
  
  // MVC
  private let controller = ChatHistoryController()
  private unowned var model: ChatHistoryModel { get { return controller.model } }

  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupSelf()
    setupDataBinding()
    setupTableView()
    
    tableView?.fillSuperview()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    controller.viewDidAppear()
  }
  
  private func setupSelf() {
    view.backgroundColor = UIColor.whiteColor()
    setRootViewTitle("Chat")
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    rootView?.view.addSubview(tableView!)
  }
  
  private func setupDataBinding() {
    model._user.removeAllListeners()
    model._user.listen(self) { [weak self] user in
      log.debug(user)
    }
    model._chatModels.removeAllListeners()
    model._chatModels.listen(self) { [weak self] models in
      self?.tableView?.reloadData()
    }
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 52
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.chatModels.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if  let cell = tableView.dequeueReusableCellWithIdentifier("ChatHistoryCell") as? ChatHistoryCell {
      let user = model.chatModels[indexPath.row].user
      let friend = model.chatModels[indexPath.row].friend
      cell.showBottomBorder()
      return cell
    }
    return DLTableViewCell()
  }
}

public class ChatHistoryCell: DLTableViewCell {
  
  public var leftImageView: UIImageView?
  public var title: UILabel?
  public var timestamp: UILabel?
  public var arrow: UIImageView?
  public var message: UILabel?
  
  public override func setupSelf() {
    super.setupSelf()
    setupLeftImageView()
    setupTitle()
    setupTimestamp()
    setupArrow()
    setupMessage()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    title?.anchorInCorner(.TopLeft, xPad: 4, yPad: 4, width: screen.width - 100, height: 16)
    arrow?.anchorInCorner(.TopRight, xPad: 4, yPad: 6, width: 12, height: 12)
    timestamp?.align(.ToTheLeftCentered, relativeTo: arrow!, padding: 4, width: 56, height: 16)
    message?.alignAndFill(align: .UnderMatchingLeft, relativeTo: title!, padding: 4)
    
    setupFixtures()
  }
  
  private func setupLeftImageView() {
    leftImageView = UIImageView()
    addSubview(leftImageView!)
  }
  
  private func setupTitle() {
    title = UILabel()
    title?.font = UIFont.asapRegular(12)
    title?.numberOfLines = 1
    addSubview(title!)
  }
  
  private func setupTimestamp() {
    timestamp = UILabel()
    timestamp?.font = UIFont.asapRegular(12)
    timestamp?.numberOfLines = 1
    addSubview(timestamp!)
  }
  
  private func setupArrow() {
    arrow = UIImageView()
    addSubview(arrow!)
  }
  
  private func setupMessage() {
    message = UILabel()
    message?.font = UIFont.asapRegular(10)
    message?.textColor = .sexyGray()
    message?.numberOfLines = 2
    addSubview(message!)
  }
  
  private func setupFixtures() {
    title?.text = "Mary Jane"
    timestamp?.text = "11:00 AM"
    arrow?.dl_setImage(UIImage(named: "Icon-GreyChevron"))
    message?.text = "Bacon ipsum dolor amet turducken bresaola doner ham hock t-bone leberkas capicola salami drumstick porchetta cow ground round pig. Pork loin shank kielbasa sirloin tenderloin tri-tip. Tongue shankle chicken ham drumstick meatball landjaeger jerky corned beef. Strip steak short loin drumstick meatball meatloaf tongue capicola chuck pork kielbasa frankfurter pork belly cow swine pig. Biltong chicken boudin andouille pork. Drumstick venison kielbasa chicken prosciutto landjaeger pork belly picanha."
  }
}




















