//
//  CreateListingView.swift
//  DrewsList
//
//  Created by Steven Yang on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Neon
import UIKit
import TextFieldEffects
import Signals

enum ForToggle {
    case Wishlist
    case Selling
    func name() -> String {
        switch self {
        case .Wishlist:
            return "Wishlist"
        case .Selling:
            return "Selling"
        }
    }
}

enum CoverToggle {
    case Hardcover
    case Paperback
    func name() -> String {
        switch self {
            case .Hardcover:
                return "Hardcover"
            case .Paperback:
                return "Paperback"
        }
    }
}

public class CreateListingView : UIViewController {
    
    // MARK: Properties
    
    private let listingController = CreateListingController()
    private let bookController = BookController()
    
    let screenSize: CGRect = UIScreen.mainScreen().bounds
    let navbar: UINavigationBar = UINavigationBar()
    
    // Toggle Buttons
    let wishlist: UIButton = UIButton(type: .Custom)
    let selling: UIButton = UIButton(type: .Custom)
    let hardcover: UIButton = UIButton(type: .Custom)
    let paperback: UIButton = UIButton(type: .Custom)
    
    var coverToggle: CoverToggle = .Hardcover // setting default
    var forToggle: ForToggle = .Wishlist // setting default
    
    // Book info
    var book_Title: UILabel = UILabel()
    var book_Author: UILabel = UILabel()
    var book_ISBN: UILabel = UILabel()
    var book_Edition: UILabel = UILabel()
    var book_Image: UIImageView = UIImageView()
    
    // UIViews
    let containerView: UIView = UIView()
    let bookDetailsView: UIView = UIView()
    let bookInfoPaddingView: UIView = UIView()
    let bookInfoView: UIView = UIView()
    
    // Book details labels
    let book_details_label: UILabel = UILabel()
    let book_info_for: UILabel = UILabel()
    let book_info_condition: UILabel = UILabel()
    let book_info_cover: UILabel = UILabel()
    
    // Book Info containers
    let forButtonContainer: UIView = UIView()
    let conditionContainer: UIView = UIView()
    let coverButtonContainer: UIView = UIView()
    let notesContainer: UIView = UIView()
    
    // Text Fields
    var textField_Price: IsaoTextField = IsaoTextField()
    var textField_Notes: IsaoTextField = IsaoTextField()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up the container view
        containerView.clipsToBounds = true
        containerView.backgroundColor = UIColor(red: 247, green: 247, blue: 247, alpha: 1.0)
        self.view.addSubview(containerView)
        
        // Setup up the bookDetailsView
        bookDetailsView.backgroundColor = UIColor.blackColor()
        bookDetailsView.layer.borderWidth = 1
        bookDetailsView.layer.borderColor = UIColor.sexyGray().CGColor
        
        book_Title.text = "Book Title"
        book_Title.textAlignment = .Left
        book_Title.font = UIFont.systemFontOfSize(14)
        book_Title.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
        bookDetailsView.addSubview(book_Title)
        
        book_Author.text = "By Steven Yang"
        book_Author.textAlignment = .Left
        book_Author.font = UIFont.systemFontOfSize(14)
        book_Author.textColor = UIColor(red: 157, green: 157, blue: 157, alpha: 1.0)
        bookDetailsView.addSubview(book_Author)
        
        book_ISBN.text = "ISBN: 000-00-0-000"
        book_ISBN.textAlignment = .Left
        book_ISBN.font = UIFont.systemFontOfSize(14)
        book_ISBN.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
        bookDetailsView.addSubview(book_ISBN)
        
        book_Edition.text = "Edition: N/A"
        book_Edition.textAlignment = .Left
        book_Edition.font = UIFont.systemFontOfSize(14)
        book_Edition.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
        bookDetailsView.addSubview(book_Edition)
        
        containerView.addSubview(bookDetailsView)
        
