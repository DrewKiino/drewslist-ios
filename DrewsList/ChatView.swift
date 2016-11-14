//
//  ChatView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/13/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit
import SwiftyTimer
import Neon
import SwiftDate

public class ChatView: UIViewController {
  
  public var model: ChatView.Model! = ChatView.Model()
  
  // dynamic vars
  private var keyboardHeight: CGFloat = 0
  
  // views
  private var tableView: UITableView! = UITableView()
  private var refreshControl: UIRefreshControl! = UIRefreshControl()
  private var inputContainer: ChatView.Models.InputContainer! = ChatView.Models.InputContainer()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .whiteColor()
    
    // setup table view
    tableView?.separatorColor = .clearColor()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.estimatedRowHeight = 36
    tableView?.rowHeight = UITableViewAutomaticDimension
    tableView?.layer.masksToBounds = false
    tableView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.dismissKeyboard)))
    tableView?.registerClass(ChatView.Models.MessageCell.self, forCellReuseIdentifier: "MessageCell")
    view.addSubview(tableView!)
    
    // setup refresh control
    refreshControl?.addTarget(self, action: #selector(self.refresh(_:)), forControlEvents: .ValueChanged)
    tableView?.addSubview(refreshControl!)
    
    // setup input container
    inputContainer?.textFieldDidBeginEditingBlock = {
    }
    inputContainer?.textFieldDidEndEditingBlock = {
    }
    inputContainer?.sendButtonOnPressBlock = { [weak self] button, text in
      if let timestamp = NSDate().toString(.ISO8601), index = self?.model.messages.count {
        let message = ChatView.Models.Message(text: text, username: "Andrew", userImageUrl: "https://scontent.xx.fbcdn.net/v/t1.0-9/14591735_1511814525502034_3185729889037997947_n.jpg?oh=3e3514bc903aaa9b21d7e181dcba20b9&oe=58CE5893", timestamp: timestamp, message_id: index.description)
        ChatManager.appendMessage(index: index, message: message.toDictionary())
      }
    }
    
    view.addSubview(inputContainer!)
    
    fetchData()
  }
  
  public func fetchData() {
    ChatManager.fetch() { [weak self] messages in
      self?.model.messages = messages
      self?.tableView.reloadData()
    }
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    setObservers()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    unsetObservers()
  }
  
  public func setObservers() {
    unsetObservers()
    KeyboardManager.keyboardWillHideSignal.listen(self) { [weak self] in
      self?.keyboardHeight = 0
      self?.viewWillLayoutSubviews()
    }
    KeyboardManager.keyboardWillShowSignal.listen(self) { [weak self] rect in
      self?.keyboardHeight = rect.height
      self?.viewWillLayoutSubviews()
    }
//    FireBaseManager.listen() { [weak self] dictionary in
//      if let items = dictionary["messages"] as? [[String: AnyObject]] {
//        let messages = items.flatMap({ item -> ChatView.Models.Message? in
//          if let
//            text = item["text"] as? String,
//            username = item["username"] as? String,
//            userImageUrl = item["userImageUrl"] as? String,
//            timestamp = item["timestamp"] as? String
//          {
//            let message = ChatView.Models.Message(text: text, username: username, userImageUrl: userImageUrl, timestamp: timestamp)
//            return message
//          } else {
//            return nil
//          }
//        })
//        self?.model.messages = messages
//        self?.tableView.reloadData()
//      }
//    }
  }
  
  public func unsetObservers() {
    KeyboardManager.keyboardWillHideSignal.removeListener(self)
    KeyboardManager.keyboardWillShowSignal.removeListener(self)
    FireBaseManager.removeListener()
  }
  
  // setup layout
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    inputContainer?.hidden = false
    inputContainer?.anchorToEdge(
      .Bottom,
      padding: keyboardHeight,
      width: view.frame.width,
      height: 48
    )
    
    tableView?.alignAndFill(align: .AboveCentered, relativeTo: inputContainer!, padding: 0)
    
    inputContainer?.layer.shadowColor = UIColor.blackColor().CGColor
    inputContainer?.layer.shadowOpacity = 0.05
    inputContainer?.layer.shadowOffset = CGSizeMake(0, -1)
    inputContainer?.layer.shadowRadius = 1.0
    inputContainer?.layer.masksToBounds = false
  }
  
  public func dismissKeyboard() {
    inputContainer?.inputTextField?.resignFirstResponder()
  }
  
  // MARK: class methods
  
  public func append(message: ChatView.Models.Message) -> Self {
    model.messages.insert(message, atIndex: 0)
    return self
  }
  
  public func reload() -> Self {
    tableView?.reloadData()
    return self
  }
  
  public func simulateReceivedMessage(scroll: Bool = true, invertScroll: Bool = false, animated: Bool = true, delay: Double = 0.0) {
    reload()
    refreshControl?.endRefreshing()
    if invertScroll && scroll {
      scrollToMostLatest(animated, delay: delay)
    } else if scroll {
      scrollToMostRecent(animated, delay: delay)
    }
  }
  
  public func scrollToMostLatest(animated: Bool = true, delay: Double = 0.0) {
    if model.messages.isEmpty { return }
    if delay > 0 {
      NSTimer.after(delay) { [weak self] in
        self?.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: animated)
      }
    } else {
      tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: .Top, animated: animated)
    }
  }
  
  public func scrollToMostRecent(animated: Bool = true, delay: Double = 0.0) {
    if model.messages.isEmpty { return }
    if delay > 0 {
      NSTimer.after(delay) { [weak self] in
        self?.tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: (self?.model.messages.count ?? 1) - 1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
      }
    } else {
      tableView?.scrollToRowAtIndexPath(NSIndexPath(forRow: model.messages.count - 1, inSection: 0), atScrollPosition: .Bottom, animated: animated)
    }
  }
  
  
  private func getBubbleColor(indexPath: NSIndexPath) -> UIColor {
    return model.messages[indexPath.row].username == model.username
      ? UIColor(red: 0/255, green: 255/255, blue: 127/255, alpha: 0.1)
      : UIColor(red: 0/255, green: 191/255, blue: 255/255, alpha: 0.1)
  }
  
  private func updateTimestampUI(cell: ChatView.Models.MessageCell, indexPath: NSIndexPath) {
    
    cell.timestampLabel?.hidden = false
    
    if let messageDate: NSDate = model.messages[indexPath.row].timestamp?.toDateFromISO8601()
      where model.messages.count > 1 && indexPath.row + 1 < model.messages.count
    {
      if let futureMessageDate: NSDate = model.messages[indexPath.row + 1].timestamp?.toDateFromISO8601() {
        cell.timestampLabel?.hidden = true
        if futureMessageDate - 1.minutes > messageDate {
          cell.timestampLabel?.hidden = false
          cell.timestampLabel?.text = model.messages[indexPath.row].timestamp?.toDateFromISO8601()?
            .toSimpleString(!messageDate.isInToday() ? .ShortStyle : .NoStyle, timeStyle: .ShortStyle)
        }
      }
    }
    
    if indexPath.row == 0 {
      cell.timestampLabel?.hidden = false
    }
  }
  
  private func isConsecutiveMessage(indexPath: NSIndexPath) -> Bool {
    if model.messages.count > 1 && indexPath.row > 0 {
      return model.messages[indexPath.row].username == model.messages[indexPath.row - 1].username
    }
    return false
  }
  
  private func isLastConsecutiveMessage(indexPath: NSIndexPath) -> Bool {
    if model.messages.count > 1 && indexPath.row < model.messages.count - 1 {
      return model.messages[indexPath.row].username != model.messages[indexPath.row + 1].username
    }
    return false
  }
  
  public func refresh(sender: UIRefreshControl) {
    getMessages(model.messages.count, invertScroll: true)
  }
}

