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
import Toucan

public class ChatHistoryView: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
  // MVC
  private let controller = ChatHistoryController()
  private unowned var model: ChatHistoryModel { get { return controller.model } }

  private var tableView: UITableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupDataBinding()
    setupView()
    setupTableView()
  }
  
  private func setupView() {
    view.backgroundColor = UIColor.whiteColor()
  }
  
  private func setupTableView() {
    tableView = UITableView()
    tableView?.registerClass(ChatListViewCell.self, forCellReuseIdentifier: "cell")
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.separatorStyle = .None
    view.addSubview(tableView!)
    tableView?.reloadData()
  }
  
  private func setupDataBinding() {
    controller.get_Chat().listen(self) { [weak self] chat in
      self?.tableView?.reloadData()
    }
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return controller.getChat().count
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 48 + 16
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? ChatListViewCell,
          let friend = controller.getChat()[indexPath.row].friend,
          let book = controller.getChat()[indexPath.row].book
    else { return UITableViewCell() }
    
    cell.usernameLabel?.text = friend.username
    cell.bookTitleLabel?.text = book
    cell.lastchatLabel?.text = controller.getChat()[indexPath.row].messages.last?.text
    cell.profileImageView?.image = Toucan(image: UIImage(named: friend.avatar!)!)
        .resizeByCropping(cell.profileImageView!.frame.size)
        .maskWithEllipse()
        .image
    
    return cell
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView?.fillSuperview()
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    navigationController?.pushViewController(ChatView(), animated: true)
  }
}



extension UIColor {
  
  public class func sexyGray(alpha: CGFloat? = nil) -> UIColor {
    if let alpha = alpha {
      return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: alpha)
    } else {
      return UIColor(red: 153/255, green: 153/255, blue: 153/255, alpha: 1.0)
    }
  }
  
  public class func soothingBlue(alpha: CGFloat? = nil) -> UIColor {
    if let alpha = alpha {
      return UIColor(red: 59/255, green: 92/255, blue: 156/255, alpha: alpha)
    } else {
      return UIColor(red: 59/255, green: 92/255, blue: 156/255, alpha: 1.0)
    }
  }
  
  public class func bareBlue(alpha: CGFloat? = nil) -> UIColor {
    if let alpha = alpha {
      return UIColor(red: 49/255, green: 77/255, blue: 122/255, alpha: alpha)
    } else {
      return UIColor(red: 49/255, green: 77/255, blue: 122/255, alpha: 1.0)
    }
  }
  
  public class func flashyYellow(alpha: CGFloat? = nil) -> UIColor {
    if let alpha = alpha {
      return UIColor(red: 249/255, green: 198/255, blue: 118/255, alpha: alpha)
    } else {
      return UIColor(red: 249/255, green: 198/255, blue: 118/255, alpha: 1.0)
    }
  }
  
  public class func juicyOrange(alpha: CGFloat? = nil) -> UIColor {
    if let alpha = alpha {
      return UIColor(red: 240/255, green: 139/255, blue: 35/255, alpha: alpha)
    } else {
      return UIColor(red: 240/255, green: 139/255, blue: 35/255, alpha: 1.0)
    }
  }
}


extension UIFont {
  public class func helvetica(size: CGFloat) -> UIFont? {
    return UIFont(name: "HelveticaNeue", size: size)
  }
}








