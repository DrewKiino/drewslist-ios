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
import Haneke

public class ChatHistoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // MVC
  private let controller = ChatHistoryController()
  private unowned var model: ChatHistoryModel { get { return controller.model } }

  private var tableView: UITableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setup()
    setupTableView()
  }
  
  private func setup() {
    view.backgroundColor = UIColor.whiteColor()
  }
  
  private func setupTableView() {
    tableView = UITableView(frame: view.frame)
    tableView?.registerClass(ChatListViewCell.self, forCellReuseIdentifier: "cell")
    tableView?.delegate = self
    tableView?.dataSource = self
  }
  
  private func setupDataBinding() {
    
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.chat.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("cell"),
          let user = model.chat[indexPath.row].user,
          let friend = model.chat[indexPath.row].friend
          else { return UITableViewCell() }
    return cell
  }
}

public class ChatListViewCell: UITableViewCell {
  
  public var profileImageView: UIImageView?
  public var usernameLabel: UILabel?
  public var bookTitleLabel: UILabel?
  public var lastchatLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  
}

















