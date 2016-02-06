//
//  ChatView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import SwiftDate

public class ChatView: JSQMessagesViewController {
  
  // MVC
  private let controller = ChatController()
  private unowned var model: ChatModel { get { return controller.model } }
  
  private var refreshControl: UIRefreshControl?
  
  // private vars
  private let incomingBubble = JSQMessagesBubbleImageFactory()
    .incomingMessagesBubbleImageWithColor(UIColor(red: 10/255, green: 180/255, blue: 230/255, alpha: 1.0))
  private let outgoingBubble = JSQMessagesBubbleImageFactory()
    .outgoingMessagesBubbleImageWithColor(UIColor(red: 76/255, green: 175/255, blue: 80/255, alpha: 1.0))
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupSelf()
    setupDataBinding()
    setupRefreshControl()
    controller.viewDidLoad()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    controller.viewDidAppear()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    controller.viewWillDisappear()
    
    collectionView?.hidden = true
    
    hideKeyboard()
    
    // load the chat history everytime the chat view is dismissed
    if let view = navigationController as? ChatHistoryView { view.loadChatHistory() }
  }
  
  private func setupSelf() {
    // set chat view title to friend's title
    title = model.friend?.getName()
    // hide attachment button
    inputToolbar?.contentView?.leftBarButtonItem?.hidden = true
  }
  
  private func setupDataBinding() {
    
    _applicationDidEnterBackground.removeListener(self)
    _applicationDidEnterBackground.listen(self) { [weak self] bool in
      self?.collectionView?.hidden = true
    }

    model._friend.removeAllListeners()
    model._friend.listen(self) { [weak self] friend in
      self?.title = friend?.getName()
    }
    // set and listen for changes in the user's username
    senderDisplayName = model.user?.username ?? ""
    model.user?._username.removeAllListeners()
    model.user?._username.listen(self) { [weak self] username in
      guard let username = username else { return }
      self?.senderDisplayName = username
    }
    // set and listen for changes in the user's _id
    senderId = model.user?._id ?? ""
    model.user?.__id.removeAllListeners()
    model.user?.__id.listen(self) { [weak self] _id in
      guard let _id = _id else { return }
      self?.senderId = _id
    }
    // listen for changes in the 'isSendingMessage'
    // if the controller is currently sending a message,
    // update the UI
    controller.willRequestSubscription.removeAllListeners()
    controller.willRequestSubscription.listen(self) { [weak self] willRequest in
      if willRequest {
        // show activity animation on nav bar
        DLNavigationController.showActivityAnimation(self)
      }
    }
    
    controller.didReceiveSubscriptionResponse.removeAllListeners()
    controller.didReceiveSubscriptionResponse.listen(self) { [weak self] didReceive in
      if didReceive {
        // show activity animation on nav bar
        DLNavigationController.hideActivityAnimation(self)
      }
    }
    
    controller.isSendingMessage.removeAllListeners()
    controller.isSendingMessage.listen(self) { [weak self] isSending in
      if isSending {
        self?.disableSendButton()
        // show activity animation on nav bar
        DLNavigationController.showActivityAnimation(self)
      }
    }
    // listen for changes in the 'didSendMessage'
    // if 'isSent' is true, update the UI
    controller.didSendMessage.removeAllListeners()
    controller.didSendMessage.listen(self) { [weak self] isSent in
      if isSent {
        self?.finishSendingMessage()
        // clear the text view's text
        self?.keyboardController.textView?.text = nil
        // allow the user to begin sending again
        self?.enableSendButton()
        // hide activity animation on nav bar
        DLNavigationController.hideActivityAnimation(self)
      }
    }
    // listen for changes in the 'didReceiveMessage'
    // if 'didReceive' is true, update the UI
    controller.didReceiveMessage.removeAllListeners()
    controller.didReceiveMessage.listen(self) { [weak self] didReceive in
      if didReceive { self?.finishReceivingMessage() }
    }
    controller.didRequestLoadingMessagesFromServer.removeAllListeners()
    controller.didRequestLoadingMessagesFromServer.listen(self) { [weak self] didRequest in
      if didRequest {
      }
    }
    controller.didLoadMessagesFromServer.removeAllListeners()
    controller.didLoadMessagesFromServer.listen(self) { [weak self] didReceive in
      
      if didReceive {
        
        self?.collectionView?.hidden = false
        
        self?.finishReceivingMessageAnimated(false)
        
        NSTimer.after(0.01) { [weak self] in
          if self?.controller.didPullToRefresh == false {
            
            self?.scrollToBottomAnimated(false)
            
          } else {
            
            self?.collectionView?.setContentOffset(CGPointZero, animated: true)
            
            self?.controller.didPullToRefresh = false
          }
        }
      }
      
      self?.refreshControl?.endRefreshing()
    }
  }
  
  private func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    collectionView?.addSubview(refreshControl!)
  }
  
  // MARK: UIRefreshControl methods
  
  public func refresh(sender: UIRefreshControl) {
    controller.didPullToRefresh = true
    controller.getChatHistoryFromServer(model.messages.count, paging: 10)
  }
  
  // MARK: JSQ delegate methods
  
  public override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
    // tell the controller the 'send' button was pressed, then pass in the data
    controller.didPressSendButton(text)
  }
  
  public override func didPressAccessoryButton(sender: UIButton!) {}
  
  // MARK: Collection View Delegates
  
  public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.messages.count
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
    // NOTE: returning nil here causes a crash
    // therefore, it is better to return an empty JSQMessage object
    return model.messages.isEmpty ? JSQMessage(senderId: "", displayName: "", text: "") : model.messages[indexPath.row]
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
    return model.messages.isEmpty ? nil : model.messages[indexPath.row].senderId == senderId ? outgoingBubble : incomingBubble
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
    return getJSQMessageAvatarImageDataSource(indexPath.row)
