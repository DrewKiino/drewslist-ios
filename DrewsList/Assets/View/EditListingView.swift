//
//  EditListingView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class EditListingView: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = EditListingController()
  private var model: EditListingModel { get { return controller.model } }
  
  private var tableView: DLTableView?
  private var tableview: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupTableView()
    setuptableview()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  private func setupSelf() {
    view.backgroundColor = .whiteColor()
    title = "Edit Your Listing"
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  private func setuptableview() {
    tableview = DLTableView()
    tableview?.delegate = self
    tableview?.dataSource = self
    view.addSubview(tableview!)
    
  }
  
  public func setListing(listing: Listing?) -> Self {
    if let listing = listing { model.listing = listing }
    return self
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("EditListingCell") as? EditListingCell {
      cell.setBook(model.listing?.book)
      return cell
    }
    
    return DLTableViewCell()
  
}
  
}






public func tableview(tableview: UITableView, numberOfRowsInSection section: Int) -> Int {
  return 6
  
}

public func tableview(tableview: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
  
  switch (indexPath.row) {
  case 1:
    if let cell = tableview.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
      cell.setLabelTitle("Desired Price:")
      return cell
    }
    break;
  case 2:
    if let cell = tableview.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
      cell.setLabelTitle("Edition:")
      return cell
    }
    break;
  case 3:
    if let cell = tableview.dequeueReusableCellWithIdentifier("LabelCell", forIndexPath: indexPath) as? LabelCell {
      cell.setLabelTitle("Publisher: ")
      return cell
  }
    
    break;
  default:
    break;
    
  }
  
  
  return DLTableViewCell()
  
}


public class EditListingCell: DLTableViewCell {
  
  public var bookView: BookView?
  public var pricelabel: UILabel?
  public var conditionlabel: UILabel?
  public var notesTitle: UILabel?
  public var notesTextViewContainer: UIView?
  public var notesTextView: UITextView?
  
  public var isUserListing: Bool = false
  
  
  
  
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupBookView()
    setupCondtionLabel()
    setupPriceLabel()
    setupCondtionLabel()
    setupNotesTitle()
    setupNotesTextViewContainer()
    setupNotesTextView()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    bookView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 150)
    
  }
  
  private func setupBookView() {
    bookView = BookView()
    addSubview(bookView!)
  }
  
  public func setBook(book: Book?) {
    bookView?.setBook(book)
  }
  
  private func setupPriceLabel() {
    pricelabel = UILabel()
    pricelabel?.font = UIFont.asapRegular(14)
    pricelabel?.textColor = UIColor.moneyGreen()
    addSubview(pricelabel!)
    
  }
  
  private func setupCondtionLabel() {
    conditionlabel = UILabel()
    conditionlabel?.font = UIFont.asapRegular(14)
    addSubview(conditionlabel!)
  }
  
  private func setupNotesTitle() {
    notesTitle = UILabel()
    notesTitle?.font = UIFont.asapBold(14)
    addSubview(notesTitle!)
  }
  
  private func setupNotesTextViewContainer() {
    notesTextViewContainer = UIView()
    notesTextViewContainer?.layer.mask = nil
    notesTextViewContainer?.hidden = true
    addSubview(notesTextViewContainer!)
  }
  
  private func setupNotesTextView() {
    notesTextView = UITextView()
    notesTextView?.showsVerticalScrollIndicator = false
    notesTextView?.editable = false
    notesTextViewContainer?.addSubview(notesTextView!)
  }
  
  public func setListing(listing: Listing?) {
    notesTextViewContainer?.hidden = true
    
    Async.background { [weak self, weak listing] in
      
      let string1 = "Desired Price $\(listing?.price ?? "")"
      let coloredString1 = NSMutableAttributedString(string: string1)
      coloredString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0, length:  13))
      
      Async.main { [weak self] in self?.pricelabel?.attributedText = coloredString1 }
      
      
  }
    
    let string2 = "Condition: \(listing?.getConditionText() ?? "")"
    let coloredString2 = NSMutableAttributedString(string: string2)
    coloredString2.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0, length: 10))
    
    Async.main {[ weak self ] in
      self?.conditionlabel?.attributedText = coloredString2
  
}

    if let notes = listing?.notes {
      Async.main{ [weak self] in
        self?.notesTitle?.text = !notes.isEmpty ? "Notes:" : nil
        
      }
    }

  
    //create paragraph style class
    var paragraphStyle: NSMutableParagraphStyle? = NSMutableParagraphStyle()
    paragraphStyle?.alignment = .Justified
    
    let attributedString: NSAttributedString = NSAttributedString(string: listing?.notes ?? "", attributes: [
      NSParagraphStyleAttributeName: paragraphStyle!,
      NSBaselineOffsetAttributeName: NSNumber(float: 0),
      NSForegroundColorAttributeName: UIColor.blackColor(),
      NSFontAttributeName: UIFont.asapRegular(12)
      
      ])
    
    //de-alloc paragraph style 
    paragraphStyle = nil
    Async.main { [ weak self] in
      
      self?.notesTextView?.attributedText = attributedString
      self?.notesTextView?.sizeToFit()
      
      let height: CGFloat! = self?.notesTextView!.frame.size.height < 100 ? self?.notesTextView!.frame.size
      .height: 100
      var notesTitle: UILabel! = self?.notesTitle!
      
      self?.notesTextViewContainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: notesTitle, padding: 11, height: height)
      
      notesTitle = nil
      
      self?.notesTextView?.fillSuperview()
      self?.notesTextViewContainer?.layer.mask = nil
      
      Async.background { [ weak self] in
        let layer: CALayer! = self?.notesTextViewContainer?.layer
        let bounds: CGRect! = self?.notesTextViewContainer?.bounds
        var gradient: CAGradientLayer? = CAGradientLayer(layer: layer)
        gradient?.frame = bounds
        gradient?.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
        gradient?.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradient?.endPoint = CGPoint(x: 0.0, y: 0.85)
        
        Async.main { [ weak self ] in
          self?.notesTextViewContainer?.layer.mask = gradient
          self?.notesTextViewContainer?.hidden = false
          gradient = nil
          
          
        
      }
     }
    }
   }

       //layer.zPosition = 2
}
