//
//  ChatHistoryController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 11/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import RealmSwift

public class ChatHistoryController {
  
  private let socket = Sockets.sharedInstance()
  
  public let model = ChatHistoryModel()
  private let _didUpdateChat = ActivityFeedController.shared_didUpdateChat()
  
  public init() {
    setupSelf()
    setupDataBinding()
    setupSockets()
  }
  
  private func setupSelf() {
  }
  
  public func viewDidAppear() {
    loadChatHistory()
  }
  
  private func setupDataBinding() {
    _didUpdateChat.removeListener(self)
    _didUpdateChat.listen(self) { [weak self] bool in
      self?.loadChatHistory()
    }
  }
  
  private func setupSockets() {
    socket._message.removeListener(self)
    socket._message.listen(self) { [weak self] json in
    }
  }
  
  public func loadChatHistory() {
    model.chatModels = try! Realm().objects(RealmChatHistory.self).map { $0.getChatModel() }
  }
  
  // MARK: Realm Functions
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(self.model.user), update: true) } }
}