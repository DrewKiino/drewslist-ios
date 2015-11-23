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

public class ChatView: JSQMessagesViewController {
  
  // MVC
  private let controller = ChatController()
  private unowned var model: ChatModel { get { return controller.model } }
  
  // private vars
  private let incomingBubble = JSQMessagesBubbleImageFactory()
    .incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
  private let outgoingBubble = JSQMessagesBubbleImageFactory()
    .outgoingMessagesBubbleImageWithColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0))
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupDataBinding()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  private func setupDataBinding() {
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
      if isSent { self?.finishSendingMessage() }
    }
    // listen for changes in the 'didReceiveMessage'
    // if 'didReceive' is true, update the UI
    controller.didReceiveMessage.listen(self) { [weak self] didReceive in
      if didReceive { self?.finishReceivingMessage() }
    }
  }
  
  public override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    // tell the controller the 'send' button was pressed, then pass in the data
    controller.didPressSendButton(text)
  }
  
  public override func didPressAccessoryButton(sender: UIButton!) {}
  
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    if indexPath.row % 5 == 0 { return 24 }
    else { return 0 }
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
    if indexPath.row % 5 == 0 { return NSAttributedString(string: NSDate().toLongTimeString()) }
    else { return nil }
  }
  
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return 24
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
    return model.messages[indexPath.row].senderId == senderId ?
      NSAttributedString(string: model.user!.getFullName()!)  : NSAttributedString(string: model.friend!.getFullName()!)
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


