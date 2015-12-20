//
//  UserProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 11/15/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import SDWebImage
import Signals

public class UserProfileView: DLNavigationController,  UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  // NOTE:
  // Steven's ISBNScannerView has a great example of correct naming of 'marks'
  
  // MARK: Properties 
  
  private var originalBGViewFrame: CGRect? = CGRectZero
  
  private let defaultBGURL: String! = "http://www.mybulkleylakesnow.com/wp-content/uploads/2015/11/books-stock.jpg"
  
  // make sure to specify the scope of the variables
  // especially when we start unit testing, the test suite wont
  // be able to recognize the default internal variables so either
  // make variables private or public
  public var scrollView: UIScrollView?
  public var bgView: UIView?
  public var bgViewTop: UIImageView?
  public var bgViewBot: UIView?
  public var paddingView: UIView?
  public var profileImg: UIImageView?
  public var profileUsername: UILabel?
  public var tabView: UIView?
  public var bookShelf: UITableView?
  public var saleListView: UICollectionView?
  public var wishListView: UICollectionView?
  public var arrow: UIImageView?
  
  // if you know there are variables that classes outside of this class
  // aren't going to be used, or that unit tests dont need to know about it
  // set them as private
  private let screenSize = UIScreen.mainScreen().bounds
  
  // references to the view's own controller and model are good candidates for 
  // private scoping
  private let controller = UserProfileController()
  private var model: UserProfileModel { get { return controller.getModel() } }
  
  // MARK: Lifecycle 
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    controller.viewDidLoad()
    
    setupDataBinding()
    setupScrollView()
    setupBGView()
    setupPaddingView()
    setupProfileImg()
    setupBookshelf()
    setupUsernameLabel()
    setupButtons()
    
    setRootViewTitle("Your List")
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    if model.user == nil { view.showLoadingScreen() }
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    scrollView?.fillSuperview()
    
    bgView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 200)
    bgView?.groupAndFill(group: .Vertical, views: [bgViewTop!, bgViewBot!], padding: 0)
    
    bgView?.layer.shadowColor = UIColor.clearColor().CGColor
    bgView?.layer.shadowPath = UIBezierPath(roundedRect: bgView!.bounds, cornerRadius: 0).CGPath
    bgView?.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    bgView?.layer.shadowOpacity = 1.0
    bgView?.layer.shadowRadius = 2
    bgView?.layer.masksToBounds = true
    bgView?.clipsToBounds = false
    
    paddingView?.alignAndFillWidth(align: .UnderCentered, relativeTo: bgView!, padding: 8, height: 2)
    
    // fetch the background image since we now have the image view's frame
    fetchBackgroundImage()
    
    // set the profile image's layouts, then fetch image
    profileImg?.anchorInCenter(width: 64, height: 64)
    fetchProfileImage()
    
    profileUsername?.alignAndFillWidth(align: .UnderCentered, relativeTo: profileImg!, padding: 8, height: 48)
    
    bookShelf?.alignAndFillWidth(align: .UnderCentered, relativeTo: paddingView!, padding: 0, height: 600)
    
    scrollView?.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height + 200)
    
    // record the background view's original height
    originalBGViewFrame = bgViewTop?.frame
  }
  
  private func fetchBackgroundImage() {
    guard let url = model.user?.bgImage ?? defaultBGURL, let nsurl = NSURL(string: url) where model.user?._id != nil else { return }
  }
  
  private func fetchProfileImage() {
    guard let url = model.user?.image, let nsurl = NSURL(string: url) else { return }
  }
  
  // MARK: Data Binding
  
  private func setupDataBinding() {
    model._user.listen(self) { [weak self] user in
      guard let user = user where user._id != nil else { return }
      
      self?.profileUsername?.text = user.username ?? user.getName()
      self?.bookShelf?.reloadData()
      
      self?.fetchBackgroundImage()
      self?.fetchProfileImage()
      
      self?.view.hideLoadingScreen()
    }
  }
  
  // MARK: UI Setup
  
  public func setupScrollView(){
    scrollView = UIScrollView()
    if let scrollView = scrollView {
      scrollView.tag = 0
      scrollView.delegate = self
      scrollView.backgroundColor = UIColor.whiteColor()
      scrollView.showsVerticalScrollIndicator = false
      rootView?.view.addSubview(scrollView)
    }
  }
  
  public func setupBGView(){
    bgView = UIView()
    scrollView?.addSubview(bgView!)
    
    bgViewTop = UIImageView()
    bgViewTop?.backgroundColor = UIColor.whiteColor()
    bgView?.addSubview(bgViewTop!)
    
    bgViewBot = UIView()
    bgViewBot?.backgroundColor = UIColor.whiteColor()
    bgView?.addSubview(bgViewBot!)
  }
  
  public func setupPaddingView() {
    paddingView = UIView()
    view.addSubview(paddingView!)
  }
  
  public func setupProfileImg(){
    profileImg = UIImageView()
    bgView?.addSubview(profileImg!)
  }
  
  public func setupUsernameLabel(){
    profileUsername = UILabel()
    if let profileUsername = profileUsername {
      profileUsername.text = model.user?.username
      profileUsername.font = UIFont.asapBold(24)
      profileUsername.textAlignment = .Center
      profileUsername.textColor = UIColor.blackColor()
      bgView?.addSubview(profileUsername)
    }
  }
  
  private func setupBookshelf() {
    bookShelf = UITableView()
    if let bookShelf = bookShelf {
      bookShelf.delegate = self
      bookShelf.dataSource = self
      bookShelf.scrollEnabled = false
      bookShelf.separatorStyle = .None
      bookShelf.multipleTouchEnabled = true
      bookShelf.allowsSelection = false
      bookShelf.registerClass(BookListView.self, forCellReuseIdentifier: "cell")
      scrollView!.addSubview(bookShelf)
    }
  }
  
  private func setupButtons() {
    //settingsButton = UIBarButtonItem()
//    //if let settingsButton = settingsButton {
//      let button: UIButton = UIButton()
//      //set image for button
//      button.setImage(UIImage(named: "Icon-SettingsGear"), forState: UIControlState.Normal)
//      //add function for button
//      button.addTarget(self, action: "settingsButtonPressed", forControlEvents: UIControlEvents.TouchUpInside)
//      //set frame
//      button.frame = CGRectMake(0, 0, screenSize.width/20, screenSize.width/20)
//    
    let myImage = UIImage(named: "Icon-SettingsGear")
    let resizedImage = Toucan.Resize.resizeImage(myImage!, size: CGSize(width: screenSize.width/20, height: screenSize.width/20))
//      let settingsGearImage = Toucan(image: UIImage(named: "Icon-SettingsGear")!).resize(size: CGSize(width: screenSize.width/20, height: screenSize.width/20), fitMode: Toucan.Resize.FitMode)
    
      let settingsButton = UIBarButtonItem(image: resizedImage, style: UIBarButtonItemStyle.Plain, target: self, action: "settingsButtonPressed")
    
      //settingsButton.action
      rootView?.navigationItem.rightBarButtonItem = settingsButton
  }
  
  private func setupExtraViews() {
    arrow = UIImageView()
    if let arrow = arrow {
      arrow.image = UIImage(named: "Icon-OrangeChevronButton") as UIImage?
      arrow.alpha = 0.0
      bookShelf?.addSubview(arrow)
    }
  }
  // MARK: Button Action
  
  public func settingsButtonPressed(){
    let settingsView = SettingsView()
    rootView?.navigationController?.pushViewController(settingsView, animated: true)
  }
  
  // MARK: Table View Delegates
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 225
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? BookListView else { return UITableViewCell() }
    
    switch indexPath.row {
    case 0:
      cell.tag = 0
      
      guard let user = model.user where user._id != nil && user.listings.first?.book?._id != nil else { break }
      
      cell.label.text =  "I'm Selling"
      
      // set data
      cell.controller.model.bookList = user.listings.filter { $0.listType == "selling" }
      
      // data bind
      user._saleList.listen(self) { [weak cell] list in
        cell?.controller.model.bookList = list
      }
      
      break
    case 1:
      cell.tag = 1
      
      guard let user = model.user where user._id != nil && user.listings.first?.book?._id != nil else { break }
      cell.label.text = "I'm Buying"
      
      // set data
      cell.controller.model.bookList = user.listings.filter { $0.listType == "buying" }
      
      // data bind
      user._wishList.listen(self) { [weak cell] list in
        cell?.controller.model.bookList = list
      }

      break
    default: break
    }
    
    // add databinding to cells
    cell.controller.get_selectedBook().removeListener(self)
    cell.controller.get_selectedBook().listen(self) { [weak self] book in
      log.debug(book?._id)
    }
    
    cell.controller.get_selectedListing().removeListener(self)
    cell.controller.get_selectedListing().listen(self) { [weak self] listing in
      
      let listViewContainer = ListViewContainer()
      if listViewContainer.setListing(listing) { self?.pushViewController(listViewContainer, animated: true) }
    }
    
    return cell
  }
  
  // MARK: Scroll View Delegates
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let offset: CGFloat? = -64 - scrollView.contentOffset.y where offset > 0 {
      let ratio = originalBGViewFrame!.width / originalBGViewFrame!.height
      bgViewTop?.frame = CGRectMake(originalBGViewFrame!.origin.x - offset!, originalBGViewFrame!.origin.y - offset!, originalBGViewFrame!.width + (offset! * ratio), originalBGViewFrame!.height + (offset!))
    }
  }
  
  // MARK: View Functions
  
  func imageFadeIn(imageView: UIImageView, rightSide: Bool) {
    if(rightSide){
      UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
        imageView.alpha = 1.0
        imageView.frame = CGRect(x: self.screenSize.width-imageView.width*1.25, y: (self.bookShelf?.height)!/4, width: imageView.width, height: imageView.height)
        //imageView.constant += self.view.bounds.width
        }, completion: nil)
    } else {
      UIView.animateWithDuration(0.5, delay: 0.0, options: .CurveEaseOut, animations: {
        imageView.alpha = 1.0
        imageView.frame = CGRect(x: imageView.width*0.25, y: (self.bookShelf?.height)!/4, width: imageView.width, height: imageView.height)
        //imageView.constant += self.view.bounds.width
        }, completion: nil)
    }
  }
  
  func applyPlainShadow(view: UIView) {
    let layer = view.layer
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.4
    layer.shadowRadius = 3
  }
  
  public func arrangeViews(){
    scrollView!.contentSize = CGSizeMake(screenSize.width, bgView!.frame.height + (bookShelf?.frame.height)!)
    scrollView?.bringSubviewToFront(tabView!)
  }
}