        // Book Info Padding
        book_details_label.text = "Book Details"
        book_details_label.textAlignment = .Left
        book_details_label.font = UIFont.systemFontOfSize(12)
        book_details_label.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)

        bookInfoPaddingView.backgroundColor = UIColor.blueColor()
        bookInfoPaddingView.addSubview(book_details_label)
        
        containerView.addSubview(bookInfoPaddingView)
        
        // Set up Book Details View
        bookInfoView.backgroundColor = UIColor.blackColor()
        
        book_info_for.text = "For"
        book_info_for.textAlignment = .Left
        book_info_for.font = UIFont.systemFontOfSize(14)
        book_info_for.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
        
        bookInfoView.addSubview(book_info_for)
        
        // For Buttons
        let label = UILabel()
        
        // Button
        wishlist.frame = CGRectMake(10, screenSize.height * 0.4, screenSize.height * 0.2, screenSize.height * 0.1)
        wishlist.addTarget(self, action: "wishListButtonPressed", forControlEvents: .TouchUpInside)
        wishlist.backgroundColor = UIColor.grayColor()
        wishlist.layer.borderWidth = 1
        wishlist.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Label
        label.text = "Wishlist"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = wishlist.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        wishlist.layer.zPosition = 2
        label.layer.zPosition = 3
        
        wishlist.addSubview(label)
        forButtonContainer.addSubview(wishlist)
        
        // Selling
        
        // Button
        selling.frame = CGRectMake(screenSize.height * 0.3, screenSize.height * 0.4, screenSize.height * 0.2, screenSize.height * 0.1)
        selling.addTarget(self, action: "sellingButtonPressed", forControlEvents: .TouchUpInside)
        selling.backgroundColor = UIColor.grayColor()
        selling.layer.borderWidth = 1
        selling.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Label
        label.text = "Selling"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = selling.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        selling.layer.zPosition = 2
        label.layer.zPosition = 3
        
        selling.addSubview(label)
        forButtonContainer.addSubview(selling)

        bookInfoView.addSubview(forButtonContainer)
        containerView.addSubview(bookInfoView)
        
        // Cover
        
        book_info_cover.text = "Cover"
        book_info_cover.textAlignment = .Left
        book_info_cover.font = UIFont.systemFontOfSize(14)
        book_info_cover.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
        
        bookInfoView.addSubview(book_info_cover)
        
        // Button
        paperback.frame = CGRectMake(10, screenSize.height * 0.7, screenSize.height * 0.2, screenSize.height * 0.1)
        paperback.addTarget(self, action: "paperBackButtonPressed", forControlEvents: .TouchUpInside)
        paperback.backgroundColor = UIColor.grayColor()
        paperback.layer.borderWidth = 1
        paperback.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Label
        label.text = "Paperback"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = paperback.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        paperback.layer.zPosition = 2
        label.layer.zPosition = 3
        
        paperback.addSubview(label)
        coverButtonContainer.addSubview(paperback)
        
        // Button
        hardcover.frame = CGRectMake(screenSize.height * 0.3, screenSize.height * 0.7, screenSize.height * 0.2, screenSize.height * 0.1)
        hardcover.addTarget(self, action: "hardCoverButtonPressed", forControlEvents: .TouchUpInside)
        hardcover.backgroundColor = UIColor.grayColor()
        hardcover.layer.borderWidth = 1
        hardcover.layer.borderColor = UIColor.whiteColor().CGColor
        
        // Label
        label.text = "Hardcover"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = hardcover.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        hardcover.layer.zPosition = 2
        label.layer.zPosition = 3
        
        hardcover.addSubview(label)
        coverButtonContainer.addSubview(hardcover)
        
        bookInfoView.addSubview(coverButtonContainer)
        
        // Construct Condition container
        book_info_condition.text = "Condition"
        book_info_condition.textAlignment = .Left
        book_info_condition.font = UIFont.systemFontOfSize(14)
        book_info_condition.textColor = UIColor(red: 153, green: 153, blue: 153, alpha: 1.0)
        book_info_condition.anchorInCorner(.TopLeft, xPad: 30, yPad: 5, width: 50, height: 20)
        
        bookInfoView.addSubview(book_info_condition)
        
        let slider = UISlider()
        slider.anchorInCorner(.TopLeft, xPad: 10, yPad: 5, width: 375, height: 10)
        slider.minimumValue = 1
        slider.maximumValue = 3
        slider.value = 2
        slider.tintColor = UIColor.blueColor()
        slider.addTarget(self, action: "sliderDidChange:", forControlEvents: .ValueChanged)
        conditionContainer.addSubview(slider)
        
        bookInfoView.addSubview(conditionContainer)

        // Create UI elements
//        setupUITexts()
//        setupBookListener()
//        createNavbar()
        createPriceField()
        createNotesField()
//        createWishListButton()
//        createSellingButton()
//        createPaperbackButton()
//        createHardCoverButton()
//        createSlider()
    
        // Setup keyboard functions -- move keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        print("View loaded on the screen")
        
    }
   
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        containerView.fillSuperview(left: 0, right: 0, top: 75, bottom: 0)
        bookDetailsView.anchorInCorner(.TopRight, xPad: 0, yPad: 50, width: 425, height: 180)
        bookInfoView.anchorInCorner(.TopLeft, xPad: 0, yPad: 0, width: 425, height: 800)
        
        layoutFrames()
        
        // Setup UIViews
