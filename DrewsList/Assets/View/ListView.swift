//
//  ListView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Gifu
import Toucan
import Haneke

public class ListView: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = ListController()
  
  private var tableView: UITableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    setupTableView()
    
    view.backgroundColor = UIColor.whiteColor()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  public func setLister(lister: User?) -> Bool {
    guard let lister = lister else { return false }
    
    // fixtures
    //    controller.getBookFromServer("567073b150b85819778201e6")
    
    controller.setLister(lister)
    
    return true
  }
  
  public func setUserFromServer(user_id: String?) -> Bool {
    guard let user_id = user_id else { return false }
    
    // fixtures
    //    controller.getBookFromServer("567073b150b85819778201e6")
    return true
  }
  
  public func setBook(book: Book?) -> Bool {
    guard let book = book else { return false }
    
    controller.setBook(book)
  
    return true
  }
  
  public func setBookFromServer(book_id: String?) -> Bool {
    guard let book_id = book_id else { return false }
    
    controller.getBookFromServer(book_id)
    
    // fixtures
    //    controller.getBookFromServer("567073b150b85819778201e6")
    return true
  }
  
  private func setupTableView() {
    tableView = UITableView()
    tableView?.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView?.registerClass(BookViewCell.self, forCellReuseIdentifier: "BookViewCell")
    tableView?.registerClass(ListerProfileViewCell.self, forCellReuseIdentifier: "ListerProfileViewCell")
    tableView?.registerClass(ListerAttributesViewCell.self, forCellReuseIdentifier: "ListerAttributesViewCell")
    tableView?.dataSource = self
    tableView?.delegate = self
    view.addSubview(tableView!)
  }
  
  private func setupDataBinding() {
  }
  
  // MARK: UITableView Delegates 
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 158
    case 1: return 64
    case 2: return 200
    default: return 0
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
    // get cell
    let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath)
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        // clear seperator lines
        cell.subviews.forEach { if let _ = $0 as? BookView { return } else { $0.removeFromSuperview() } }
        cell.bookView?.setBook(controller.getBook())
        // databind cell
        controller.get_Book().removeListener(self)
        controller.get_Book().listen(self) { [weak cell] book in
          cell?.bookView?.setBook(book)
        }
      }
      return cell
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ListerProfileViewCell", forIndexPath: indexPath) as? ListerProfileViewCell {
        cell.setLister(controller.getLister())
        // databind cell
        controller.get_Lister().removeListener(self)
        controller.get_Lister().listen(self) { [weak cell] lister in
          cell?.setLister(lister)
        }
      }
      return cell
    case 2:
      return cell
    default: return cell
    }
  }
}

public class BookViewCell: UITableViewCell {
  
  private var bookView: BookView? = BookView()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(bookView!)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    bookView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 150)
  }
}

public class ListerProfileViewCell: UITableViewCell {
  
  private var userImageView: UIImageView?
  private var nameLabel: UILabel?
  private var listDateLabel: UILabel?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUserImage()
    setupNameLabel()
    setupListDateLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    userImageView?.anchorInCorner(.TopLeft, xPad: 16, yPad: 16, width: 32, height: 32)

    nameLabel?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: userImageView!, padding: 8, width: 100)

    listDateLabel?.anchorInCorner(.TopRight, xPad: 8, yPad: 8, width: 100, height: 48)
  }
  
  private func setupUserImage() {
    userImageView = UIImageView()
    addSubview(userImageView!)
  }
  
  private func setupNameLabel() {
    nameLabel = UILabel()
    nameLabel?.font = UIFont.asapRegular(16)
    nameLabel?.textColor = UIColor.juicyOrange()
    nameLabel?.adjustsFontSizeToFitWidth = true
    nameLabel?.minimumScaleFactor = 0.8
    addSubview(nameLabel!)
  }
  
  private func setupListDateLabel() {
    listDateLabel = UILabel()
    addSubview(listDateLabel!)
  }
  
  public func setLister(lister: User?) {
    guard let lister = lister else { return }
    
    if let url = lister.image, let nsurl = NSURL(string: url) {
      userImageView?.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "ListView_User_Images", diskCapacity: 10 * 1024 * 1024) { [unowned self] image in
        return Toucan(image: image).resize(self.userImageView!.frame.size, fitMode: .Crop).maskWithEllipse().image
      })
    }
    
    nameLabel?.text = lister.username ?? lister.getName()
    
  }
}

public class ListerAttributesViewCell: UITableViewCell {
  
  private var priceLabel: UILabel?
  private var conditionLabel: UILabel?
  private var notesLabel: UILabel?
  
  private var chatButton: UIButton?
  private var callButton: UIButton?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    priceLabel?.anchorInCorner(.TopLeft, xPad: 8, yPad: 8, width: 100, height: 24)
    priceLabel?.backgroundColor = UIColor.redColor()

  }
  
  private func setupPriceLabel() {
    priceLabel = UILabel()
    addSubview(priceLabel!)
  }
  
  private func setupChatButton() {
    chatButton = UIButton()
    addSubview(chatButton!)
  }
  
  private func setupCallButton() {
    callButton = UIButton()
    addSubview(callButton!)
  }
}

















