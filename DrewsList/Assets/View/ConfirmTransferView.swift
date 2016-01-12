//
//  ConfirmTransferView.swift
//  DrewsList
//
//  Created by Starflyer on 1/10/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals
import TextFieldEffects
import KMPlaceholderTextView
import SwiftyButton
import Async

public class ConfirmTransferView: UIViewController, UITableViewDelegate, UITextFieldDelegate{
  
  private let Controller = ConfirmTransferController()
  
  //Need to DBG DataBinding
  //private var model = ConfirmTransferModel { get { return controller.model } }
  

  
  //NavView
  private var TableView: DLTableView?
  private var HeaderView: UIView?
  private var BackButton: UIButton?
  private var SearchButton: UIButton?
  private var HeaderTitle: UILabel?
  private var TransferButton: SwiftyCustomContentButton?
  private var buttonLabel: UILabel?
  
  //SearchBar
  private var SearchBarContainer: UIView?
  private var SearchBarTextField: UITextField?
  private var SearchBarImageView: UIImageView?
  
  
  
  
  //Mark: LifeCycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    
    setupTableView()
    Setupself()
    SetUpHeaderView()
    SetUpSearchBar()
  
    
    HeaderView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
    HeaderTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
    BackButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
    SearchButton?.anchorInCorner(.BottomRight, xPad: 8, yPad: 8, width: 64, height: 24)
    
    //Need to DBG HeightContainerView!
    SearchBarContainer?.alignAndFillWidth(align: .UnderCentered, relativeTo: HeaderView!, padding: 0, height: 36)
    SearchBarTextField?.anchorAndFillEdge(.Left, xPad: 8, yPad: 8, otherSize: screen.width - 48)
    SearchBarImageView?.alignAndFill(align: .ToTheRightCentered, relativeTo: SearchBarTextField!, padding: 8)
    
    TableView?.alignAndFill(align: .UnderCentered, relativeTo: HeaderView!, padding: 0)
    
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    SearchBarImageView?.becomeFirstResponder()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    TableView?.fillSuperview()
    SearchBarImageView?.image = Toucan(image: UIImage(named: "Icon-Search-1")).resize(SearchBarImageView!.frame.size).image
    
  }
  
  private func Setupself() {
    view.backgroundColor = .whiteColor()
  }
  
  private func SetUpHeaderView() {
    HeaderView = UIView()
    HeaderView?.backgroundColor = .soothingBlue()
    view.addSubview(HeaderView!)
    
    HeaderTitle = UILabel()
    HeaderTitle?.text = "Confirm Transfer"
    HeaderTitle?.font = UIFont.asapBold(16)
    HeaderTitle?.textColor = .whiteColor()
    HeaderView?.addSubview(HeaderTitle!)
    
    BackButton = UIButton()
    BackButton?.setTitle("Back", forState: .Normal)
    BackButton?.titleLabel?.font = UIFont.asapRegular(16)
    HeaderView?.addSubview(BackButton!)
    
    SearchButton = UIButton()
    SearchButton?.setTitle("", forState: .Normal)
    SearchButton?.titleLabel?.font = UIFont.asapRegular(16)
    HeaderView?.addSubview(SearchButton!)
    
    
  }
  
  private func SetUpSearchBar() {
    
    SearchBarContainer = UIView()
    SearchBarContainer?.backgroundColor = .soothingBlue()
    view.addSubview(SearchBarContainer!)
    
    SearchBarTextField = UITextField()
    SearchBarTextField?.backgroundColor = .whiteColor()
    SearchBarTextField?.layer.cornerRadius = 2.0
    SearchBarTextField?.font = .asapRegular(16)
    //SearchBarTextField?.delegate = self
    SearchBarTextField?.autocapitalizationType = .Words
    SearchBarTextField?.spellCheckingType = .No
    SearchBarTextField?.autocorrectionType = .No
    SearchBarTextField?.clearButtonMode = .WhileEditing
    SearchBarContainer?.addSubview(SearchBarTextField!)
    
    SearchBarImageView = UIImageView()
    SearchBarContainer?.addSubview(SearchBarImageView!)

    
  }
  
  
  

  private func setupTableView() {
    TableView = DLTableView()
    TableView?.delegate = self
    view.addSubview(TableView!)
    
  }
  
  
  public func SetListing(listing: Listing?) -> Self {
    //if let listing = listing { model.listing = listing}
    return self
  }
  
  
  
  
  
  //DBG Button
  public class TransferButton: DLTableViewCell {
    
    private var Indicator: UIActivityIndicatorView?
    public var Button: SwiftyCustomContentButton?
    public var ButtonLabel: UILabel?
    
    public let _onPressed = Signal<Bool>()
    
    public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
      super.init(style: style, reuseIdentifier: reuseIdentifier)
      
      setupSelf()
      SetupButton()
      
    }

    public required init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    public override func layoutSubviews() {
      super.layoutSubviews()
      
      Button?.fillSuperview(left: 14, right: 14, top: 2, bottom: 2)
      Indicator?.anchorAndFillEdge(.Left, xPad: 16, yPad: 2, otherSize: 24)
      ButtonLabel?.fillSuperview(left: 40, right: 40, top: 2, bottom: 2)
      
    }
    
    public override func setupSelf() {
      backgroundColor = .whiteColor()
    }
    
    private func SetupButton() {
      
      Button = SwiftyCustomContentButton()
      Button?.buttonColor = .sweetBeige()
      Button?.highlightedColor = .juicyOrange()
      Button?.shadowColor = .clearColor()
      Button?.disabledButtonColor = .grayColor()
      Button?.disabledButtonColor = .darkGrayColor()
      Button?.shadowHeight = 0
      Button?.cornerRadius = 8
      Button?.buttonPressDepth = 0.5
      
      Indicator = UIActivityIndicatorView(activityIndicatorStyle: .White)
      Button?.customContentView.addSubview(Indicator!)
      
      ButtonLabel = UILabel()
      ButtonLabel?.textAlignment = .Center
      ButtonLabel?.textColor = UIColor.whiteColor()
      ButtonLabel?.font = .asapRegular(16)
      Button?.customContentView.addSubview(ButtonLabel!)
      
      addSubview(Button!)
      
      
      
    
    }

    
  }
  
  
  
  //Mark: TableViewDelegates_BookView
  public func TableView(tableView: UITableView, numberOfRowsInSections section: Int)
    -> Int {
      return 2
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    if let cell = tableView.dequeueReusableCellWithIdentifier("ConfirmTransferView") as? ConfirmTransferCell {
      //cell.setBook(model.listing?.book)
      return cell
    }
    return DLTableViewCell()
  }
}

