//
//  CreateListingView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/21/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals
import TextFieldEffects
import KMPlaceholderTextView
import SwiftyButton

public class CreateListingView: DLNavigationController, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = CreateListingController()
  private var model: CreateListingModel { get { return controller.getModel() } }
  
  // Navigation Header Views
  private var headerView: UIView?
  private var cancelButton: UIButton?
  private var saveButton: UIButton?
  private var headerTitle: UILabel?
  
  private var tableView: DLTableView?
  
  // MARK: View Lifecycle
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
//    setupHeaderView()
    setupTableView()
    setupDefaultValues()
    setRootViewTitle("Create a Listing")
    
//    headerView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
//    headerTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
//    cancelButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
//    saveButton?.anchorInCorner(.BottomRight, xPad: 8, yPad: 8, width: 64, height: 24)
    
//    tableView?.alignAndFill(align: .UnderCentered, relativeTo: headerView!, padding: 0)
    tableView?.fillSuperview()
    
    FBSDKController.createCustomEventForName("UserCreateListing")
  }
  
  // MARK: Setup Functions
  
  private func setupSelf() {
    rootView?.view.backgroundColor = .whiteColor()
    
    rootView?.setButton(.LeftBarButton, title: "Cancel", target: self, selector: "dismiss")
  }
  
  public override func setupDataBinding() {
    super.setupDataBinding()
    model._book.removeAllListeners()
    model._book.listen(self) { [weak self] book in
      self?.tableView?.reloadData()
    }
    
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
      // dismiss keyboard
      self?.tableView?.resignFirstResponder()
      // hide header buttons
      self?.hideHeaderButtons()
      // show loading screen
      if bool == true { self?.rootView?.view.showLoadingScreen(-16, bgOffset: nil, fadeIn: false, completionHandler: nil) }
      else if bool == false { self?.rootView?.view.hideLoadingScreen() }
    }
    
    model._serverCallbackFromUploadListing.removeAllListeners()
    model._serverCallbackFromUploadListing.listen(self) { [weak self] bool in
      // show header buttons
      self?.showHeaderButtons()
      // hide loading screen
      self?.rootView?.view.hideLoadingScreen()
      // dismiss feed and present listing feed if callback was good
      if bool == true { self?.dismissAndPresentListingFeed() }
    }
  }
  
  private func setupHeaderView() {
    headerView = UIView()
    headerView?.backgroundColor = .soothingBlue()
    view.addSubview(headerView!)
    
    headerTitle = UILabel()
    headerTitle?.text = "Create A Listing"
    headerTitle?.textAlignment = .Center
    headerTitle?.font = UIFont.asapBold(16)
    headerTitle?.textColor = .whiteColor()
    headerView?.addSubview(headerTitle!)
    
    cancelButton = UIButton()
    cancelButton?.setTitle("Cancel", forState: .Normal)
    cancelButton?.titleLabel?.font = UIFont.asapRegular(16)
    cancelButton?.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
    headerView?.addSubview(cancelButton!)
    
//    saveButton = UIButton()
//    saveButton?.setTitle("Upload", forState: .Normal)
//    saveButton?.titleLabel?.font = UIFont.asapRegular(16)
//    saveButton?.addTarget(self, action: "upload", forControlEvents: .TouchUpInside)
//    headerView?.addSubview(saveButton!)
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    rootView?.view.addSubview(tableView!)
  }
  
  private func setupDefaultValues(){
    self.model.listing?.price = 1
    self.model.listing?.listType = "buying"
    self.model.listing?.cover = "hardcover"
    self.model.listing?.condition = "2"
    self.model.listing?.notes = ""
  }
  
  public func dismiss() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0, 2, 5, 7, 10: return 24
    case 3, 4, 11, 12: return 36
    case 6, 9: return 88
    case 1: return 168
    case 14: return 300
    default: return 48
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 15
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Book"
        cell.hideTopBorder()
        cell.showBottomBorder()
        cell.alignTextLeft()
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        cell.setBook(model.book)
        cell.bookView?.canShowBookProfile = false
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Market Information"
        cell.alignTextLeft()
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Amazon:"
        cell.titleTextLabel?.text = (model.book?.awsListPrice?.getListPriceText() ?? "N/A")
        cell.hideSeparatorLine()
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("TitleCell", forIndexPath: indexPath) as? TitleCell {
        cell.titleLabel?.text = "Google:"
        cell.titleTextLabel?.text = (model.book?.googleListPrice?.getListPriceText() ?? "N/A")
        cell.hideSeparatorLine()
        return cell
      }
      break