//    return indexPath.row > 0 ?
//      model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ? nil : getJSQMessageAvatarImageDataSource(indexPath.row)
//    : getJSQMessageAvatarImageDataSource(indexPath.row)
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
    return indexPath.row == (model.messages.count - 1) && indexPath.row > 0 && model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ?
      NSAttributedString(string: getDateString(indexPath.row))
      : indexPath.row > 0 ?
        model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ?
          nil
          : NSAttributedString(string: getBubbleTopText(indexPath.row))
        : NSAttributedString(string: getBubbleTopText(indexPath.row))
  }
  
  public override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
    return indexPath.row == (model.messages.count - 1) ?
      20
      : indexPath.row > 0 ?
          model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ? 0 : 20
        : 20
  }
  
//  public override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
//    return indexPath.row > 0 ?
//      model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ? nil : NSAttributedString(string: model.messages[indexPath.row].date.dl_toRelativeString() ?? "")
//    : NSAttributedString(string: model.messages[indexPath.row].date.dl_toRelativeString() ?? "")
//  }
//  
//  public override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
//    return indexPath.row > 0 ?
//      model.messages[indexPath.row - 1].senderId == model.messages[indexPath.row].senderId ? 1 : model.messages[indexPath.row].date.isToday() ? 24 : 1
//      : model.messages[indexPath.row].date.isToday() ? 24 : 1
//  }
  
  private func getJSQMessageAvatarImageDataSource(index: Int) -> JSQMessageAvatarImageDataSource {
    return model.messages.isEmpty ? nil : model.messages[index].senderId == senderId ?
      JSQMessagesAvatarImage(avatarImage: model.user_image, highlightedImage: nil, placeholderImage: UIImage(named: "profile-placeholder")) :
      JSQMessagesAvatarImage(avatarImage: model.friend_image, highlightedImage: nil, placeholderImage: UIImage(named: "profile-placeholder"))
  }
  
  private func getBubbleTopText(index: Int) -> String {
    return "\(model.messages.isEmpty ? "" : model.messages[index].senderId == model.user?._id ? model.user?.getName() ?? "" : model.friend?.getName() ?? "") (\(getDateString(index)))"
  }
  
  private func getDateString(index: Int) -> String {
    return model.messages[index].date.dl_toString() ?? ""
  }
  
  public func setUsers(user: User?, friend: User?) -> Self {
    
    model.user = user
    model.friend = friend
    
    return self
  }
  
  public func disableSendButton() {
    inputToolbar?.contentView?.rightBarButtonItem?.setTitleColor(.sexyGray(), forState: .Normal)
    inputToolbar?.contentView?.rightBarButtonItem?.userInteractionEnabled = false
  }
  
  public func enableSendButton() {
    inputToolbar?.contentView?.rightBarButtonItem?.setTitleColor(.buttonBlue(), forState: .Normal)
    inputToolbar?.contentView?.rightBarButtonItem?.userInteractionEnabled = true
  }
  
  
  // MARK: Show/Hide keyboard functions
  
  public func showKeyboard() { keyboardController.textView?.becomeFirstResponder() }
  public func hideKeyboard() { keyboardController.textView?.resignFirstResponder() }
}


