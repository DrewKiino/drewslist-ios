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
import Async


public class BookProfileView: UIViewController, UITableViewDelegate, UITableViewDataSource {

  private let controller = BookProfileController()
  private var model: BookProfileModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds
  private var tableView: DLTableView?
  
//  init(bookID: String) {
//    setBook(Book(_id: "5692cdab8b12dd1f000ee63c"))
//  }
//
//  required public init?(coder aDecoder: NSCoder) {
//      fatalError("init(coder:) has not been implemented")
//  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    // MARK: Fixtures
    // setup controller's databinding
    title = "Book Profile"
    setUpTableView()
    setupDataBinding()
    
    controller.viewDidLoad()
    
    FBSDKController.createCustomEventForName("UserBookProfile")
  }
  
  public override func viewWillAppear(animated: Bool) {
    tableView?.rowHeight = UITableViewAutomaticDimension
    tableView?.reloadData()
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
    tableView?.rowHeight = UITableViewAutomaticDimension
    
    view.addSubview(tableView!)
  }
  
  
  // MARK: private functions
  
  private func setupDataBinding() {
    // setup view's databinding
    model._book.listen(self) { [weak self] book in
      self?.tableView!.rowHeight = UITableViewAutomaticDimension
      self?.tableView!.reloadData()
    }
    // setup controller's databinding
    controller.getBookFromServer()
  }
  
  public func setBook(book: Book?) -> Self {
    model.book = book
    return self
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 16
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
   // let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideTopBorder()
        cell.paddingLabel?.text = "About This Book"
        
        return cell
      }
      break;
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        return cell
      }
      break;
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.label?.text = model.book?.authors.first?.name ?? "Author"
        cell.label?.font = .asapItalic(12)
        return cell
      }
      break;
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.label?.text = model.book?.title ?? "Book"
        cell.label?.font = .asapBold(32)
        cell.label?.numberOfLines = 3
        cell.label?.minimumScaleFactor = 0.4
        return cell
      }
      break;
    case 4:
      if  let cell = tableView.dequeueReusableCellWithIdentifier("RatingsCell", forIndexPath: indexPath) as? RatingsCell {
        cell.set(rating: model.book?.averageRating)
      }
      break;
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell {
        cell.imageUrl = model.book?.getImageUrl()
        return cell
      }
      break;
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "ISBN:"
        cell.titleLabel?.font = .asapBold(12)
        cell.titleTextLabel?.text = model.book?.ISBN13 ?? model.book?.ISBN10
        cell.titleTextLabel?.textColor = .sexyGray()

        return cell
      }
      break;
    case 7:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Binding:"
        cell.titleLabel?.font = .asapBold(12)
        cell.titleTextLabel?.text = model.book?.binding
        
        return cell
      }
      break;
    case 8:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Edition:"
        cell.titleLabel?.font = .asapBold(12)
        cell.titleTextLabel?.text = model.book?.edition

        return cell
        
      }
      break;
    case 9:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Publisher:"
        cell.titleLabel?.font = .asapBold(12)
        cell.titleTextLabel?.text = model.book?.publisher
        cell.titleTextLabel?.textColor = .sexyGray()

        return cell
        
      }
      break;
    case 10:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Page Count:"
        cell.titleLabel?.font = .asapBold(12)
        cell.titleTextLabel?.text = String(model.book?.pageCount ?? 0)
        cell.titleTextLabel?.textColor = .sexyGray()
        
        return cell
      }
      break;
    case 11:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Categories:"
        cell.titleLabel?.font = .asapBold(12)
        cell.titleTextLabel?.text = model.book?.categories.first?.category ?? ""
        cell.titleTextLabel?.textColor = .sexyGray()
        
        return cell
      }
      break;
    case 12:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Maturity Rating:"
        cell.titleLabel?.font = .asapBold(12)
        cell.titleTextLabel?.text = model.book?.maturityRating
        cell.titleTextLabel?.textColor = .sexyGray()
        
        return cell
      }
      break;
      
    case 13:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        
        cell.titleLabel?.text = "Description:"
        cell.titleLabel?.font = .asapBold(12)
        
        return cell
      }
      
      break;
      
    case 14:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextViewCell", forIndexPath: indexPath) as? InputTextViewCell {
        cell.backgroundColor = .whiteColor()
        cell.inputTextView?.text = model.book?.description ?? "No description"
        cell.inputTextView?.textColor = .sexyGray()
        cell.inputTextView?.userInteractionEnabled = false
        
        return cell
      }
      break;
    case 15:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.hideBothTopAndBottomBorders()
        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.button?.buttonColor = .juicyOrange()
        cell.button?.cornerRadius = 4
        cell.button?.setTitle("Add Book to Wishlist", forState: .Normal)
        cell._onPressed.removeAllListeners()
        cell._onPressed.listen(self) { [weak self] bool in
          // FIXME: Add book to wishlist
          self?.presentCreateListingView(self?.model.book)
        }
        return cell
      }
      break;
    case 16:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBottomBorder()
        return cell
      }
      break;
    default: break;
    }
    return DLTableViewCell()
  }
  

  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch (indexPath.row) {
    case 1:
      return 16
    case 4:
      return 24
    case 5:
      return 200
    case 14:
      if let string = model.book?.description, let height: CGFloat = string.height(screen.width, paddingHeight: false) { return height }
    case 15:
      return 64
    default: break
    }
    return 18
  }
  
  public func presentCreateListingView(book: Book?) {
    presentViewController(CreateListingView().setBook(book), animated: true, completion: nil)
  }
}

public class RatingsCell: DLTableViewCell {
  
  private var cosmosView: CosmosView?
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    cosmosView?.fillSuperview(left: 8, right: 8, top: 0, bottom: 0)
  }
  
  public override func setupSelf() {
    super.setupSelf()
    backgroundColor = .whiteColor()
    setupRatingsView()
  }
  
  private func setupRatingsView() {
    cosmosView = CosmosView()
    cosmosView?.settings.fillMode = .Precise
    cosmosView?.settings.emptyBorderColor = .juicyOrange()
    cosmosView?.settings.filledBorderColor = .juicyOrange()
    addSubview(cosmosView!)
  }
  
  public func set(rating rating: Double?) {
    cosmosView?.rating = rating ?? 0.0
  }
}












