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
import Signals

public class ChatHistoryView: DLNavigationController, UITableViewDelegate, UITableViewDataSource {
  
  // MVC
  private let controller = ChatHistoryController()
  private var model: ChatHistoryModel { get { return controller.model } }

  private var tableView: DLTableView?
  
  private var refreshControl: UIRefreshControl?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupSelf()
    setupDataBinding()
    setupTableView()
    setupRefreshControl()
    
    tableView?.fillSuperview()
    
    view.showActivityView()
    FBSDKController.createCustomEventForName("UserChatHistory")
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
    tableView?.backgroundColor = .whiteColor()
    tableView?.showsVerticalScrollIndicator = true
    rootView?.view.addSubview(tableView!)
  }
  
  private func setupDataBinding() {
    model._user.removeAllListeners()
    model._user.listen(self) { [weak self] user in
    }
    model._shouldRefreshViews.removeAllListeners()
    model._shouldRefreshViews.listen(self) { [weak self] bool in
      
      if bool {
        UIView.animateWithDuration(0.2) { [weak self] in
          self?.tableView?.reloadData()
        }
      }
    
      self?.view.dismissActivityView()
      
      NSTimer.after(1.0) { [weak self] in
        self?.refreshControl?.endRefreshing()
      }
    }
  }
  
  private func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    tableView?.addSubview(refreshControl!)
  }
  
  // MARK: UIRefreshControl methods
  
  public func refresh(sender: UIRefreshControl) {
    controller.readRealmUser()
    controller.loadChatHistoryFromServer()
  }
  
  // MARK: UITableView delegate methods
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 58
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.chatModels.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if  let cell = tableView.dequeueReusableCellWithIdentifier("ChatHistoryCell") as? ChatHistoryCell {
      cell.chatModel = model.chatModels[indexPath.row]
      cell.showSeparatorLine()
      cell._cellPressed.removeAllListeners()
      cell._cellPressed.listen(self) { [weak self] chatModel in
        self?.controller.readRealmUser()
        self?.pushViewController(ChatView().setUsers(self?.model.user, friend: chatModel?.friend), animated: true)
      }
      
      cell.backgroundColor = (model.chatModels[indexPath.row].messages.last?.date().isRecent() ?? false) ? .paradiseGray() : .whiteColor()
      
      return cell
    }
    return DLTableViewCell()
  }
  
  public func loadChatHistory() {
    controller.loadChatHistoryFromServer()
  }
}

public class ChatHistoryCell: DLTableViewCell {
  
  public var leftImageView: UIImageView?
  public var title: UILabel?
  public var timestamp: UILabel?
  public var arrow: UIImageView?
  public var message: UILabel?
  
  public var chatModel: ChatModel?
  
  public let _cellPressed = Signal<ChatModel?>()
  
  public override func setupSelf() {
    super.setupSelf()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellPressed"))
    
    setupLeftImageView()
    setupTitle()
    setupTimestamp()
    setupArrow()
    setupMessage()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    leftImageView?.anchorToEdge(.Left, padding: 8, width: 36, height: 36)
    title?.align(.ToTheRightMatchingTop, relativeTo: leftImageView!, padding: 8, width: screen.width - 100, height: 16)
    arrow?.anchorAndFillEdge(.Right, xPad: 8, yPad: 20, otherSize: 12)
//    timestamp?.align(.ToTheLeftCentered, relativeTo: arrow!, padding: 8, width: 48, height: 16)
    timestamp?.anchorInCorner(.TopRight, xPad: 12, yPad: 12, width: 48, height: 16)
    message?.alignAndFillWidth(align: .ToTheRightMatchingBottom, relativeTo: leftImageView!, padding: 8, height: 24)
    
    set(chatModel: chatModel)
  }
  
  private func setupLeftImageView() {
    leftImageView = UIImageView()
    addSubview(leftImageView!)
  }
  
  private func setupTitle() {
    title = UILabel()
    title?.textColor = .coolBlack()
    title?.font = UIFont.asapRegular(14)
    title?.numberOfLines = 1
    addSubview(title!)
  }
  
  private func setupTimestamp() {
    timestamp = UILabel()
    timestamp?.textColor = .coolBlack()
    timestamp?.font = UIFont.asapRegular(12)
    timestamp?.textColor = .sexyGray()
    timestamp?.numberOfLines = 1
    addSubview(timestamp!)
  }
  
  private func setupArrow() {
    arrow = UIImageView()
    addSubview(arrow!)
  }
  
  private func setupMessage() {
    message = UILabel()
    message?.textColor = .coolBlack()
    message?.font = UIFont.asapRegular(12)
    message?.textColor = .sexyGray()
    message?.numberOfLines = 2
    addSubview(message!)
  }
  
  public func cellPressed() {
    _cellPressed => chatModel
  }
  
  public func set(chatModel chatModel: ChatModel?) {
    guard let chatModel = chatModel else { return }
    
    arrow?.dl_setImage(UIImage(named: "Icon-GreyChevron"))
    
    leftImageView?.dl_setImageFromUrl(chatModel.friend?.imageUrl, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
    
    title?.text = chatModel.friend?.getName()
    
    timestamp?.text = chatModel.messages.last?.date().dl_toRelativeString()
    
    message?.text = chatModel.messages.last?.isMediaMessage() == true ?
      chatModel.messages.last?.senderId() == UserController.sharedUser().user?._id ? "you have sent them your location" : "has sent you their location."
      : chatModel.messages.last?.text?()
  }
}





