//    case 2:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
//        cell.paddingLabel?.text = "For"
//        cell.alignTextLeft()
//        return cell
//      }
//      break
//    case 3:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell", forIndexPath: indexPath) as? ToggleCell {
//        cell.leftToggleButton?.setTitle("My Wish List", forState: .Normal)
//        cell.rightToggleButton?.setTitle("My Sale List", forState: .Normal)
//        cell._didSelectCell.removeAllListeners()
//        cell._didSelectCell.listen(self) { [weak self] toggle in
//          switch toggle {
//          case .Left:
//            self?.model.listing?.listType = "buying"
//            return
//          case .Right:
//            self?.model.listing?.listType = "selling"
//            return
//          }
//        }
//        cell.hideTopBorder()
//        return cell
//      }
//      break
//    case 4:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
//        cell.paddingLabel?.text = "Cover"
//        cell.alignTextLeft()
//        return cell
//      }
//      break
//    case 5:
//      if let cell = tableView.dequeueReusableCellWithIdentifier("ToggleCell", forIndexPath: indexPath) as? ToggleCell {
//        cell.leftToggleButton?.setTitle("Hardcover", forState: .Normal)
//        cell.rightToggleButton?.setTitle("Paperback", forState: .Normal)
//        cell._didSelectCell.removeAllListeners()
//        cell._didSelectCell.listen(self) { [weak self] toggle in
//          switch toggle {
//          case .Left:
//            self?.model.listing?.cover = "hardcover"
//            return
//          case .Right:
//            self?.model.listing?.cover = "paperback"
//            return
//          }
//        }
//        return cell
//      }
//      break
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Condition of book"
        cell.showBothTopAndBottomBorders()
        cell.alignTextLeft()
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("SliderCell", forIndexPath: indexPath) as? SliderCell {
        cell.hideBothTopAndBottomBorders()
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self] toggle in
          switch toggle {
          case .left:
            self?.model.listing?.condition = "1"
            return
          case .middle:
            self?.model.listing?.condition = "2"
            return
          case .right:
            self?.model.listing?.condition = "3"
            return
          }
        }
        return cell
      }
      break
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Price & Description"
        cell.alignTextLeft()
        return cell
      }
      break
    case 8:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextFieldCell", forIndexPath: indexPath) as? InputTextFieldCell {
        cell.hideBothTopAndBottomBorders()
        cell.inputTextField?.placeholder = "Price ($USD)"
        cell.inputTextField?.text = "5.0"
        cell.inputTextField?.keyboardType = .DecimalPad
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) { [weak self] bool in
          if let cell = self?.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0)) {
            self?.tableView?.setContentOffset(CGPointMake(0, cell.frame.origin.y), animated: true)
          }
        }
        cell._inputTextFieldString.removeAllListeners()
        cell._inputTextFieldString.listen(self) { [weak self] text in
          if let text = text { self?.model.listing?.price = Double(text) }
        }
        cell.didBeginEditingBlock = { [weak self] in
          self?.rootView?.setButton(.RightBarButton, title: "End Edit", target: cell, selector: "dismissKeyboard")
        }
        cell.didEndEditingBlock = { [weak self] in
          self?.rootView?.hideButton(.RightBarButton)
        }
        return cell
      }
      break
    case 9:
      if let cell = tableView.dequeueReusableCellWithIdentifier("InputTextViewCell", forIndexPath: indexPath) as? InputTextViewCell {
        cell.titleLabel?.text = "Notes"
        cell.inputTextView?.placeholder = "Want to buy or sell this book as soon as possible? Write your pitch here! Tell future users why you are listing this book. Keep it clean please..."
        cell._isFirstResponder.removeAllListeners()
        cell._isFirstResponder.listen(self) { [weak self] bool in
          if let cell = self?.tableView?.cellForRowAtIndexPath(NSIndexPath(forRow: 7, inSection: 0)) {
            self?.tableView?.setContentOffset(CGPointMake(0, cell.frame.origin.y), animated: true)
          }
        }
        cell._inputTextViewString.removeAllListeners()
        cell._inputTextViewString.listen(self) { [weak self] text in
          self?.model.listing?.notes = text
        }
        cell.didBeginEditingBlock = { [weak self] in
          self?.rootView?.setButton(.RightBarButton, title: "End Edit", target: cell, selector: "dismissKeyboard")
        }
        cell.didEndEditingBlock = { [weak self] in
          self?.rootView?.hideButton(.RightBarButton)
        }
        return cell
      }
      break
    case 10:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Listing Information"
        cell.alignTextLeft()
        return cell
      }
      break
    case 11:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("How are Listing fees calculated?", forState: .Normal)
        cell.hideArrowIcon()
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self ] bool in
          self?.showAlert("How are Listing fees calculated?", message: "Listing Fees are calculated at a flat rate of $0.99 per listing. By agreeing to scan in your fingerprint, you agree to have Apple charge your payment method on file for the amount as listed. Refer a Friend to Drew’s List to get a free listing!")
        }
        
        return cell
      }
      break
    case 12:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("Your Available Listings", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self ] bool in
          self?.pushViewController(ListingsView(), animated: true)
        }
        
        return cell
      }
      break
    case 13:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        
        cell.titleButton?.setTitle("Buy Listings", forState: .Normal)
        cell._didSelectCell.removeAllListeners()
        cell._didSelectCell.listen(self) { [weak self ] bool in
        }
        
        return cell
      }
      break
    case 14:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        
        if model.listType == "selling", let freeListings = UserModel.sharedUser().user?.freeListings {
          
          model.listing?._price.removeAllListeners()
          model.listing?._price.listen(self) { [weak self, weak cell] askingPrice in
            
            /*
            if let askingPrice = askingPrice, let actualPrice = self?.model.book?.getListPrice() where freeListings == 0 {
              
              // I PRESENT TO YOU THE LISTING FEE ALGORITHM
              let assumedListingFee: Double = actualPrice * 0.05
              let actualListingFee: Double = max(askingPrice * 0.05, 0.99)
              let modifier: Double = pow(actualPrice, (1 / askingPrice))
              let modifiedFee: Double = (assumedListingFee * modifier) / 2.0
              let decidingFee: Double = max(actualListingFee, modifiedFee)
              
              cell?.button?.setTitle("List for Sale ($\(decidingFee))", forState: .Normal)
              
              self?.model.listingFee = decidingFee
              
            } else if freeListings > 0 {
              
              cell?.button?.setTitle("List for Sale (\(freeListings) Free)", forState: .Normal)
              
              self?.model.listingFee = 0.00
              
            } else {
              
              cell?.button?.setTitle("List for Sale ($0.99)", forState: .Normal)
              
              self?.model.listingFee = 0.99
            }
            */
          }

          if freeListings > 0 { // set default listing fee (default is $0.99 cents)
            
            cell.button?.setTitle("List for Sale (\(freeListings) Free)", forState: .Normal)
            model.listingFee = 0.00
            
          } else {
            
            cell.button?.setTitle("List for Sale ($0.99)", forState: .Normal)
            model.listingFee = 0.99
          }
          
        } else {
          
          cell.button?.setTitle("List for Purchase (Free)", forState: .Normal)
          
          // set default listing fee (free if buying)
          model.listingFee = 0.0
        }
        
        cell._onPressed.removeAllListeners()
        cell._onPressed.listen(self) { [weak self] bool in
          self?.controller.uploadListingToServer()
        }
        
        return cell
      }
      break
    default: break
    }
    
    return DLTableViewCell()
  }
  
 
  // MARK: Class Functions
  
  public func setBook(book: Book?) -> Self {
    model.book = book
    return self
  }
  
  public func setListType(listType: String?) -> Self {
    model.listType = listType
    return self
  }
 
  public func dismissAndPresentListingFeed() {
    dismissViewControllerAnimated(false) { [weak self] bool in
      TabView.sharedInstance().selectedIndex = 4
      if let userProfileViewContainer = TabView.currentView() as? UserProfileViewContainer {
        userProfileViewContainer.userProfileView?.getUserFromServer()
      }
    }
  }
  
  public func cancel() {
    if let tabView = presentingViewController as? TabView, let scannerView = (tabView.viewControllers?.filter { $0 is ScannerView })?.first as? ScannerView {
      scannerView.dismissViewControllerAnimated(true) { [weak scannerView] in
        scannerView?.previewLayer?.hidden = false
        scannerView?.session?.startRunning()
      }
    }
  }
  
  public func upload() {
    controller.uploadListingToServer()
  }
  
  public func hideHeaderButtons() {
    cancelButton?.hidden = true
    saveButton?.hidden = true
  }
  
  public func showHeaderButtons() {
    cancelButton?.hidden = false
    saveButton?.hidden = false
  }
}




















































