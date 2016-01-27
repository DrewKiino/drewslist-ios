//
//  DeleteListingView.swift
//  DrewsList
//
//  Created by Starflyer on 1/17/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals
import Cosmos
import Async

public class DeleteListingView: UIViewController, UITableViewDelegate, UITableViewDataSource {


  private let controller = DeleteListingController()
  private var model: DeleteListingModel  { get { return controller.model } }
  private var ScreenSize = UIScreen.mainScreen().bounds
  private var TableView: DLTableView?
  
  
  
//  //NavView
//  private var HeaderView: UIView?
//  private var BackButton: UIButton?
//  private var HeaderTitle: UILabel?


  public override func viewDidLoad() {
    super.viewDidLoad()
    
    SetUpTableView()
    SetUpDataBinding()
    controller.viewDidLoad()
    
    
  }


  public override func viewWillAppear(animated: Bool) {
    TableView?.rowHeight = UITableViewAutomaticDimension
    TableView?.reloadData()
  }


  public override func viewWillDisappear(animated: Bool) {
    
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    TableView?.fillSuperview()
  }
  
  
  //MARK: SetUp View Func
  public func SetUpTableView() {
    TableView = DLTableView()
    TableView?.delegate = self
    TableView?.dataSource = self
    TableView?.rowHeight = UITableViewAutomaticDimension
    
    view.addSubview(TableView!)
    
  }

  
  //MARK: Private Func
  private func SetUpDataBinding() {
    
     //setup view's databinding
    model._book.listen(self) { [weak self] book in
      self?.TableView!.rowHeight = UITableViewAutomaticDimension
      self?.TableView!.reloadData()
    }
     //setup controller's databinding DBG
    controller
  
  }
  
  
  
  
  
  public func setBook(book: Book?) -> Self {
    //if let book = book {model.book = book }
    return self
    
  }
  
  public func setListing(listing: Listing?) ->  Self {
    if let listing = listing { model.listing = listing }
    return self
  }

  
  
  

  
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
    ->Int {
      return 14
      
  }
  
      
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch (indexPath.row) {
    case 0:
      if let Cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath:  indexPath) as? TitleCell {
       Cell.titleLabel?.fillSuperview(left: screen.width / 25, right: 0, top: 10, bottom: 0)
        if model.book?.authors.first?.name != nil {
          Cell.titleLabel?.text = self.model.book?.authors.first?.name
          print(self.model.book?.authors.first?.name)
          print(self.model.book?.title)
          print(self.model.book?.largeImage)

          
      } else { Cell.titleLabel?.text = "Author"}
      Cell.titleLabel?.font = .asapItalic(12)
      
      return Cell
      }
    break;
    case 1:
      if let Cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        Cell.titleLabel?.fillSuperview(left: screen.width / 30, right: 30, top: 0, bottom: 0)
        if model.book?.title != nil {
          Cell.titleLabel?.text = model.book?.title
        } else { Cell.titleLabel?.text = "Title of Book" }
          Cell.titleLabel?.font = .asapBold(20)
        
