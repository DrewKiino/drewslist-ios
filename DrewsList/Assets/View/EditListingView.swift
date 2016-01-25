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
      cell.setLabelTitle("ISBN:")
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
  
  
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupBookView()
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
  
  
  

}





















