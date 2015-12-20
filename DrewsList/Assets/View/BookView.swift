//
//  BookView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import Async

public class BookView: UIView {
  
  private let controller = BookController()
  
  
  public var attributesContainer: UIView?
  
  public var imageView: UIImageView?
  public var image: UIImage?
  
  public var title: UILabel?
  public var author: UILabel?
  public var edition: UILabel?
  public var isbn: UILabel?
  public var desc: UILabel?
  private var activityView: UIActivityIndicatorView?
  
  public init() {
    super.init(frame: CGRectZero)
    
    backgroundColor = UIColor.whiteColor()
    
    setupDataBinding()
    setupImageView()
    setupAttributesContainer()
    setupTitleLabel()
    setupAuthorLabel()
    setupEditionLabel()
    setupIsbnLabel()
    setupDescriptionLabel()
    setupActivityView()
    setupSelf()
  }
  
  public func setBook(book: Book?) { controller.model.book = book ?? Book() }
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView?.anchorInCorner(.TopLeft, xPad: 0, yPad: 0, width: 100, height: 150)
    
    attributesContainer?.alignAndFill(align: .ToTheRightCentered, relativeTo: imageView!, padding: 8)
    
    activityView?.anchorInCenter(width: 24, height: 24)
    
    title?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize:  48)
    author?.alignAndFillWidth(align: .UnderCentered, relativeTo: title!, padding: 0, height: 24)
    edition?.alignAndFillWidth(align: .UnderCentered, relativeTo: author!, padding: 0, height: 12)
    isbn?.alignAndFillWidth(align: .UnderCentered, relativeTo: edition!, padding: 0, height: 12)
    desc?.alignAndFillWidth(align: .UnderCentered, relativeTo: isbn!, padding: 0, height: 48)

    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0).CGPath
  }
  
  private func setupSelf() {
    layer.shadowColor = UIColor.darkGrayColor().CGColor
    layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    layer.shadowOpacity = 1.0
    layer.shadowRadius = 2
    layer.masksToBounds = true
    clipsToBounds = false
  }
  
  private func setupImageView() {
    imageView = UIImageView()
    addSubview(imageView!)
  }
  
  private func setupAttributesContainer() {
    attributesContainer = UIView()
    
    attributesContainer?.backgroundColor = UIColor.whiteColor()
    
    addSubview(attributesContainer!)
  }
  
  private func setupTitleLabel() {
    
    title = UILabel()
    title?.font = UIFont.asapBold(16)
    title?.adjustsFontSizeToFitWidth = true
    title?.minimumScaleFactor = 0.5
    title?.numberOfLines = 3
    
    attributesContainer?.addSubview(title!)
  }
  
  private func setupAuthorLabel() {
    author = UILabel()
    author?.font = UIFont.asapRegular(12)
    author?.numberOfLines = 2
    
    attributesContainer?.addSubview(author!)
  }
  
  private func setupEditionLabel() {
    edition = UILabel()
    edition?.font = UIFont.asapRegular(12)
    edition?.textColor = UIColor.sexyGray()
    
    attributesContainer?.addSubview(edition!)
  }
  
  private func setupIsbnLabel() {
    
    isbn = UILabel()
    isbn?.font = UIFont.asapRegular(12)
    isbn?.textColor = UIColor.sexyGray()
    
    attributesContainer?.addSubview(isbn!)
  }
  
  private func setupDescriptionLabel() {
    
    desc = UILabel()
    desc?.font = UIFont.asapRegular(12)
    desc?.numberOfLines = 4
    
    
    attributesContainer?.addSubview(desc!)
  }
  
  private func setupActivityView() {
    
    activityView = UIActivityIndicatorView()
    activityView?.color = UIColor.sexyGray()
    
    attributesContainer?.addSubview(activityView!)
  }
  
  private func setupDataBinding() {
    controller.get_Book().listen(self) { [weak self] book in
      self?._setBook(book)
    }
  }
  
  private func _setBook(book: Book?) {
    
    imageView?.image = nil
    imageView?.alpha = 0.0
    
    let duration: NSTimeInterval = 0.5
    
    Async.background { [weak self, weak book] in
      
      // MARK: Images
      if book != nil && book!.hasImageUrl() {
        self?.imageView?.dl_setImageFromUrl(book?.largeImage ?? book?.mediumImage ?? book?.smallImage ?? nil) { [weak self] image, error, cache, url in
          Async.background { [weak self] in
            
            // NOTE: correct way to handle memory management with toucan
            // get size
            // init toucan
            var toucan1: Toucan? = Toucan(image: image).resize(self?.imageView?.frame.size)
            // deinit size
            
            Async.main { [weak self] in
              
              // set the image view's image
              self?.imageView?.image = toucan1?.image
              
              UIView.animateWithDuration(duration) { [weak self] in
                self?.imageView?.alpha = 1.0
              }
              
              // deinit toucan
              toucan1 = nil
              
              // stop the loading animation
              self?.stopLoading()
            }
          }
        }
      } else {
        
        var toucan2: Toucan? = Toucan(image: UIImage(named: "book-placeholder")!).resize(self?.imageView?.frame.size)
        
        Async.main { [weak self] in
          self?.imageView?.image = toucan2?.image
          
          UIView.animateWithDuration(duration) { [weak self] in
            self?.imageView?.alpha = 1.0
          }
          
          toucan2 = nil
          
          // stop the loading animation
          self?.stopLoading()
        }
      }
      
      
      
      // MARK: Attributes
      guard let book = book else { return }
      let title = book.title
      let authors = (book.authors.map { $0.name != nil ? ($0.name!.componentsSeparatedByString(",") as NSArray).componentsJoinedByString(", ") : "" } as NSArray).componentsJoinedByString(", ")
      let edition = book.edition != nil ? book.edition?.lowercaseString.rangeOfString("edition") == nil ? "Edition:\t\(book.edition!.convertToOrdinal())" : book.edition!.convertToOrdinal() : ""
      let isbn = book.ISBN13 != nil ? "ISBN:\t\t\(book.ISBN13!)" : book.ISBN10 != nil ? "ISBN:\t\t\(book.ISBN10)" : ""
      let desc = book.description?.stringByReplacingOccurrencesOfString("<[^>]+>", withString: "", options: .RegularExpressionSearch, range: nil)
      
      Async.main { [weak self] in
        
        self?.title?.text = title
        self?.author?.text = authors
        self?.edition?.text = edition
        self?.isbn?.text = isbn
        self?.desc?.text = desc
        
        NSTimer.after(1.0) { [weak self] in self?.stopLoading() }
      }
    }
  }
  
  private func startLoading() {
    activityView?.hidden = false
    activityView?.startAnimating()
    
    title?.hidden = true
    author?.hidden = true
    edition?.hidden = true
    isbn?.hidden = true
    desc?.hidden = true
  }
  
  private func stopLoading() {
    
    activityView?.stopAnimating()
    activityView?.hidden = true
    
    title?.hidden = false
    author?.hidden = false
    edition?.hidden = false
    isbn?.hidden = false
    desc?.hidden = false
  }
}





