// MARK: Cell Classes

public class BookListView: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
  
  public let label = UILabel()
  public var collectionView: UICollectionView?
  
  public let controller = BookListController()
  public var model: BookListModel { get { return controller.model } }

  public let _collectionViewFrame = Signal<CGRect>()
  public var collectionViewFrame: CGRect = CGRectZero { didSet { _collectionViewFrame => collectionViewFrame } }
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupDataBinding()
    setupCollectionView()
    setupLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setupDataBinding() {
    model._bookList.listen(self) { [weak self] list in
      self?.collectionView?.reloadData()
    }
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    
    _collectionViewFrame.listen(self) { [weak layout] frame in
      layout?.itemSize = CGSizeMake(100, frame.height)
    }
    
    collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    collectionView?.registerClass(BookCell.self, forCellWithReuseIdentifier: "cell")
    collectionView?.delegate = self
    collectionView?.dataSource = self
    collectionView?.backgroundColor = UIColor.whiteColor()
    collectionView?.showsHorizontalScrollIndicator = false
    collectionView?.multipleTouchEnabled = true
    addSubview(collectionView!)
  }
  
  private func setupLabel() {
    label.font = UIFont.systemFontOfSize(16)
    label.textColor = UIColor.sexyGray()
    addSubview(label)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    label.anchorAndFillEdge(.Top, xPad: 8, yPad: 0, otherSize: 25)
    collectionView?.alignAndFill(align: .UnderCentered, relativeTo: label, padding: 0)
    collectionViewFrame = collectionView!.frame
  }
  
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
      return UIEdgeInsetsMake(0, 8, 0, 8)
    }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.bookList.count
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? BookCell else { return UICollectionViewCell() }
    cell.backgroundColor = UIColor.whiteColor()
    
    let listing = model.bookList[indexPath.row]
    
    let book = listing.book
    let userPrice = listing.price
    let lister = listing.highestLister?.user
    let listerPrice = listing.highestLister?.price
    
    if let url = book?.largeImage ??  book?.mediumImage ?? book?.smallImage, let nsurl = NSURL(string: url) {}
    
    if let url = tag == 0 ? lister?.image : lister?.image, let nsurl = NSURL(string: url) {}
    
    if let text = listerPrice {
      let string = "Best Match $\(text)"
      let coloredString = NSMutableAttributedString(string: string)
      coloredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 11))

      cell.listerPriceLabel?.attributedText = coloredString
    }
    
    if let text = userPrice {
      let string = "Your Price $\(text)"
      let coloredString = NSMutableAttributedString(string: string)
      coloredString.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 11))
      
      cell.userPriceLabel?.attributedText = coloredString
    }
    
    // databind the cells
    cell.didSelectBook.removeListener(self)
    cell.didSelectBook.listen(self) { [weak self] bool in
      if (bool == true) { self?.controller.get_selectedBook().fire(book) }
    }
    
    cell.didSelectLister.removeListener(self)
    cell.didSelectLister.listen(self) { [weak self, weak listing] bool in
      if (bool == true) { self?.controller.get_selectedListing().fire(listing) }
    }
    
    return cell
  }
}

