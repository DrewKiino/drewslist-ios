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
import Async

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
  public var profileImg: UIImageView?
  public var profileUsername: UILabel?
  public var descriptionTextView: UITextView?
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
    
    setupSelf()
    setupDataBinding()
    setupScrollView()
    setupBGView()
    setupProfileImg()
    setupDescriptionTextView()
    setupBookshelf()
    setupUsernameLabel()
    setupButtons()
    
    setRootViewTitle("Your List")
    
    // MARK: Neon Layouts
    
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
    
    // set the profile image's layouts, then fetch image
    profileImg?.anchorInCenter(width: 64, height: 64)
    
    profileUsername?.alignAndFillWidth(align: .UnderCentered, relativeTo: profileImg!, padding: 8, height: 48)
    
    // record the background view's original height
    originalBGViewFrame = bgViewTop?.frame
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
    
    descriptionTextView?.sizeToFit()
    descriptionTextView?.alignAndFillWidth(
      align: .UnderCentered,
      relativeTo: bgView!,
      padding: 16,
      height: descriptionTextView!.frame.size.height < 200 ? descriptionTextView!.frame.size.height : 200
    )
    
    bookShelf?.alignAndFillWidth(align: .UnderCentered, relativeTo: descriptionTextView!, padding: 0, height: 600)
    
    scrollView?.contentSize = CGSizeMake(screen.width, 1000)
  }
  
  // MARK: Data Binding
  
  private func setupDataBinding() {
    model._user.listen(self) { [weak self] user in
      self?.setUser(user)
      self?.bookShelf?.reloadData()
      self?.view.hideLoadingScreen()
    }
  }
  
  // MARK: UI Setup
  
  public func setupSelf() {
    controller.viewDidLoad()
  }
  
  public func setupScrollView(){
    scrollView = UIScrollView()
    scrollView?.tag = 0
    scrollView?.delegate = self
    scrollView?.backgroundColor = UIColor.whiteColor()
    scrollView?.showsVerticalScrollIndicator = false
    rootView?.view.addSubview(scrollView!)
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
  
  public func setupProfileImg(){
    profileImg = UIImageView()
    bgView?.addSubview(profileImg!)
  }
  
  public func setupUsernameLabel(){
    profileUsername = UILabel()
    profileUsername?.text = model.user?.username
    profileUsername?.font = UIFont.asapBold(24)
    profileUsername?.textAlignment = .Center
    profileUsername?.textColor = UIColor.blackColor()
    bgView?.addSubview(profileUsername!)
  }
  
  private func setupDescriptionTextView() {
    descriptionTextView = UITextView()
    descriptionTextView?.editable = false
    descriptionTextView?.showsVerticalScrollIndicator = false
    descriptionTextView?.font = .asapRegular(12)
    scrollView?.addSubview(descriptionTextView!)
  }
  
  private func setupBookshelf() {
    bookShelf = UITableView()
    bookShelf?.delegate = self
    bookShelf?.dataSource = self
    bookShelf?.scrollEnabled = false
    bookShelf?.separatorStyle = .None
    bookShelf?.multipleTouchEnabled = true
    bookShelf?.allowsSelection = false
    bookShelf?.registerClass(BookListView.self, forCellReuseIdentifier: "cell")
    scrollView?.addSubview(bookShelf!)
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
  
  public func setUser(user: User?) {
    
    profileImg?.alpha = 0.0
    
    // fixture
//    user?.description = "Bacon ipsum dolor amet kielbasa bacon landjaeger brisket venison fatback. Sausage pork flank, hamburger bresaola cupim sirloin swine pastrami pig leberkas brisket. Prosciutto sirloin venison bresaola meatloaf swine landjaeger, shankle turkey shoulder. Spare ribs strip steak salami venison kielbasa pancetta prosciutto turducken beef ham hock shank tri-tip brisket tenderloin. Bresaola shankle pork chop, short loin jerky brisket strip steak frankfurter ground round. Tri-tip t-bone jowl tail pancetta. Prosciutto tail filet mignon, kevin pork chop tenderloin pork belly jowl beef ribs. Shank strip steak t-bone flank, ham cow porchetta pork loin spare ribs short ribs bresaola rump capicola. Strip steak salami picanha ball tip, ground round beef doner. Ham hock pig prosciutto, sirloin tri-tip flank kielbasa swine short loin beef jerky picanha filet mignon meatball. T-bone prosciutto brisket tongue, spare ribs tail salami corned beef. Turkey spare ribs shoulder frankfurter tail boudin. Frankfurter andouille sirloin ball tip beef ribs kevin brisket tongue corned beef ham hock t-bone cupim. Picanha leberkas bacon, ground round tongue short loin kevin meatloaf pork loin shankle cow jowl. Swine t-bone kielbasa andouille sausage, ball tip boudin jowl hamburger meatball ground round biltong. Tongue tenderloin frankfurter short ribs ball tip turkey cow alcatra. Pork loin ham hock bresaola short ribs porchetta, bacon corned beef. Venison cow drumstick, hamburger kielbasa prosciutto beef. Meatloaf shoulder chuck short ribs ball tip bacon turkey t-bone cow tongue capicola swine venison. Pork frankfurter alcatra spare ribs jerky landjaeger. Short ribs turkey ham meatball. Pork frankfurter brisket, sirloin shankle short loin beef prosciutto spare ribs porchetta sausage. Doner leberkas swine, pig beef kevin salami pancetta t-bone. Frankfurter corned beef ham pig shoulder meatball biltong. Turducken pork loin jowl beef jerky filet mignon meatball flank corned beef meatloaf venison brisket."
    
    Async.background { [weak self, weak user] in
      guard let user = user else { return }
      
      let duration: NSTimeInterval = 0.5
      
      // MARK: Images
      if user.image != nil {
        
        self?.profileImg?.dl_setImageFromUrl(user.image) { [weak self] image, error, cache, url in
          // NOTE: correct way to handle memory management with toucan
          // init toucan and pass in the arguments directly in the parameter headers
          // do the resizing in the background
          var toucan: Toucan? = Toucan(image: image).resize(self?.profileImg?.frame.size).maskWithEllipse()
          
          Async.main { [weak self] in
            
            // set the image view's image
            self?.profileImg?.image = toucan?.image
            
            // stop the loading animation
            self?.view.hideLoadingScreen()
            
            // animate
            UIView.animateWithDuration(duration) { [weak self] in
              self?.profileImg?.alpha = 1.0
            }
            
            // deinit toucan
            toucan = nil
          }
        }
      } else {
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(self?.profileImg?.frame.size, fitMode: .Crop).maskWithEllipse()
        
        Async.main { [weak self] in
          
          self?.profileImg?.image = toucan?.image
          
          // stop the loading animation
          self?.view.hideLoadingScreen()
          
          UIView.animateWithDuration(duration) { [weak self] in
            self?.profileImg?.alpha = 1.0
          }
          
          toucan = nil
        }
      }
      
      if user.bgImage != nil {
        
        self?.bgViewTop?.dl_setImageFromUrl(user.bgImage) { [weak self] image, error, cache, url in
          // NOTE: correct way to handle memory management with toucan
          // init toucan and pass in the arguments directly in the parameter headers
          // do the resizing in the background
          var toucan: Toucan? = Toucan(image: image).resize(self?.bgViewTop?.frame.size, fitMode: .Crop)
          
          Async.main { [weak self] in
            
            // set the image view's image
            self?.bgViewTop?.image = toucan?.image
            
            UIView.animateWithDuration(duration) { [weak self] in
              self?.bgViewTop?.alpha = 1.0
            }
            
            // deinit toucan
            toucan = nil
          }
        }
      } else {
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "BackgroundImage_Books-33")).resize(self?.profileImg?.frame.size, fitMode: .Crop)
        
        Async.main { [weak self] in
          
          self?.bgViewTop?.image = toucan?.image
          
          toucan = nil
        }
      }
      
      Async.main { [weak self] in
        self?.profileUsername?.text = user.username ?? user.getName()
        self?.descriptionTextView?.text = user.description
      }
    }
  }
  
  // MARK: Button Action
  
  public func settingsButtonPressed(){
    rootView?.navigationController?.pushViewController(SettingsView(), animated: true)
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
      user._saleList.removeAllListeners()
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
      user._wishList.removeAllListeners()
      user._wishList.listen(self) { [weak cell] list in
        cell?.controller.model.bookList = list
      }

      break
    default: break
    }
    
    // add databinding to cells
    cell.controller.get_selectedBook().removeListener(self)
    cell.controller.get_selectedBook().listen(self) {  book in
      log.debug(book?._id)
    }
    
    cell.controller.get_selectedListing().removeListener(self)
    cell.controller.get_selectedListing().listen(self) { [weak self] listing in
      self?.pushViewController(ListViewContainer().setListing(listing), animated: true)
    }
    
    return cell
  }
  
  // MARK: Scroll View Delegates
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let offset: CGFloat? = -scrollView.contentOffset.y where offset > 0 {
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
    
    if let url = book?.largeImage ??  book?.mediumImage ?? book?.smallImage, let nsurl = NSURL(string: url) {
      
    }
    
    if let url = tag == 0 ? lister?.image : lister?.image, let nsurl = NSURL(string: url) {
    }
    
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
  
  
  public func setBook(book: Book?) {
    
    imageView?.image = nil
    imageView?.alpha = 0.0
    
    Async.background { [weak self, weak book] in
      
      let duration: NSTimeInterval = 0.5
      
      // MARK: Images
      if book != nil && book!.hasImageUrl() {
        self?.imageView?.dl_setImageFromUrl(book?.largeImage ?? book?.mediumImage ?? book?.smallImage ?? nil) { [weak self] image, error, cache, url in
          // NOTE: correct way to handle memory management with toucan
          // init toucan and pass in the arguments directly in the parameter headers
          // do the resizing in the background
          var toucan1: Toucan? = Toucan(image: image).resize(self?.imageView?.frame.size)
          
          Async.main { [weak self] in
            
            // set the image view's image
            self?.imageView?.image = toucan1?.image
            
            UIView.animateWithDuration(duration) { [weak self] in
              self?.imageView?.alpha = 1.0
            }
            
            // deinit toucan
            toucan1 = nil
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
        }
      }
    }
  }
}