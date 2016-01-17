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
    if let book = book { model.book = book }
    return self
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 18
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
   // let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.fillSuperview(left: screen.width / 25, right: 0, top: 10, bottom: 0)
        if model.book?.authors.first?.name != nil {
          cell.titleLabel?.text = model.book?.authors.first?.name
          print(model.book?.authors.first?.name)
          print(model.book?.title)
          print(model.book?.largeImage)
      
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
      if  let cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell {
        let view = CosmosView()
        if let rating = model.book?.averageRating {
          view.rating = rating
        } else {
          view.rating = 0.0
        }
        cell.backgroundColor = .whiteColor()
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
        let duration: NSTimeInterval = 0.2
        if let bookImg = model.book?.largeImage {
          bookImageView.dl_setImageFromUrl(bookImg) { [weak self] image, error, cache, url in
            Async.background { [weak self] in
              // NOTE: correct way to handle memory management with toucan
              // init toucan and pass in the arguments directly in the parameter headers
              // do the resizing in the background
              var toucan: Toucan? = Toucan(image: image).resize(bookImageView.frame.size, fitMode: .Crop)
              Async.main { [weak self] in
                bookImageView.alpha = 0.0
                bookImageView.image = toucan?.image
                UIView.animateWithDuration(duration) { [weak self] in
                  bookImageView.alpha = 1.0
                }
                toucan = nil
              }
            }
          }
        } else if let bookImg = model.book?.mediumImage {
          bookImageView.dl_setImageFromUrl(bookImg) { [weak self] image, error, cache, url in
            Async.background { [weak self] in
              var toucan: Toucan? = Toucan(image: image).resize(bookImageView.frame.size, fitMode: .Crop)
              Async.main { [weak self] in
                bookImageView.alpha = 0.0
                bookImageView.image = toucan?.image
                UIView.animateWithDuration(duration) { [weak self] in
                  bookImageView.alpha = 1.0
                }
                toucan = nil
              }
            }
          }
        } else if let bookImg = model.book?.smallImage {
          bookImageView.dl_setImageFromUrl(bookImg) { [weak self] image, error, cache, url in
            Async.background { [weak self] in
              var toucan: Toucan? = Toucan(image: image).resize(bookImageView.frame.size, fitMode: .Crop)
              Async.main { [weak self] in
                bookImageView.alpha = 0.0
                bookImageView.image = toucan?.image
                UIView.animateWithDuration(duration) { [weak self] in
                  bookImageView.alpha = 1.0
                }
                toucan = nil
              }
            }
          }
        } else {
          Async.background { [weak self] in
            var toucan: Toucan? = Toucan(image: UIImage(named: "book-placeholder")).resize(bookImageView.frame.size, fitMode: .Crop)
            Async.main { [weak self] in
              bookImageView.alpha = 0.0
              bookImageView.image = toucan?.image
              UIView.animateWithDuration(duration) { [weak self] in
                bookImageView.alpha = 1.0
              }
              toucan = nil
            }
          }
        }
        
        cell.addSubview(bookImageView)
        bookImageView.anchorInCenter(width: cell.frame.height * (2 / 3), height: cell.frame.height)

        return cell
      }
      break;
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.setLabelTitle("ISBN: ")
        if let isbn = model.book?.ISBN13 {
          cell.setLabelSubTitle(isbn)
        } else {
          cell.setLabelSubTitle("")
        }
        cell.setLabelFullTitle()
        return cell
      }
      break;
    case 5:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.setLabelTitle("Binding: ")
        if let binding = model.book?.binding {
          cell.setLabelSubTitle(binding)
        } else { cell.setLabelSubTitle("")}
        cell.setLabelFullTitle()
        return cell
      }
      break;
    case 6:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.setLabelTitle("Edition: ")
        if let edition = model.book?.edition {
          cell.setLabelSubTitle(edition)
        } else { cell.setLabelSubTitle("")}
        cell.setLabelFullTitle()
        return cell
        
      }
      break;
    case 7:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.setLabelTitle("Publisher: ")
        if let publisher = model.book?.publisher {
          cell.setLabelSubTitle(publisher)
        } else { cell.setLabelSubTitle("")}
        cell.setLabelFullTitle()
        return cell
        
      }
      break;
    case 8:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.setLabelTitle("Page Count: ")
        if let pageCount = model.book?.pageCount {
          cell.setLabelSubTitle("\(pageCount)")
        } else { cell.setLabelSubTitle("")}
        cell.setLabelFullTitle()
        return cell
      }
      break;
    case 9:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.setLabelTitle("Categories: ")
        if let categories = model.book?.categories {
          cell.setLabelSubTitle(categories)
        } else { cell.setLabelSubTitle("")}
        cell.setLabelFullTitle()
        return cell
        
      }
      break;
    case 10:
      
      if let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        cell.setLabelTitle("Rating: ")
        if let rating = model.book?.maturityRating {
          cell.setLabelSubTitle(rating)
        } else { cell.setLabelSubTitle("")}
        cell.setLabelFullTitle()
        return cell
        
      }
      break;
      
    case 11:
      if  let cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell{
        cell.label?.numberOfLines = 0
        cell.setLabelTitle("Description: ")
        
        if let description = model.book?.description {
          cell.setLabelSubTitle(description)
        } else { cell.setLabelSubTitle("")}
        cell.setLabelFullTitle()
        return cell
      }
      break;
    case 12:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        cell.showSeparatorLine()
        cell.hideBothTopAndBottomBorders()
        
        cell.titleButton?.setTitle("Read Reviews ", forState: .Normal)
        cell.titleButton?.setTitleColor(.juicyOrange(), forState: .Normal)
        cell.titleButton?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
        cell.rightImageView?.frame = CGRectMake(cell.frame.width-cell.frame.height * (1 / 2), cell.frame.height * (1 / 3), cell.frame.height * (1 / 3), cell.frame.height * (1 / 3))
        cell.rightImageView?.image = Toucan(image: UIImage(named: "Icon-OrangeChevron")).resize(cell.rightImageView?.frame.size, fitMode: .Clip).image
        cell._didSelectCell.listen(self){ [weak self] bool in
          // FIXME: Go to Reviews
        }
        
        return cell
      }
      break;
    case 13:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.showSeparatorLine()
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    case 14:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.hideBothTopAndBottomBorders()
        
        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.button?.buttonColor = .juicyOrange()
        cell.button?.cornerRadius = 4
        cell.button?.setTitle("Add Book to Wishlist", forState: .Normal)
        cell._onPressed.listen(self) { [weak self] bool in
          // FIXME: Add book to wishlist
          self?.presentCreateListingView(self?.model.book)
        }
        return cell
      }
      break;
    case 15:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
