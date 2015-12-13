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
    var book_Image: UIImage = UIImage()
    
    // UIViews
    let navbarPadding: UIView = UIView()
    let bookDetailsView: UIView = UIView()
    let bookDetailsPadding: UIView = UIView()
    let bookInfoView: UIView = UIView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.whiteColor()
        
        listingController.getBook()
       
        // Create UI elements
        setupUITexts()
        setupBookListener()
        createNavbar()
        createPriceField()
        createNotesField()
        createWishListButton()
        createSellingButton()
        createPaperbackButton()
        createHardCoverButton()
        createSlider()
        

        
        // Setup keyboard functions -- move keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        print("View loaded on the screen")
        
    }
   
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Setup UIViews
        setupNavbarPadding()
        setupBookDetailsView()
        setupBookDetailsPadding()
        setupBookInfoView()
    }
    // MARK: Listeners
    
    public func setupBookListener() {
        
        bookController.get_Title().listen(self) { (title) in
            print("The book listener is working: title is \(title)")
            self.book_Title.text = title
        }
        
        bookController.get_Authors().listen(self) { (author) in
            self.book_Author.text = author
        }
        
        bookController.get_SmallImage().listen(self) { (image) in
            print("Image received from the server")
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
        
        let textField = IsaoTextField(frame: CGRectMake(0,0,screenSize.height * 0.5,120))
        textField.drawViewsForRect(CGRectMake(0,0,screenSize.height * 0.5,120))
        textField.frame.origin = CGPointMake(10,screenSize.height * 0.7)
        textField.activeColor = UIColor(red: 240/255.0, green: 139/255.0, blue: 35/225.0, alpha: 1.0)
        textField.inactiveColor = UIColor.grayColor()
        textField.placeholder = "Price"
        textField.placeholderFontScale = 1
        textField.animateViewsForTextDisplay()
        bookInfoView.addSubview(textField)
    }
    
    func createNotesField() {
        
        let textField = IsaoTextField(frame: CGRectMake(0,0,screenSize.height * 0.5,120))
        textField.drawViewsForRect(CGRectMake(0,0,screenSize.height * 0.5,120))
        textField.frame.origin = CGPointMake(10,screenSize.height * 0.8)
        textField.activeColor = UIColor(red: 240/255.0, green: 139/255.0, blue: 35/225.0, alpha: 1.0)
        textField.inactiveColor = UIColor.grayColor()
        textField.placeholder = "Notes"
        textField.placeholderFontScale = 1
        textField.animateViewsForTextDisplay()
        bookInfoView.addSubview(textField)
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
    private func setupNavbarPadding() {
       navbarPadding.anchorAndFillEdge(.Top, xPad: 0, yPad:80, otherSize: 20)
       navbarPadding.backgroundColor = UIColor.sexyGray()
        
        self.view.addSubview(navbarPadding)
    }
    
    private func setupBookDetailsView() {
        bookDetailsView.alignAndFillWidth(align: .UnderCentered, relativeTo: navbarPadding, padding: 0, height: 80)
        bookDetailsView.backgroundColor = UIColor.bareBlue()
        
        self.view.addSubview(bookDetailsView)
    }
    
    private func setupBookDetailsPadding() {
        bookDetailsPadding.alignAndFillWidth(align: .UnderCentered, relativeTo: bookDetailsView, padding: 0, height: 20)
        bookDetailsView.backgroundColor = UIColor.sexyGray()
        
        self.view.addSubview(bookDetailsPadding)
    }
    
    private func setupBookInfoView() {
        bookInfoView.alignAndFillWidth(align: .UnderCentered, relativeTo: bookDetailsPadding, padding: 0, height: 500)
        bookInfoView.backgroundColor = UIColor.soothingBlue()
        
        bookInfoView.groupAndFill(group: .Vertical, views: [wishlist, selling, hardcover, paperback], padding: 10)
        
        self.view.addSubview(bookInfoView)
    }
    
}