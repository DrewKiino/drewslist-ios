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
import SwiftyButton

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
    
    
    title = ""
    SetUpTableView()
    SetUpDataBinding()
    controller.viewDidLoad()
  
    FBSDKController().createCustomEventForName("UserDeleteListing")
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
    model._book.removeAllListeners()
    model._book.listen(self) { [weak self] book in
      self?.TableView!.rowHeight = UITableViewAutomaticDimension
      self?.TableView!.reloadData()
    }
     //setup controller's databinding DBG
    controller.deleteListingFromServer()
  
  }
  

  
  
  
  //MARK: Public Func
  public func setBook(book: Book?) -> Self {
    if let book = book {model.book = book }
    return self
    
  }
  
  public func setListing(listing: Listing?) ->  Self {
    if let listing = listing { model.listing = listing }
    return self
  }

  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int)
    ->Int {
      return 15
      
  }
  
      
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    switch (indexPath.row) {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.backgroundColor = .whiteColor()
        cell.paddingLabel?.text = "Your Current Listing: "
        cell.hideTopBorder()
        cell.showBottomBorder()
        cell.alignTextLeft()
        return cell
      }
    break;
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        cell.bookView?.setBook(model.listing?.book)
        model._listing.removeAllListeners()
        model._listing.listen(self) { [weak cell] listing in
          cell?.bookView?.setBook(listing?.book)
        //cell.backgroundColor = .whiteColor()
      }
        
        return cell
      }
      break;
//    case 2:
//      if let Cell = tableView.dequeueReusableCellWithIdentifier("ImageCell", forIndexPath: indexPath) as? ImageCell {
//        
//        Cell.backgroundColor = .whiteColor()
//       
//        return Cell
//      }
  //      break;
//    case 3:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
//      cell.showSeparatorLine()
//      cell.hideBothTopAndBottomBorders()
//      cell.backgroundColor = .whiteColor()
//        
//      return cell
//      }
      break;
        case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.backgroundColor = .whiteColor()
        cell.hideBothTopAndBottomBorders()
        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.button?.buttonColor = .juicyOrange()
        cell.button?.cornerRadius = 2
        cell.button?.setTitle("Edit Book", forState: .Normal)
        cell._onPressed.removeAllListeners()
        cell._onPressed.listen(self) { [weak self] bool in
          //Replace To Delete Book
            self?.presentCreateListingView(self?.model.book)
    
        }
        return cell
      }
      break;
//    case 6:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
//        cell.hideBothTopAndBottomBorders()
//        return cell
//      }
      break;
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
          cell.backgroundColor = .whiteColor()
          cell.hideBothTopAndBottomBorders()
          cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
          cell.button?.cornerRadius = 2
          cell.button?.buttonColor = .juicyOrange()
          cell.button?.setTitle("Delete Book", forState: .Normal)
          cell._onPressed.removeAllListeners()
          cell._onPressed.listen(self) {[ weak self] bool in
            self?.controller.setBookID(self?.model.listing?._id)
            self?.controller.deleteListingFromServer()
            self?.dismissViewControllerAnimated(true, completion: nil)
            
          
        }

          return cell
      }


      break;
    case 8:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    default:
      break;
      
      
      }
  
       return DLTableViewCell()
  
}
  
  
 
  
//
//  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//    switch (indexPath.row) {
//    case 0:
//      return screen.height / 25
//    case 3:
//      return screen.height / 3
//    case 4:
//      return screen.height / 3
//    case 5:
//      return screen.height / 25
//    case 6:
//      if let string = model.book?.description, let height: CGFloat! = self.calculateHeightForString(string) { return height }
//      return screen.height / 10
//    case 7:
//      return screen.height / 20
//    case 8:
//      return screen.height / 40
//    case 10: // Wish List Button
//      return screen.height / 15
//    case 11:
//      return screen.height / 40
//    case 12: // Sell Button
//      return screen.height / 15
//    case 13:
//      return screen.height / 50
//    default:
//      return screen.height / 25
//    }
//}
//


  public class bigButtonCell: DLTableViewCell {
    
    private var indicator: UIActivityIndicatorView?
    public var button: SwiftyCustomContentButton?
    public var buttonLabel: UILabel?
    
    public let _onPressed = Signal<Bool>()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier reuseIndentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIndentifier)
      setupSelf()
      setupButton()
      
      
    }
    
    public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
      
    }
    
    
    public override func layoutSubviews() {
      super.layoutSubviews()
      
      button?.fillSuperview(left: 14, right: 14, top: 2, bottom: 2)
      indicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
      buttonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)

      
    }
    
    public override func setupSelf() {
      
    }
    
    private func setupButton() {
      
      button = SwiftyCustomContentButton()
      button?.buttonColor = .sweetBeige()
      button?.highlightedColor = .juicyOrange()
      button?.shadowColor = .clearColor()
      button?.disabledButtonColor = .grayColor()
      button?.shadowHeight        = 0
      button?.cornerRadius        = 8
      button?.buttonPressDepth    = 0.5 // In percentage of shadowHeight
      button?.addTarget(self, action: "pressed", forControlEvents: .TouchUpInside)
      
      
      indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
      button?.customContentView.addSubview(indicator!)
      
      buttonLabel = UILabel()
      buttonLabel?.textAlignment = .Center
      buttonLabel?.textColor = UIColor.whiteColor()
      buttonLabel?.font = .asapRegular(16)
      button?.customContentView.addSubview(buttonLabel!)
      
      addSubview(button!)
  
    }
  }
  
  
  
  func calculateHeightForString(inString: String) -> CGFloat {
    let MuString = NSMutableAttributedString(string: inString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
    let Rect:CGRect = MuString.boundingRectWithSize(CGSizeMake(400.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )
    return Rect.height
}

  
  public func presentCreateListingView(book: Book?) {
    presentViewController(EditListingView().setBook(book), animated: true, completion: nil)
  }
  
}
  
  
  
  
  
  
  
  
  
  