        return Cell
      }
      break;
    case 2:
      if let Cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell {
        let View = CosmosView()
        if let Rating = model.book?.averageRating {
          View.rating = Rating
        }else {
          View.rating = 0.0
        }
        Cell.backgroundColor = .whiteColor()
        View.settings.fillMode = .Precise
        View.settings.borderColorEmpty = .juicyOrange()
        View.settings.colorFilled = .juicyOrange()
        View.anchorAndFillEdge(.Left, xPad: screen.width / 30, yPad: 0, otherSize: 150)
        Cell.addSubview(View)
        
        return Cell
      }
      
      break;
    case 3:
      if let Cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell {
        Cell.backgroundColor = .whiteColor()
        let BookImageView = UIImageView()
        let duration: NSTimeInterval = 0.2
        
        if let url = model.book?.getImageUrl() {
          BookImageView.dl_setImageFromUrl(url, size: BookImageView.frame.size) { [weak self] image in
            BookImageView.alpha = 0.0
            BookImageView.image = image
            UIView.animateWithDuration(duration) { [weak self] in
              BookImageView.alpha = 1.0
            }
          }
        } else {
          
          Async.background { [ weak self] in
            var toucan: Toucan?  = Toucan (image: UIImage(named: "book-placeholder")).resize(BookImageView.frame.size, fitMode: .Crop)
            Async.main { [weak self] in
              BookImageView.alpha = 0.0
              BookImageView.image = toucan?.image
              UIView.animateWithDuration(duration) { [ weak self] in
                BookImageView.alpha = 1.0
              }
              toucan = nil
            }
          }
        }
      
        Cell.addSubview(BookImageView)
        BookImageView.anchorInCenter(width: Cell.frame.height * (2/3) , height: Cell.frame.height)
        
        return Cell
      }
      break;
    case 4:
      if let Cell = tableView.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
        Cell.setLabelTitle("Edit Book Listing:")
        if let isbn =  model.book?.ISBN13 {
          Cell.setLabelSubTitle(isbn)
        } else {
          Cell.setLabelSubTitle("")
        }
         Cell.setLabelFullTitle()
         return Cell
      }
      
      break;
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
      cell.showSeparatorLine()
      cell.hideBothTopAndBottomBorders()
      cell.backgroundColor = .whiteColor()
        
      return cell
      }
      break;
    case 6:
      if let Cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
        Cell.inputTextField?.placeholder = "Edit Price: "
        Cell.inputTextField?.keyboardType = .DecimalPad
        Cell._isFirstResponder.removeAllListeners()
        Cell._isFirstResponder.listen(self) {[ weak self] bool in
          if let Cell = self?.TableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0))
          {
            self?.TableView?.setContentOffset(CGPointMake(0, Cell.frame.origin.y),  animated: true)
          }
      }
       Cell._inputTextFieldString.removeAllListeners()
        Cell._inputTextFieldString.listen(self) { [weak self] text in
          self?.model.listing?.price = text
       }
        return Cell
      }
      break;
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
        cell.inputTextField?.placeholder = "You can edit your book rating here"
        cell.inputTextField?.keyboardType = .EmailAddress
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) {[ weak self] bool  in
          if let cell = self?.TableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0))
          {
            self?.TableView?.setContentOffset(CGPointMake(0, cell.frame.origin.y),  animated: true)
          }
        }
        cell._inputTextFieldString.removeAllListeners()
        cell._inputTextFieldString.listen(self) { [weak self] text in
          self?.model.listing?.price = text
        }
        return cell
      }
      break;
    case 8:
      if  let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell{
        cell.inputTextField?.placeholder = "You can edit notes for your book here "
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) {[ weak self ] bool in
          if let cell = self?.TableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 8, inSection: 0))
          {
            self?.TableView?.setContentOffset(CGPointMake(0, cell.frame.origin.y),  animated: true)
          }
        }
        cell._inputTextFieldString.removeAllListeners()
        cell._inputTextFieldString.listen(self) { [weak self] text in
          self?.model.listing?.notes = text
        }
        return cell
      }

    break;
    case 9:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.showSeparatorLine()
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    case 10:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.hideBothTopAndBottomBorders()
        
        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.button?.buttonColor = .juicyOrange()
        cell.button?.cornerRadius = 4
        cell.button?.setTitle("Book Sold ", forState: .Normal)
        cell._onPressed.listen(self) { [weak self] bool in
          // FIXME: Add book to wishlist
        }
        return cell
      }
      break;
    case 11:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    case 12:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.hideBothTopAndBottomBorders()
        
        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.button?.buttonColor = .juicyOrange()
        cell.button?.cornerRadius = 1
        cell.button?.setTitle("Delete This Book", forState: .Normal)
        cell._onPressed.removeAllListeners()
        cell._onPressed.listen(self) { [weak self] bool in
          NSTimer.after(0.5) { [weak self] in
          self?.delete(Book)
          }
          // FIXME: Add book to Delete this book
        }
        cell.showBottomBorder()
        return cell
      }
      break;
    case 13:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    default:
      break;
      

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
    case 7:
      if let string = model.book?.description, let height: CGFloat! = self.calculateHeightForString(string) { return height }
      return screen.height / 10
    case 8:
      return screen.height / 20
    case 9:
      return screen.height / 40
    case 10: // Wish List Button
      return screen.height / 15
    case 11:
      return screen.height / 40
    case 12: // Sell Button
      return screen.height / 15
    case 13:
      return screen.height / 50
    default:
      return screen.height / 25
    }
}



  
  func calculateHeightForString(inString: String) -> CGFloat {
    let MuString = NSMutableAttributedString(string: inString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
    let Rect:CGRect = MuString.boundingRectWithSize(CGSizeMake(400.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )
    return Rect.height
}

  
  public func presentCreateListingView(book: Book?) {
    presentViewController(CreateListingView().setBook(book), animated: true, completion: nil)
  }
  
}
  
  
  
  
  
  
  
  
  
  




