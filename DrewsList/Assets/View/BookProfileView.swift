//
//  BookProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals
import Cosmos


public class BookProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource {


  private let controller = BookProfileController()
  private var model: BookProfileModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setUpTableView()
    setupDataBinding()
 
  }
  
  public override func viewWillAppear(animated: Bool) {
  }
  
  public override func viewWillDisappear(animated: Bool) {
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView?.fillSuperview()
  }
  
  // MARK: setup view functions
  
  public func setUpTableView(){
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  
  // MARK: private functions
  
  private func setupDataBinding() {
    // setup view's databinding
    model._book.listen(self) { [weak self] book in
       print(self?.model.book?.title)
      self?.tableView!.reloadData()
    }
    // setup controller's databinding
    controller.setBookID("56728eafa0e9851f007e7850")
    controller.getBookFromServer()
  }
  
  public func setBook(book: Book?) {
    guard let book = book else { return }
    model.book = book
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 10
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.fillSuperview(left: screen.width / 25, right: 0, top: 10, bottom: 0)
        if model.book?.authors.first?.name != nil {
          cell.titleLabel?.text = model.book?.authors.first?.name
        } else { cell.titleLabel?.text = "Author"}
        cell.titleLabel?.font = .asapItalic(12)
        return cell
      }
      break;
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
        if model.book?.title != nil {
          cell.titleLabel?.text = model.book?.title
        } else { cell.titleLabel?.text = "Title of Book" }
        cell.titleLabel?.font = .asapBold(20)
        return cell
      }
      break;
      
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell {
        cell.backgroundColor = .whiteColor()
        let view = CosmosView()
        view.rating = 3.3
        view.settings.fillMode = .Precise
        view.settings.borderColorEmpty = .juicyOrange()
        view.settings.colorFilled = .juicyOrange()
        view.anchorAndFillEdge(.Left, xPad: screen.width / 30, yPad: 0, otherSize: 150)
        cell.addSubview(view)

        return cell
      }
      break;
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell {
        cell.backgroundColor = .whiteColor()
        let bookImageView = UIImageView()
        let bookImage = Toucan(image: UIImage(named: "book-placeholder"))
          .resize(CGSize(width: cell.frame.height * (2 / 3), height: cell.frame.height), fitMode: Toucan.Resize.FitMode.Clip).image
        bookImageView.image = bookImage
        cell.addSubview(bookImageView)
        bookImageView.anchorInCenter(width: cell.frame.height * (2 / 3), height: cell.frame.height)

        return cell
      }
      break;
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.backgroundColor = .whiteColor()
        cell.showSeparatorLine()
        cell.hideBothTopAndBottomBorders()
        let isbnLabel = UILabel()
        isbnLabel.font = .asapBold(15)
        isbnLabel.textColor = .sexyGray()
        //var attributedString =
        let attributes = [NSFontAttributeName: UIFont.asapBold(15)]
        var attributedString = NSAttributedString(string: "ISBN(S): ", attributes: attributes)
        
        isbnLabel.text = attributedString.string
        let coverLabel = UILabel()
        coverLabel.font = .asapBold(15)
        coverLabel.textColor = .sexyGray()
        coverLabel.text = "Cover: "
        
        
       
        
        cell.addSubview(isbnLabel)
        cell.addSubview(coverLabel)
        //isbnLabel.anchorAndFillEdge(.Top, xPad: screen.width / 20, yPad: 0, otherSize: screen.height / 10)
        //isbnLabel
        //coverLabel.sizeToFit()
        
        cell.groupInCorner(group: .Vertical, views: [isbnLabel, coverLabel], inCorner: .TopLeft, padding: screen.width / 30, width: screen.width, height: screen.height / 40)
        
        
        
        
//        let isbnLabel = UILabel()
//        let isbnLabel = UILabel()
//        let isbnLabel = UILabel()
//        let isbnLabel = UILabel()
//        let isbnLabel = UILabel()
//        let isbnLabel = UILabel()

        cell.selectionStyle = .None
        
        return cell
      }
      break;
    default:
      break;
    }
    
    cell.textLabel?.textColor = UIColor.lightGrayColor()
    cell.textLabel?.font = UIFont.asapRegular(14)
    return cell
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    if (indexPath.row == 0){
//      return screen.height / 3
//    } else {
//      return screen.height / 15
//    }
    
    switch (indexPath.row) {
    case 0:
      return screen.height / 25
    case 3:
      return screen.height / 3
//    case 2:
//      break;
    default:
      return screen.height / 25
    
    }
  }
  
  
}