//        setupNavbarPadding()
//        setupBookDetailsView()
//        setupBookDetailsPadding()
//        setupBookInfoView()
    }
    // MARK: Listeners
    
    public func setupBookListener() {
      
      bookController.get_Book().listen(self) { [weak self] book in
        self?.book_Title.text = book?.title
        self?.book_Author.text = book?.authors.first?.name ?? ""
      }
    }
    
    // MARK: Navbar
    
    func createNavbar() {
        print("Creating the navbar")
        navbar.frame = CGRectMake(0, 0, screenSize.width, screenSize.height * 0.1)
        navbar.barTintColor = UIColor.bareBlue()
        self.view.addSubview(navbar)
    }
    
    // MARK: Texts
    
    func setupUITexts() {
        
//        book_ISBN.text = listingController.getISBN()
        book_Edition.text = "N/A"
       
        book_Title.anchorInCenter(width: screenSize.width, height: screenSize.height)
        
        self.view.addSubview(book_Title)
        self.view.addSubview(book_Author)
        self.view.addSubview(book_ISBN)
        self.view.addSubview(book_Edition)
        
    }
    
    // MARK: For
    
    // Wishlist
    func createWishListButton() {
        
        print("Creating the wishlist button")
        let label = UILabel()
        
        // Button
        wishlist.frame = CGRectMake(10, screenSize.height * 0.4, screenSize.height * 0.2, screenSize.height * 0.1)
        wishlist.addTarget(self, action: "wishListButtonPressed", forControlEvents: .TouchUpInside)
        wishlist.backgroundColor = UIColor.grayColor()
        
        // Label
        label.text = "Wishlist"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = wishlist.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        wishlist.layer.zPosition = 2
        label.layer.zPosition = 3
        
        bookInfoView.addSubview(wishlist)
        bookInfoView.addSubview(label)
        
    }
    
    func wishListButtonPressed() {
        print("WishList button pressed")
        forToggle = .Wishlist
        toggleFor()
    }
    
    // Selling
    func createSellingButton() {
        
        print("Creating the selling button")
        let label = UILabel()
        
        // Button
        selling.frame = CGRectMake(screenSize.height * 0.3, screenSize.height * 0.4, screenSize.height * 0.2, screenSize.height * 0.1)
        selling.addTarget(self, action: "sellingButtonPressed", forControlEvents: .TouchUpInside)
        selling.backgroundColor = UIColor.grayColor()
      
    
        // Label
        label.text = "Selling"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = selling.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        selling.layer.zPosition = 2
        label.layer.zPosition = 3
        
        bookInfoView.addSubview(selling)
        bookInfoView.addSubview(label)
        
    }
    
    func sellingButtonPressed() {
        print("Selling button pressed")
        forToggle = .Selling
        toggleFor()
        
    }
    
    func toggleFor() {
        
        switch (forToggle) {
        case .Wishlist:
            print("Wishlist button pressed")
            wishlist.backgroundColor = UIColor.blueColor()
            selling.backgroundColor = UIColor.grayColor()
            break
        case .Selling:
            print("Selling button pressed")
            selling.backgroundColor = UIColor.blueColor()
            wishlist.backgroundColor = UIColor.grayColor()
            break
        }
    }
    
    // MARK: Cover
    
    // Paperback
    func createPaperbackButton() {
        
        print("Creating the paperback button")
        let label = UILabel()
        
        // Button
        paperback.frame = CGRectMake(10, screenSize.height * 0.7, screenSize.height * 0.2, screenSize.height * 0.1)
        paperback.addTarget(self, action: "paperBackButtonPressed", forControlEvents: .TouchUpInside)
        paperback.backgroundColor = UIColor.grayColor()
        
        // Label
        label.text = "Paperback"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = paperback.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        paperback.layer.zPosition = 2
        label.layer.zPosition = 3
        
        bookInfoView.addSubview(paperback)
        bookInfoView.addSubview(label)
        
    }
    
    func paperBackButtonPressed() {
        print("Paperback button pressed")
        coverToggle = .Paperback
        toggleCover()
    }
    
    // Hardback
    func createHardCoverButton() {
    
        print("Creating the cancel button")
        let label = UILabel()
        
        // Button
        hardcover.frame = CGRectMake(screenSize.height * 0.3, screenSize.height * 0.7, screenSize.height * 0.2, screenSize.height * 0.1)
        hardcover.addTarget(self, action: "hardCoverButtonPressed", forControlEvents: .TouchUpInside)
        hardcover.backgroundColor = UIColor.grayColor()
        
        // Label
        label.text = "Hardcover"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = hardcover.frame
        label.font = UIFont.boldSystemFontOfSize(16.0)
        
        hardcover.layer.zPosition = 2
        label.layer.zPosition = 3
        
        bookInfoView.addSubview(hardcover)
        bookInfoView.addSubview(label)
    
    }
    
    func hardCoverButtonPressed() {
        print("Hardcover button pressed")
        coverToggle = .Hardcover
        toggleCover()
        
    }
    
    func toggleCover() {
        
        switch (coverToggle) {
        case .Hardcover:
            print("Hardcover button pressed")
            hardcover.backgroundColor = UIColor.blueColor()
            paperback.backgroundColor = UIColor.grayColor()
            break
        case .Paperback:
            print("Paperback button pressed")
            paperback.backgroundColor = UIColor.blueColor()
            hardcover.backgroundColor = UIColor.grayColor()
            break
        }
    }
    
    // MARK: Slider
    
    func createSlider() {
        
//        let slider = UISlider(frame: CGRectMake(10,screenSize.height * 0.6,screenSize.height * 0.6,screenSize.height * 0.05))
        let slider = UISlider()
        slider.anchorInCorner(.TopLeft, xPad: 10, yPad: 5, width: 50, height: 10)
        slider.minimumValue = 1
        slider.maximumValue = 3
        slider.value = 2
        slider.tintColor = UIColor.blueColor()
        slider.addTarget(self, action: "sliderDidChange:", forControlEvents: .ValueChanged)
        bookInfoView.addSubview(slider)
    }
    
    func sliderDidChange(sender: UISlider!) {
        
        print("The slider is changing -- Value is: \(sender.value)")
    }
    
    // MARK: Text Fields
    
    func createPriceField() {
        
        textField_Price = IsaoTextField(frame: CGRectMake(0,0,screenSize.height * 0.5,120))
        textField_Price.drawViewsForRect(CGRectMake(0,0,screenSize.height * 0.5,120))
        textField_Price.frame.origin = CGPointMake(10,screenSize.height * 0.7)
        textField_Price.activeColor = UIColor(red: 240/255.0, green: 139/255.0, blue: 35/225.0, alpha: 1.0)
        textField_Price.inactiveColor = UIColor.grayColor()
        textField_Price.placeholder = "Price"
        textField_Price.placeholderFontScale = 1
        textField_Price.animateViewsForTextDisplay()
        bookInfoView.addSubview(textField_Price)
    }
    
    func createNotesField() {
        
        textField_Notes = IsaoTextField(frame: CGRectMake(0,0,screenSize.height * 0.5,120))
        textField_Notes.drawViewsForRect(CGRectMake(0,0,screenSize.height * 0.5,120))
        textField_Notes.frame.origin = CGPointMake(10,screenSize.height * 0.8)
        textField_Notes.activeColor = UIColor(red: 240/255.0, green: 139/255.0, blue: 35/225.0, alpha: 1.0)
        textField_Notes.inactiveColor = UIColor.grayColor()
        textField_Notes.placeholder = "Notes"
        textField_Notes.placeholderFontScale = 1
        textField_Notes.animateViewsForTextDisplay()
        bookInfoView.addSubview(textField_Notes)
    }
    
    // MARK: Keyboard
    
    func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y -= 150
    }
    
    func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y += 150
    }
    
    // MARK: Server
    public func saveButtonPressed() {
        print("The save button has been pressed")
    }
    
    // MARK: Views Setup
    private func layoutFrames() {
        bookDetailsView.groupInCorner(group: .Vertical, views: [book_Title, book_Author, book_ISBN, book_Edition], inCorner: .TopRight, padding: 10, width: 200, height: 30)

        bookInfoPaddingView.alignAndFillWidth(align: .UnderMatchingLeft, relativeTo: bookDetailsView, padding: 0, height: 60)
        bookInfoPaddingView.groupInCorner(group: .Horizontal, views: [book_details_label], inCorner: .TopLeft, padding: 10, width: 120, height: 50)
        
        bookInfoView.alignAndFillHeight(align: .UnderMatchingLeft, relativeTo: bookInfoPaddingView, padding: 0, width: 450)
        forButtonContainer.groupInCorner(group: .Horizontal, views: [wishlist, selling], inCorner: .TopLeft, padding: 0, width: 180, height: 50)
        coverButtonContainer.groupInCorner(group: .Horizontal, views: [paperback, hardcover], inCorner: .TopLeft, padding: 0, width: 180, height: 50)
        bookInfoView.groupInCorner(group: .Vertical, views: [book_info_for, forButtonContainer, book_info_condition, conditionContainer,book_info_cover, coverButtonContainer, textField_Price, textField_Notes], inCorner: .TopLeft, padding: 15, width: 425, height: 30)
    }
}