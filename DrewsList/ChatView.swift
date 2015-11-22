//
//  ChatView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import JSQMessagesViewController


public class ChatView: JSQMessagesViewController {
  
  var userName = ""
  var messages = [JSQMessage]()
  let incomingBubble = JSQMessagesBubbleImageFactory()
    .incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
  
  let outgoingBubble = JSQMessagesBubbleImageFactory()
    .outgoingMessagesBubbleImageWithColor(UIColor.lightGrayColor())
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    userName = "iPhone"
    for i in 1...10 {
      let sender = (i%2 == 0) ? "Syncano" : self.userName
      let message = JSQMessage(senderId: sender, displayName: sender, text: "text")
      self.messages += [message]
    }
    collectionView?.reloadData()
    senderDisplayName = self.userName
    senderId = self.userName
  }
  
  public override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    let newMessage = JSQMessage(senderId: senderId, displayName: senderDisplayName, text: text)
    messages += [newMessage]
    finishSendingMessage()
  }
  
  public override func didPressAccessoryButton(sender: UIButton!) {
    
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    let data = messages[indexPath.row]
    return data
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    let data = self.messages[indexPath.row]
    return data.senderId == senderId ? outgoingBubble : incomingBubble
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    return nil
  }
  
  public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return messages.count
  }
}