extension ChatView: UITableViewDelegate, UITableViewDataSource {
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    if !model.messages.isEmpty {
      let height: CGFloat = model.messages[indexPath.row].text?.height(view.frame.width - 128) ?? 0
      if isConsecutiveMessage(indexPath) {
        return max(height, 36)
      } else {
        return max(height + (height > 36 ? 36 : 33), 64)
      }
    }
    return 64
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.messages.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("MessageCell", forIndexPath: indexPath) as? ChatView.Models.MessageCell
      where !model.messages.isEmpty
    {
      
      cell.message = model.messages[indexPath.row]
      
      cell.textLabel?.text = model.messages[indexPath.row].text
      cell.usernameLabel?.text = model.messages[indexPath.row].username
      cell.userImageUrl = model.messages[indexPath.row].userImageUrl
      cell.timestampLabel?.text = model.messages[indexPath.row].timestamp?.toDateFromISO8601()?.toSimpleString()
      
      cell.containerView?.backgroundColor = getBubbleColor(indexPath)
      
      cell.isConsecutiveMessage = isConsecutiveMessage(indexPath)
      cell.isLastConsecutiveMessage = isLastConsecutiveMessage(indexPath)
      cell.isLastMessage = model.messages.count - 1 == indexPath.row
      
      updateTimestampUI(cell, indexPath: indexPath)
      
      cell.hidden = cell.message?.hidden == true
      
      return cell
    }
    return UITableViewCell()
  }
}







