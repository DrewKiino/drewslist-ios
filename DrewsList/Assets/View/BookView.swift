//
//  BookView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Toucan
import Haneke

public class BookView: UIView {
  
  private let controller = BookController()
  
  public var attributesContainer: UIView?
  public var imageView: UIImageView?
  public var title: UILabel?
  public var author: UILabel?
  public var edition: UILabel?
  public var isbn: UILabel?
  
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
  }
  
  public func setBook(book: Book?) { controller.model.book = book ?? Book() }
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView?.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: 100)
    
    attributesContainer?.alignAndFill(align: .ToTheRightCentered, relativeTo: imageView!, padding: 8)
    
    title?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize:  48)
    author?.alignAndFillWidth(align: .UnderCentered, relativeTo: title!, padding: 0, height: 24)
    edition?.alignAndFillWidth(align: .UnderCentered, relativeTo: author!, padding: 0, height: 16)
    isbn?.alignAndFillWidth(align: .UnderCentered, relativeTo: edition!, padding: 0, height: 16)
    
    
    layer.shadowColor = UIColor.darkGrayColor().CGColor
    layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 0).CGPath
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
    title?.numberOfLines = 4
    
    attributesContainer?.addSubview(title!)
  }
  
  private func setupAuthorLabel() {
    author = UILabel()
    author?.font = UIFont.asapRegular(10)
    author?.adjustsFontSizeToFitWidth = true
    author?.numberOfLines = 3
    
    attributesContainer?.addSubview(author!)
  }
  
  private func setupEditionLabel() {
    edition = UILabel()
    edition?.font = UIFont.asapRegular(10)
    edition?.textColor = UIColor.sexyGray()
    
    attributesContainer?.addSubview(edition!)
  }
  
  private func setupIsbnLabel() {
    
    isbn = UILabel()
    isbn?.font = UIFont.asapRegular(10)
    isbn?.textColor = UIColor.sexyGray()
    
    attributesContainer?.addSubview(isbn!)
  }
  
  private func setupDataBinding() {
    
    controller.get_Book().listen(self) { [weak self] book in
      self?._setBook(book)
    }
  }
  
  private func _setBook(book: Book?) {
    
    if let book = book {
      
      title?.text = book.title
      
      author?.text = (book.authors.map { $0.name != nil ? $0.name! : "" } as NSArray).componentsJoinedByString(", ")
      
      edition?.text = book.edition != nil ? book.edition?.lowercaseString.rangeOfString("edition") == nil ? "Edition:\t\(book.edition!.convertToOrdinal())" : book.edition!.convertToOrdinal() : ""
      
      isbn?.text = book.ISBN13 != nil ? "ISBN:\t\t\(book.ISBN13!)" : book.ISBN10 != nil ? "ISBN:\t\t\(book.ISBN10)" : ""
      
      if let imageView = imageView, url: String! = book.largeImage ?? book.mediumImage ?? book.smallImage ?? "", let nsurl = NSURL(string: url) {
        imageView.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "BookViewImageView", diskCapacity: 10 * 1024 * 1024) { image in
          //        return Toucan(image: image).resize(imageView.frame.size, fitMode: .Clip).maskWithRoundedRect(cornerRadius: 5).image
          return Toucan(image: image).resize(imageView.frame.size, fitMode: .Clip).image
        })
      }
    }
  }
}





