//    case 16:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
//        cell.hideBothTopAndBottomBorders()
//        
//        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
//        cell.button?.buttonColor = .juicyOrange()
//        cell.button?.cornerRadius = 4
//        cell.button?.setTitle("Sell This Book", forState: .Normal)
//        cell._onPressed.listen(self) { [weak self] bool in
//          // FIXME: Add book to Sell List
//        }
//        return cell
//      }
//      break;
    case 16:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    default:
      break;
    
    
//    cell.textLabel?.textColor = UIColor.lightGrayColor()
//    cell.textLabel?.font = UIFont.asapRegular(14)
  }
    return DLTableViewCell()
    }
  

  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch (indexPath.row) {
    case 0:
      return screen.height / 25
    case 3:
      return screen.height / 3
    case 4:
      return screen.height / 25
    case 5:
      return screen.height / 25
    case 11:
      if let string = model.book?.description, let height: CGFloat! = self.calculateHeightForString(string) { return height }
      return screen.height / 10
    case 12:
      return screen.height / 20
    case 13:
      return screen.height / 40
    case 14: // Wish List Button
      return screen.height / 15
    case 15:
      return screen.height / 40
//    case 16: // Sell Button
//      return screen.height / 15
    case 16:
      return screen.height / 50
    default:
      return screen.height / 25
    }
  }
  
  func calculateHeightForString(inString:String) -> CGFloat{
    let mutstring = NSMutableAttributedString(string: inString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
    let rect:CGRect = mutstring.boundingRectWithSize(CGSizeMake(400.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )
    return rect.height
  }
  
  public func presentCreateListingView(book: Book?) {
    presentViewController(CreateListingView().setBook(book), animated: true, completion: nil)
  }
  
}