// Chat Methods
extension ChatView {
  public func sendMessage(message: ChatView.Models.Message) {
    model.pendingMessages.append(message)
    model.messages.append(message)
  }
  public func getMessages(skip: Int, invertScroll: Bool = false, completionHandler: (() -> Void)? = nil) {
    ChatManager.fetch(skip: model.messages.count, invertSort: true) { [weak self] messages in
      messages.forEach { [weak self] in
        self?.model.messages.insert($0, atIndex: 0)
      }
      self?.tableView.reloadData()
      self?.refreshControl.endRefreshing()
    }
  }
}

extension ChatView: UITextFieldDelegate {
}






public class MessageCell: UITableViewCell {
}

extension ChatView {
  
  
  public class Model {
    
    public var users: [ChatView.Models.User] = []
    
    private var username: String?
    private var userImageUrl: String?
    
    private var room: String?
    private var session_id: String?
    
    private var messages: [ChatView.Models.Message] = []
    private var pendingMessages: [ChatView.Models.Message] = []
  }
  
  public struct Models {
    
    // Data
    
    // Input Container
    
    internal class InputContainer: BasicView, UITextFieldDelegate {
      
      private var originalFrame: CGRect?
      
      private var inputTextField: UITextField?
      private var sendButton: UIButton?
      
      private var textFieldDidBeginEditingBlock: (() -> Void)?
      private var textFieldDidEndEditingBlock: (() -> Void)?
      private var sendButtonOnPressBlock: ((sender: UIButton, text: String) -> Void)?
      
      internal override func setup() {
        super.setup()
        
        backgroundColor = .whiteColor()
        
        inputTextField = UITextField()
        inputTextField?.delegate = self
        inputTextField?.font = ChatView.Config.font
        inputTextField?.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        inputTextField?.layer.borderColor = UIColor(white: 0, alpha: 0.5).CGColor
        inputTextField?.layer.borderWidth = 0.5
        inputTextField?.layer.cornerRadius = 5.0
        addSubview(inputTextField!)
        
        sendButton = UIButton()
        sendButton?.setTitle("Send", forState: .Normal)
        sendButton?.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
        sendButton?.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.5), forState: .Highlighted)
        sendButton?.addTarget(self, action: #selector(self.sendButtonPressed(_:)), forControlEvents: .TouchUpInside)
        addSubview(sendButton!)
      }
      
      internal override func layoutSubviews() {
        super.layoutSubviews()
        
        originalFrame = frame
        
        sendButton?.anchorToEdge(.Right, padding: 8, width: 48, height: 24)
        inputTextField?.alignAndFillWidth(align: .ToTheLeftCentered, relativeTo: sendButton!, padding: 8, height: 24)
      }
      
      internal func sendButtonPressed(sender: UIButton) {
        if let text = inputTextField?.text where !text.isEmpty {
          sendButtonOnPressBlock?(sender: sender, text: text)
          inputTextField?.text = nil
        }
      }
      