public class BookCell: UICollectionViewCell {
  
  public var imageView: UIImageView?
  public var infoView: UIView?
  public var listerImageView: UIImageView?
  public var infoPriceView: UIView?
  public var listerPriceLabel: UILabel?
  public var userPriceLabel: UILabel?
  
  public let didSelectBook = Signal<Bool>()
  public let didSelectLister = Signal<Bool>()
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupInfoView()
    setupListerImageView()
    setupPriceView()
    setupListerPriceLabel()
    setupPriceLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 150)
    infoView?.alignAndFillWidth(align: .UnderCentered, relativeTo: imageView!, padding: 0, height: 36)
    listerImageView?.anchorInCorner(.TopLeft, xPad: 0, yPad: 4, width: 24, height: 24)
    infoPriceView?.alignAndFill(align: .ToTheRightCentered, relativeTo: listerImageView!, padding: 4)
    infoPriceView?.groupAndFill(group: .Vertical, views: [userPriceLabel!, listerPriceLabel!], padding: 0)
    
    if let image = UIImage(named: "book-placeholder"), let imageView = imageView {
      imageView.image = Toucan(image: image).resize(imageView.frame.size, fitMode: .Clip).image
    }
  }
  
  private func setupImageView() {
    imageView = UIImageView()
    imageView?.userInteractionEnabled = true
    imageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectedBook"))
    addSubview(imageView!)
  }
  
  private func setupInfoView() {
    infoView = UIView()
    infoView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectedLister"))
    addSubview(infoView!)
  }
  
  private func setupListerImageView() {
    listerImageView = UIImageView()
    infoView?.addSubview(listerImageView!)
  }
  
  private func setupPriceView() {
    infoPriceView = UIView()
    infoView?.addSubview(infoPriceView!)
  }
  
  private func setupListerPriceLabel() {
    listerPriceLabel = UILabel()
    listerPriceLabel?.textColor = UIColor.moneyGreen()
    listerPriceLabel?.font = UIFont.asapBold(10)
    listerPriceLabel?.adjustsFontSizeToFitWidth = true
    listerPriceLabel?.minimumScaleFactor = 0.1
    infoPriceView?.addSubview(listerPriceLabel!)
  }
  
  private func setupPriceLabel() {
    userPriceLabel = UILabel()
    userPriceLabel?.textColor = UIColor.moneyGreen()
    userPriceLabel?.font = UIFont.asapRegular(10)
    userPriceLabel?.adjustsFontSizeToFitWidth = true
    userPriceLabel?.minimumScaleFactor = 0.1
    infoPriceView?.addSubview(userPriceLabel!)
  }
  
  public func selectedBook() {
    didSelectBook => true
  }
  
  public func selectedLister() {
    didSelectLister => true
  }
}