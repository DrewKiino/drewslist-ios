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

// FIXME: DEBUGGING
  var messageArray:String = ""
  
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
    controller.setBookID("5689af1c9ee2ef1f00000976")
    controller.getBookFromServer()
    //messageArray = (model.book?.description)!
  }
  
  public func setBook(book: Book?) {
    guard let book = book else { return }
    model.book = book
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 12
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.fillSuperview(left: screen.width / 25, right: 0, top: 10, bottom: 0)
        if model.book?.authors.first?.name != nil {
          cell.titleLabel?.text = model.book?.authors.first?.name
          print(model.book?.authors.first?.name)
          print(model.book?.title)
          print(model.book?.publisher)
          print(model.book?.publishedDate)
          print(model.book?.ISBN13)
          print(model.book?.pageCount)
          print(model.book?.description)
      
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
        
        if model.book?.averageRating != nil {
          view.rating = Double((model.book?.averageRating)!)!
        } else { view.rating = 0.0}
        
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
        ////////////
        let isbnLabel = UILabel()
        isbnLabel.textColor = .sexyGray()
        // TODO: add model information, replace dummy data
        
        var isbn = ""
        if model.book?.ISBN13 != nil {
          isbn = (model.book?.ISBN13)!
        }
        
        //let isbn = "XX-XXXX-XXXX"
        let isbnString = "ISBN(S): " + isbn
        var mutstring = NSMutableAttributedString()
        mutstring = NSMutableAttributedString(string: isbnString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 9, length: isbn.characters.count))
        isbnLabel.attributedText = mutstring
        
        // TODO: take out (no cover status?)
        let coverLabel = UILabel()
        coverLabel.textColor = .sexyGray()
     
        let cover = "Hardcover"
//        if model.book? != nil {
//          isbn = (model.book?.ISBN13)!
//        } else { isbn = "" }
        
        let coverString = "Cover: " + cover
        var mutstring2 = NSMutableAttributedString()
        mutstring2 = NSMutableAttributedString(string: coverString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring2.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 7, length: cover.characters.count))
        coverLabel.attributedText = mutstring2
        
        ////////////
        let editionLabel = UILabel()
        editionLabel.textColor = .sexyGray()
        var edition = ""
        if model.book?.edition != nil {
          edition = (model.book?.edition)!
        }
        let editionString = "Edition: " + edition
        var mutstring3 = NSMutableAttributedString()
        mutstring3 = NSMutableAttributedString(string: editionString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring3.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 9, length: edition.characters.count))
        editionLabel.attributedText = mutstring3
        
        ////////////
        let publisherLabel = UILabel()
        publisherLabel.textColor = .sexyGray()
        var publisher = ""
        if model.book?.publisher != nil {
          publisher = (model.book?.publisher)!
        }
        let publisherString = "Publisher: " + publisher
        var mutstring4 = NSMutableAttributedString()
        mutstring4 = NSMutableAttributedString(string: publisherString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring4.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 11, length: publisher.characters.count))
        publisherLabel.attributedText = mutstring4
        
        ////////////
        let pageCountLabel = UILabel()
        pageCountLabel.textColor = .sexyGray()
        var pageCount = ""
        if model.book?.pageCount != nil {
          pageCount = (model.book?.pageCount)!
        }
        let pageCountString = "Page Count: " + pageCount
        var mutstring5 = NSMutableAttributedString()
        mutstring5 = NSMutableAttributedString(string: pageCountString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring5.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 12, length: pageCount.characters.count))
        pageCountLabel.attributedText = mutstring5
        
        ////////////
        let categoriesLabel = UILabel()
        categoriesLabel.textColor = .sexyGray()
        let categories = "0"
        let categoriesString = "Categories: " + categories
        var mutstring6 = NSMutableAttributedString()
        mutstring6 = NSMutableAttributedString(string: categoriesString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring6.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 12, length: categories.characters.count))
        categoriesLabel.attributedText = mutstring6
        
        ////////////
        let ratingLabel = UILabel()
        ratingLabel.textColor = .sexyGray()
        var rating = ""
        if model.book?.maturityRating != nil {
          rating = (model.book?.maturityRating)!
        }
        let ratingString = "Rating: " + rating
        var mutstring7 = NSMutableAttributedString()
        mutstring7 = NSMutableAttributedString(string: ratingString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring7.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 8, length: rating.characters.count))
        ratingLabel.attributedText = mutstring7
        
        let labels = [isbnLabel, coverLabel, editionLabel, publisherLabel, pageCountLabel, categoriesLabel, ratingLabel]
        
        for label in labels {
          cell.addSubview(label)
        }
        
        cell.groupInCorner(group: .Vertical, views: [isbnLabel, coverLabel, editionLabel, publisherLabel, pageCountLabel, categoriesLabel, ratingLabel], inCorner: .TopLeft, padding: screen.width / 30, width: screen.width, height: screen.height / 40)
      
        cell.selectionStyle = .None
        return cell
      }
      break;
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.backgroundColor = .whiteColor()
        //cell.showSeparatorLine()
        cell.hideBothTopAndBottomBorders()
        ////////////
        let descriptionLabel = UILabel()
        descriptionLabel.numberOfLines = 0
        
        //descriptionLabel.textAlignment = .Center
        descriptionLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        descriptionLabel.textColor = .sexyGray()
        
        var description = ""
        if model.book?.description != nil {
          description = (model.book?.description)!
        }
        
        let descriptionString = "Description\n" + description
        var mutstring = NSMutableAttributedString()
        mutstring = NSMutableAttributedString(string: descriptionString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
        mutstring.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(15), range: NSRange(location: 11, length: description.characters.count))
        descriptionLabel.attributedText = mutstring
        
        cell.addSubview(descriptionLabel)
        descriptionLabel.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.selectionStyle = .None
        
        return cell
      }
      break;
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        cell.showSeparatorLine()
        cell.hideBothTopAndBottomBorders()
        
        cell.titleButton?.setTitle("Read Reviews ", forState: .Normal)
        cell.titleButton?.setTitleColor(.juicyOrange(), forState: .Normal)
        cell.titleButton?.fillSuperview(left: screen.width / 30, right: 0, top: 0, bottom: 0)
        cell.rightImageView?.frame = CGRectMake(cell.frame.width-cell.frame.height * (1 / 2), cell.frame.height * (3 / 8), cell.frame.height * (1 / 4), cell.frame.height * (1 / 4))
        cell.rightImageView?.image = Toucan(image: UIImage(named: "Icon-OrangeChevron")).resize(cell.rightImageView?.frame.size, fitMode: .Clip).image
        cell._didSelectCell.listen(self){ [weak self] bool in
          // FIXME: Go to Reviews
        }
        
        return cell
      }
      break;
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.showSeparatorLine()
        cell.hideBothTopAndBottomBorders()
        cell.backgroundColor = .whiteColor()
        
        return cell
      }
      break;
    case 8:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.hideBothTopAndBottomBorders()
        
        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.button?.buttonColor = .juicyOrange()
        cell.button?.cornerRadius = 4
        cell.button?.setTitle("Add Book to Wishlist", forState: .Normal)
        cell._onPressed.listen(self) { [weak self] bool in
          // FIXME: Add book to wishlist
        }
        return cell
      }
      break;
    case 9:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
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
        cell.button?.setTitle("Sell This Book", forState: .Normal)
        cell._onPressed.listen(self) { [weak self] bool in
          // FIXME: Add book to Sell List
        }
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
    switch (indexPath.row) {
    case 0:
      return screen.height / 25
    case 3:
      return screen.height / 3
    case 4:
      // FIXME: DEBUGGING add model data string to label strings
      let string = "ISBN(S): \nCover: \nEdition: \nPublisher: \nPage Count: \nCategories: \nRating: \n"
      let height:CGFloat = self.calculateHeightForString(string)
      return height + screen.width / 30 * 6
    case 5:
      // FIXME: DEBUGGING model.description instead of messageArray[1]
      var description = ""
      if model.book?.description != nil {
        description = (model.book?.description)!
      } else { description = "Description of Book!" }
      let height:CGFloat = self.calculateHeightForString(description)
      return height
    case 6:
      return screen.height / 15
    case 7:
      return screen.height / 40
    case 8:
      return screen.height / 15
    case 9:
      return screen.height / 50
    case 10:
      return screen.height / 15
    default:
      return screen.height / 25
    }
  }
  
  func calculateHeightForString(inString:String) -> CGFloat{
    let mutstring = NSMutableAttributedString(string: inString, attributes: [NSFontAttributeName: UIFont.asapBold(15)])
    let rect:CGRect = mutstring.boundingRectWithSize(CGSizeMake(300.0,CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, context:nil )
    return rect.height
  }
  
}