      internal func disableSendButton() {
        sendButton?.userInteractionEnabled = false
        sendButton?.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Highlighted)
        sendButton?.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.5), forState: .Normal)
      }
      
      internal func enableSendButton() {
        sendButton?.userInteractionEnabled = true
        sendButton?.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 1), forState: .Normal)
        sendButton?.setTitleColor(UIColor(red: 0, green: 122/255, blue: 1, alpha: 0.5), forState: .Highlighted)
      }
      
      // MARK: textfield methods
      
      internal func textFieldDidBeginEditing(textField: UITextField) {
        textFieldDidBeginEditingBlock?()
      }
      
      internal func textFieldDidEndEditing(textField: UITextField) {
        textFieldDidEndEditingBlock?()
      }
    }
    
    // MARK: User
    
    public class User {
      
      public var username: String?
      public var userImageUrl: String?
      
      public init(username: String?, userImageUrl: String?) {
        self.username = username
        self.userImageUrl = userImageUrl
      }
    }
    
    // MARK: Message
    
    public class Message {
      
      public var session_id: String?
      
      public var message_id: String?
      public var text: String?
      public var username: String?
      public var userImageUrl: String?
      public var timestamp: String?
      public var room: String?
      
      public var pending: Bool = false
      public var hidden: Bool = false
      
      public init(
        text: String?,
        username: String?,
        userImageUrl: String?,
        timestamp: String? = nil,
        message_id: String? = nil,
        session_id: String? = nil,
        room: String? = nil
        ) {
        self.text = text
        self.userImageUrl = userImageUrl
        self.username = username
        self.timestamp = timestamp ?? NSDate().toString(.ISO8601Format(.Full))
        self.message_id = message_id ?? abs(NSDate().hashValue).description
        self.session_id = session_id ?? UIDevice.currentDevice().identifierForVendor?.UUIDString ?? nil
        self.room = room
      }
      
      public func toDictionary() -> [String: AnyObject] {
        let message_id: String = self.message_id ?? ""
        let text: String = self.text ?? ""
        let username: String = self.username ?? ""
        let userImageUrl: String = self.userImageUrl ?? ""
        let timestamp: String = self.timestamp ?? NSDate().toString(.ISO8601Format(.Full)) ?? ""
        let session_id: String = self.session_id ?? ""
        let room: String = self.room ?? ""
        return [
          "message_id": message_id,
          "text": text,
          "username": username,
          "userImageUrl": userImageUrl,
          "timestamp": timestamp,
          "session_id": session_id,
          "room": room
          ] as [String: AnyObject]
      }
    }
    
    // MARK: Message Cell
    
    public class MessageCell: BasicCell {
      
      public var containerView: UIView! = UIView()
      
      public var usernameLabel: UILabel! = UILabel()
      public var userImageView: UIImageView! = UIImageView()
      public var timestampLabel: UILabel! = UILabel()
      
      public var userImageUrl: String?
      
      public var isConsecutiveMessage: Bool = false
      public var isLastConsecutiveMessage: Bool = false
      public var isLastMessage: Bool = false
      
      public var message: ChatView.Models.Message?
      
      public override func setup() {
        super.setup()
        
        backgroundColor = .clearColor()
        
        containerView?.backgroundColor = .whiteColor()
        addSubview(containerView!)
        
        containerView?.layer.cornerRadius = 12.0
        containerView?.layer.masksToBounds = true
        
        // MARK: setup username label
        usernameLabel?.font = UIFont.boldSystemFontOfSize(12)
        usernameLabel?.textAlignment = .Right
        containerView?.addSubview(usernameLabel!)
        
        // MARK: setup timestamp label
        timestampLabel?.font = UIFont.systemFontOfSize(10)
        timestampLabel?.textColor = .lightGrayColor()
        timestampLabel?.textAlignment = .Right
        timestampLabel?.numberOfLines = 2
        addSubview(timestampLabel!)
        
        // MARK: setup user image view
        containerView?.addSubview(userImageView!)
        
        // MARK: setup text label
        textLabel?.numberOfLines = 0
        textLabel?.font = ChatView.Config.font
        addSubview(textLabel!)
        
        layer.masksToBounds = false
        
        sendSubviewToBack(containerView!)
      }
      
      public override func layoutSubviews() {
        super.layoutSubviews()
        
        timestampLabel?.anchorInCorner(.TopRight, xPad: 8, yPad: 8, width: 48, height: 48)
        timestampLabel?.frame.origin.y -= 17
        
        containerView?.fillSuperview(left: 8, right: 8, top: 4, bottom: 4)
        
        textLabel?.frame = CGRectMake(16, 8 + (isConsecutiveMessage ? 0 : 32), frame.width - 76, frame.height)
        textLabel?.sizeToFit()
        
        usernameLabel?.hidden = isConsecutiveMessage
        userImageView?.hidden = isConsecutiveMessage
        
        if isConsecutiveMessage {
          
          let textViewWidth: CGFloat = max(min(textLabel?.frame.width ?? 0, (textLabel?.text?.width(frame.height - 36, font: ChatView.Config.font) ?? 0)) + 16, 20)
          let threshold: Bool = textViewWidth > (timestampLabel?.frame.origin.x ?? 0)
          let thresholdWidth: CGFloat = (threshold ? (containerView?.frame.width ?? 0) - (timestampLabel?.frame.width ?? 0) : textViewWidth)
          
          containerView?.anchorAndFillEdge(.Left, xPad: 8, yPad: 4, otherSize: min(textViewWidth, thresholdWidth))
          
        } else {
          
          userImageView?.anchorInCorner(.TopLeft, xPad: 8, yPad: 8, width: 24, height: 24)
          userImageView?.backgroundColor = .clearColor()
          
          let textViewWidth: CGFloat = max(min(textLabel?.frame.width ?? 0, (textLabel?.text?.width(frame.height - 36, font: ChatView.Config.font) ?? 0)) + 16, 20)
          let userImageViewWidth: CGFloat = (userImageView?.frame.width ?? 0) + 24
          let usernameLabelWidth: CGFloat = (usernameLabel?.text?.width(24, font: ChatView.Config.font) ?? 0) + 16
          
          usernameLabel?.align(.ToTheRightCentered, relativeTo: userImageView, padding: 4, width: usernameLabelWidth, height: 24)
          
          containerView?.anchorAndFillEdge(.Left, xPad: 8, yPad: 4, otherSize: max(userImageViewWidth + usernameLabelWidth, textViewWidth))
          
          userImageView?.imageFromSource(userImageUrl, placeholder: UIImage(named: "placeholder-image.png"), fitMode: .Crop, mask: .Rounded)
        }
      }
    }
  }
}

extension ChatView {
  // convenient config vars that affect the entire class settings
  public struct Config {
    public static var limit: Int = 10
    public static var page: Int = 1
    public static var font: UIFont = UIFont.systemFontOfSize(14)
  }
}





