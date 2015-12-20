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
    tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
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
          let _ = model.chat[indexPath.row].user,
          let _ = model.chat[indexPath.row].friend
          else { return UITableViewCell() }
    return cell
  }
}

public class ChatListViewCell: UITableViewCell {
  
}