public class ConfirmTransferCell: DLTableViewCell {
  
  public var bookView: BookView?
  
  public override func setupSelf() {
    super.setupSelf()
    setupBookView()
    setupSelf()
  
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

  
  
  
  public class userCell: DLTableViewCell {
    
    public var ProfileImageView: UIImageView?
    public var ProfileImageURL: String?
    
    public var UsernameLabel: UILabel?
    public var SchoolLabel: UILabel?
    
    public override func setupSelf() {
      super.setupSelf()
      
      
      ProfileImageView?.anchorToEdge(.Left, padding: 4, width: 36, height: 36)
      UsernameLabel?.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: ProfileImageView!, padding: 4, height: 12)
      SchoolLabel?.alignAndFillWidth(align: .UnderMatchingLeft, relativeTo: UsernameLabel!, padding: 0, height: 12)
      
    }
    
    public override func layoutSubviews() {
      super.layoutSubviews()
    }
    
    private func SetupProfileImageView() {
      ProfileImageView = UIImageView()
      addSubview(ProfileImageView!)
      
    }
    
    private func SetUpUsernameLabel() {
      UsernameLabel = UILabel()
      UsernameLabel?.font = .asapRegular(12)
      UsernameLabel?.adjustsFontSizeToFitWidth = true
      UsernameLabel?.minimumScaleFactor = 0.5
      addSubview(UsernameLabel!)
      
    }
    
    private func SetupSchoolLabel() {
      SchoolLabel = UILabel()
      SchoolLabel?.font = .asapRegular(10)
      SchoolLabel?.textColor = .sexyGray()
      SchoolLabel?.adjustsFontSizeToFitWidth = true
      SchoolLabel?.minimumScaleFactor = 0.5
      addSubview(SchoolLabel!)
      
      
    }
    
    
    public func SetUser(user: User?) {
      guard let user = user else { return }
      
      UsernameLabel?.text = user.getName()
      SchoolLabel?.text = user.school
      
      if ProfileImageURL != user.image { ProfileImageView?.image = nil }
      
      // Mark: images
      Async.background { [ weak self, weak user] in
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(self?.ProfileImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
        
      
        Async.main { [weak self] in
          
          //
          if self?.ProfileImageView?.image == nil {
            self?.ProfileImageView?.image = toucan?.image
            self?.ProfileImageURL = "profile-placeholder"
            
          }
          
        toucan = nil
          
          
          if user?.image != nil && self?.ProfileImageURL != user?.image {
            
            UIImageView.dl_setImageFromUrl(user?.image) { [weak self] image, error, cache, finished, nsurl in
              Async.background { [weak self] in
                
                // NOTE: correct way to handle memory management with toucan
                // init toucan and pass in the arguments directly in the parameter headers
                // do the resizing in the background
                var toucan: Toucan? = Toucan(image: image).resize(self?.ProfileImageView?.frame.size, fitMode: .Crop).maskWithEllipse()
                
                Async.main { [weak self] in
                  
                  self?.ProfileImageURL = nsurl.URLString
                  
                  // set the image view's image
                  self?.ProfileImageView?.image = toucan?.image
                  
                  // deinit toucan
                  toucan = nil

            
            
    }
    
      
   }
  
  }
}
}
}
}
}


  
  
}
