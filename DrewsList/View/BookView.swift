//
//  BookView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class BookView: UIView {
  
  private let controller = BookController()
  
  public var attributesContainer: UIView?
  public var image: UIImageView?
  public var title: UILabel?
  public var author: UILabel?
  public var publisher: UILabel?
  public var edition: UILabel?
  public var isbn_10: UILabel?
  public var isbn_13: UILabel?
  
  public init(book: Book) {
    super.init(frame: CGRectZero)
    
    backgroundColor = UIColor.redColor()
    
    setupImageView()
    setupAttributesContainer()
    setupTitleLabel()
    setupAuthorLabel()
    setupPublisherLabel()
    setupEditionLabel()
    setupISBN_10Label()
    setupISBN_13Label()
  }
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    image?.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: 128)
    
    attributesContainer?.alignAndFill(align: .ToTheRightCentered, relativeTo: image!, padding: 0)
    
    title?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize:  48)
    author?.alignAndFillWidth(align: .UnderCentered, relativeTo: title!, padding: 0, height: 24)
    publisher?.alignAndFillWidth(align: .UnderCentered, relativeTo: author!, padding: 0, height: 24)
    edition?.alignAndFillWidth(align: .UnderCentered, relativeTo: publisher!, padding: 0, height: 24)
    isbn_10?.alignAndFillWidth(align: .UnderCentered, relativeTo: edition!, padding: 0, height: 24)
    isbn_13?.alignAndFillWidth(align: .UnderCentered, relativeTo: isbn_10!, padding: 0, height: 24)
  }
  
  private func setupImageView() {
    image = UIImageView()
    image?.backgroundColor = UIColor.yellowColor()
    
    if let url =  controller.getSmallImage(), let nsurl = NSURL(string: url) {
      image?.hnk_setImageFromURL(nsurl)
    }
    
    addSubview(image!)
  }
  
  private func setupAttributesContainer() {
    attributesContainer = UIView()
    
    attributesContainer?.backgroundColor = UIColor.whiteColor()
    
    addSubview(attributesContainer!)
  }
  
  private func setupTitleLabel() {
    
    title = UILabel()
    title?.numberOfLines = 2
    
    title?.backgroundColor = UIColor.blueColor()
    
    attributesContainer?.addSubview(title!)
  }
  
  private func setupAuthorLabel() {
    author = UILabel()
    author?.numberOfLines = 1
    
    author?.backgroundColor = UIColor.greenColor()
    
    attributesContainer?.addSubview(author!)
  }
  
  private func setupPublisherLabel() {
    publisher = UILabel()
    publisher?.numberOfLines = 1
    
    publisher?.backgroundColor = UIColor.purpleColor()
    
    attributesContainer?.addSubview(publisher!)
  }
  
  private func setupEditionLabel() {
    edition = UILabel()
    edition?.numberOfLines = 1
    
    edition?.backgroundColor = UIColor.cyanColor()
    
    attributesContainer?.addSubview(edition!)
  }
  
  private func setupISBN_10Label() {
    isbn_10 = UILabel()
    isbn_10?.numberOfLines = 1
    
    isbn_10?.backgroundColor = UIColor.redColor()
    
    attributesContainer?.addSubview(isbn_10!)
  }
  
  private func setupISBN_13Label() {
    isbn_13 = UILabel()
    isbn_13?.numberOfLines = 1
    
    isbn_13?.backgroundColor = UIColor.magentaColor()
    
    attributesContainer?.addSubview(isbn_13!)
  }
}