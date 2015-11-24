//
//  ChatView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import Toucan
import SwiftDate

public class ChatView: JSQMessagesViewController {
  
  public class func setup(user: User, friend: User) -> ChatView {
    let chatView = ChatView()
    chatView.controller.model.user = user
    chatView.controller.model.friend = friend
    return chatView
  }
  
  // MVC
  private let controller = ChatController()
  private unowned var model: ChatModel { get { return controller.model } }
  private var recentSender: String?
  
  // private vars
  private let incomingBubble = JSQMessagesBubbleImageFactory()
    .incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
  private let outgoingBubble = JSQMessagesBubbleImageFactory()
    .outgoingMessagesBubbleImageWithColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0))
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.showsVerticalScrollIndicator = false
    setupDataBinding()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    controller.viewWillAppear()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    controller.viewDidAppear()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewDidDisappear(animated)
    controller.viewDidDisappear()
  }
  
  private func setupDataBinding() {
    model._messages.listen(self) { [weak self] messages in
      self?.collectionView?.reloadData()
    }
    // set and listen for changes in the user's username
    senderDisplayName = model.user?.username ?? ""
    model.user?._username.listen(self) { [weak self] username in
      guard let username = username else { return }
      self?.senderDisplayName = username
    }
    // set and listen for changes in the user's _id
    senderId = model.user?._id ?? ""
    model.user?.__id.listen(self) { [weak self] _id in
      guard let _id = _id else { return }
      self?.senderId = _id
    }
    // listen for changes in the 'isSendingMessage'
    // if the controller is currently sending a message,
    // update the UI
    controller.isSendingMessage.listen(self) { isSending in
    }
    // listen for changes in the 'didSendMessage'
    // if 'isSent' is true, update the UI
    controller.didSendMessage.listen(self) { [weak self] isSent in
      if isSent == true { self?.finishSendingMessage() }
    }
    // listen for changes in the 'didReceiveMessage'
    // if 'didReceive' is true, update the UI
    controller.didReceiveMessage.listen(self) { [weak self] didReceive in
      if didReceive == true { self?.finishReceivingMessage() }
    }
  }
  
  public override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    // tell the controller the 'send' button was pressed, then pass in the data
    controller.didPressSendButton(text)
  }
  
  public override func didPressAccessoryButton(sender: UIButton!) {}
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return indexPath.row == 0 ? 24 : indexPath.row > 0 && model.messages[indexPath.row - 1].date.add(hours: 1) <= model.messages[indexPath.row].date ? 24 : 0
//    return indexPath.row == 0 ? 24 : indexPath.row > 0 && model.messages[indexPath.row - 1].date.add(seconds: 3) <= model.messages[indexPath.row].date ? 24 : 0
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
    guard let dateString = model.messages[indexPath.row].date?.toShortTimeString() else { return nil }
    let attrDateString = NSAttributedString(string: dateString)
    return indexPath.row == 0 ? attrDateString : indexPath.row > 0 && model.messages[indexPath.row - 1].date.add(hours: 1) <= model.messages[indexPath.row].date ? attrDateString : nil
//    return indexPath.row == 0 ? attrDateString : indexPath.row > 0 && model.messages[indexPath.row - 1].date.add(seconds: 3) <= model.messages[indexPath.row].date ? attrDateString : nil
  }
  
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return indexPath.row > 0 && model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ? 0 : 24
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
    let name = model.messages[indexPath.row].senderId == senderId ?
      NSAttributedString(string: model.user!.getFullName()!) : NSAttributedString(string: model.friend!.getFullName()!)
    return indexPath.row > 0 && model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ? nil : name
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return 0
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellBottomLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
    return nil
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    return model.messages[indexPath.row]
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    return model.messages[indexPath.row].senderId == senderId ?
      outgoingBubble : incomingBubble
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    return model.messages[indexPath.row].senderId == senderId ?
      MessageAvatar(avatar: model.user!.avatar!) : MessageAvatar(avatar: model.friend!.avatar!)
  }
  
  public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.messages.count
  }
}


