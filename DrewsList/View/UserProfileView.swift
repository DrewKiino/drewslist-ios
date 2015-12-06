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
import Toucan
import Haneke


public class UserProfileView: UINavigationController,  UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  // NOTE:
  // Steven's ISBNScannerView has a great example of correct naming of 'marks'
  
  // MARK: Properties 
  
  // make sure to specify the scope of the variables
  // especially when we start unit testing, the test suite wont
  // be able to recognize the default internal variables so either
  // make variables private or public
  public var rootView: UIViewController?
  public var scrollView: UIScrollView?
  public var bgView: UIView?
  public var bgViewTop: UIImageView?
  public var bgViewBot: UIView?
  public var profileImg: UIImageView?
  public var profileUsername: UILabel?
  public var settingsButton: UIButton?
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
    
//    Shared.imageCache.removeAll()
//    Shared.dataCache.removeAll()
//    Shared.JSONCache.removeAll()
//    Shared.stringCache.removeAll()
    
    // its good to keep all every UI specific initialization 
    // in its own function to keep it modularized
    // especially for debugging purposes
    setupDataBinding()
    setRootView()
    setupScrollView()
    setupBGView()
    setupProfileImg()
    setupBookshelf()
//    setupSalesList()
//    setupWishList()
//    setupTabView()
//    setupButtons()
//    setupExtraViews()
//    arrangeViews()
//    setupUsernameLabel()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    controller.userViewWillAppear()
  }
  
  public override func viewDidAppear(animated: Bool) {
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    scrollView?.fillSuperview()
    bgView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 200)
    bgView?.groupAndFill(group: .Vertical, views: [bgViewTop!, bgViewBot!], padding: 0)
    
    // fetch the background image since we now have the image view's frame
    fetchBackgroundImage()
    
    // set the profile image's layouts, then fetch image
    profileImg?.anchorInCenter(width: 64, height: 64)
    fetchProfileImage()
    
    bookShelf?.alignAndFillWidth(align: .UnderCentered, relativeTo: bgView!, padding: 0, height: 400)
    scrollView?.contentSize = view.frame.size
    
    // record the background view's original height
    originalBGViewFrame = bgViewTop?.frame
  }
  
  private func fetchBackgroundImage() {
    guard let url = model.user?.bgImage, let nsurl = NSURL(string: url) else { return }
    bgViewTop?.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "BGImage", diskCapacity: 10 * 1024 * 1024) { [unowned self] image in
      return Toucan(image: image).resize(self.bgViewTop!.frame.size, fitMode: .Crop).image
    })
  }
  
  private func fetchProfileImage() {
    guard let url = model.user?.image, let nsurl = NSURL(string: url) else { return }
    profileImg?.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "ProfileImage", diskCapacity: 10 * 1024 * 1024) { [unowned self] image in
      return Toucan(image: image).resize(self.profileImg!.frame.size, fitMode: .Crop).maskWithEllipse(borderWidth: 1, borderColor: UIColor.whiteColor()).image
    })
  }
  
  // MARK: Data Binding
  
  private func setupDataBinding() {
    model._username.listen(self) { [weak self] _id in
      self?.profileUsername?.text = _id
    }
    model._saleList.listen(self) { [weak self] list in
      self?.saleListView?.reloadData()
    }
    model._wishList.listen(self) { [weak self] list in
      self?.wishListView?.reloadData()
    }
  }
  
  // MARK: UI Setup
  
  public func setRootView() {
    rootView = UIViewController()
    setViewControllers([rootView!], animated: false)
  }
  
  public func setupScrollView(){
    scrollView = UIScrollView()
    if let scrollView = scrollView {
      scrollView.tag = 0
      scrollView.delegate = self
      scrollView.backgroundColor = UIColor.whiteColor()
      rootView?.view.addSubview(scrollView)
    }
  }
  
  public func setupBGView(){
    bgView = UIView()
    scrollView?.addSubview(bgView!)
    
    bgViewTop = UIImageView()
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
    if let profileUsername = profileUsername {
      profileUsername.text = model.username
      profileUsername.font = UIFont(name: "Avenir", size: 100)
      profileUsername.font = UIFont.boldSystemFontOfSize(20.0)
      profileUsername.textAlignment = .Center
      profileUsername.textColor = UIColor.blackColor()
      bgView?.addSubview(profileUsername)
    }
  }
  
  private func setupBookshelf() {
    bookShelf = UITableView()
    if let bookShelf = bookShelf {
      bookShelf.backgroundColor = UIColor.greenColor()
      bookShelf.delegate = self
      bookShelf.dataSource = self
      bookShelf.rowHeight = view.frame.height / 4
      bookShelf.scrollEnabled = false
      bookShelf.registerClass(BookListView.self, forCellReuseIdentifier: "cell")
      scrollView!.addSubview(bookShelf)
    }
  }
  
  private func setupSalesList() {
    
    // Do any additional setup after loading the view, typically from a nib.
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    
    saleListView = UICollectionView()
    
    // sale list
    if let saleListView = saleListView {
//      saleListView.tag = 1
//      saleListView.registerClass(Cell.self, forCellWithReuseIdentifier: "cell")
//      saleListView.delegate = self
//      saleListView.dataSource = self
//      saleListView.pagingEnabled = true
//      saleListView.backgroundColor = UIColor.whiteColor()
    }
  }
  
  private func setupWishList() {
    
    // Do any additional setup after loading the view, typically from a nib.
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    
    wishListView = UICollectionView()
    
    // wish list
    if let wishListView = wishListView {
//      wishListView.tag = 2
//      wishListView.registerClass(Cell.self, forCellWithReuseIdentifier: "cell")
//      wishListView.delegate = self
//      wishListView.dataSource = self
//      wishListView.pagingEnabled = true
//      wishListView.backgroundColor = UIColor.whiteColor()
    }
  }
  
  private func setupTabView() {
    tabView = UIView()
    if let tabView = tabView {
      
      tabView.backgroundColor = UIColor.brownColor()
      applyPlainShadow(tabView)
      
      scrollView?.addSubview(tabView)
    }
  }
  
  private func setupButtons() {
    settingsButton = UIButton()
    if let settingsButton = settingsButton {
      settingsButton.setImage(UIImage(named: "Icon-SettingsGear") as UIImage?, forState: .Normal)
      bgView?.addSubview(settingsButton)
    }
  }
  
  private func setupExtraViews() {
    arrow = UIImageView()
    if let arrow = arrow {
      arrow.image = UIImage(named: "Icon-OrangeChevronButton") as UIImage?
      arrow.alpha = 0.0
      bookShelf?.addSubview(arrow)
    }
  }
  
  // for delegates, its best to do the official 'MARK' tag
  // the tag syntax is specific, note that these headings become apparanet
  // in the function finder right after the filename above ^^^
  
  // MARK: Table View Delegates
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 150
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? BookListView else { return UITableViewCell() }
    
    return cell

//    let cell = UITableViewCell()
//    cell.backgroundColor = UIColor.redColor()
//    cell.selectionStyle = .None
//    
//    let shelfLabel = UILabel()
    
//    if(indexPath.row == 0) {
//      shelfLabel.text = "I'M SELLING"
//      shelfLabel.font = UIFont(name: "Avenir", size: 12)
//      shelfLabel.font = UIFont.boldSystemFontOfSize(10.0)
//      shelfLabel.textColor = UIColor.lightGrayColor()
//      shelfLabel.frame = CGRectMake()
//      
//      saleListView!.frame = CGRectMake()
     
//      cell.backgroundColor = UIColor.whiteColor()
//      cell.addSubview(shelfLabel)
//      cell.addSubview(saleListView!)
//      
//    } else {
//      shelfLabel.text = "MY WISHLIST"
//      shelfLabel.font = UIFont(name: "Avenir", size: 12)
//      shelfLabel.font = UIFont.boldSystemFontOfSize(10.0)
//      shelfLabel.textColor = UIColor.lightGrayColor()
//      shelfLabel.frame =

//      wishListView!.frame = CGRectMake()
      
//      cell.backgroundColor = UIColor.whiteColor()
//      cell.addSubview(shelfLabel)
//      cell.addSubview(wishListView!)
//    }
    //print(saleListView?.contentSize.width)
//    return  cell
  }
  
  // MARK: Collection View Delegates
  
  
//  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//    
//    return CGSizeMake( screenSize.width / 3.5, collectionView.frame.height - collectionView.frame.height / 10)
//    
//  }
  
//  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
//    let leftRightInset = screenSize.width / 25.0
//    
//    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
//  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return collectionView.tag == 1 ? model.saleList.count : model.wishList.count
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
//    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? Cell
//    cell!.backgroundColor = UIColor.purpleColor()
//    
//    switch collectionView.tag {
//    case 1:
//      cell?.setup()
//    case 2:
//      cell?.setup()
//    default: break
//    }
    
//    if(collectionView.tag == 1){
//      print("Book title from saleList(should be 4 of these): \(model.saleList[indexPath.row].title)")
      //cell?.bookImageView.image = model.saleList[indexPath.row].bookImg
//      cell?.setup()
//    } else if (collectionView.tag == 2){
      //cell?.bookImageView.image = model.wishList[indexPath.row].bookImg
//      cell?.setup()
//    }
//    return cell!
    return UICollectionViewCell()
  }
  
  // MARK: Scroll View Delegates
  
  private var originalBGViewFrame: CGRect? = CGRectZero
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let offset: CGFloat? = -64 - scrollView.contentOffset.y where offset > 0 {
      let ratio = originalBGViewFrame!.width / originalBGViewFrame!.height
      bgViewTop?.frame = CGRectMake(originalBGViewFrame!.origin.x - offset!, originalBGViewFrame!.origin.y - offset!, originalBGViewFrame!.width + (offset! * ratio), originalBGViewFrame!.height + (offset!))
    }
  }
  
  
//  public func scrollViewDidEndDecelerating(scrollView: UIScrollView){
//    let scrollViewWidth = scrollView.frame.size.width
//    let scrollContentSizeWidth = scrollView.contentSize.width
//    let scrollOffset = scrollView.contentOffset.x
//    
//    if (scrollOffset == 0)
//    {
      // then we are at the left
      
//      arrow?.frame = CGRect( x: screenSize.width, y: (bookShelf?.height)!/4, width: screenSize.width/12, height: screenSize.width/12)
//      imageFadeIn(arrow!, rightSide: true)
//    }
//    else if (scrollOffset + scrollViewWidth == round(scrollContentSizeWidth))
//    {
      // then we are at the end
//      arrow?.frame = CGRect( x: 0-(arrow?.width)!, y: (bookShelf?.height)!/4, width: screenSize.width/12, height: screenSize.width/12)
//      imageFadeIn(arrow!, rightSide: false)
//      
//    }
//  }
  
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

// good job putting these cells in their correct abstraction aka the 'View'

// MARK: Cell Classes

public class BookListView: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
  
  public var collectionView: UICollectionView?

  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupCollectionView()
  }
  
  private func setupCollectionView() {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    layout.itemSize = CGSizeMake(100, frame.height)
    
    collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
    collectionView?.registerClass(BookCell.self, forCellWithReuseIdentifier: "cell")
    collectionView?.delegate = self
    collectionView?.dataSource = self
    addSubview(collectionView!)
  }

  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    collectionView?.fillSuperview()
  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? BookCell else { return UICollectionViewCell() }
    cell.backgroundColor = UIColor.whiteColor()
    return cell
  }
}

public class BookCell: UICollectionViewCell {
    var bookImageView: UIImageView!
    var infoView: UIView!
    var infoLabel: UILabel!
    private var doOnce = true
  
  public func setup(){
    
    if doOnce {
      bookImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*6/7))
      bookImageView.contentMode = UIViewContentMode.ScaleAspectFit
      bookImageView.backgroundColor = UIColor.blueColor()
      
      contentView.addSubview(bookImageView!)
    
      let viewFrame = CGRect(x: 0, y: frame.size.height*6/7, width: frame.size.width, height: frame.size.height/7)
      infoView = UILabel(frame: viewFrame)
      
      infoView.backgroundColor = UIColor.whiteColor()
      
      infoView.layer.shadowColor = UIColor.blackColor().CGColor
      infoView.layer.shadowOffset = CGSize(width: 2, height: 3)
      infoView.layer.shadowOpacity = 0.1
      infoView.layer.shadowRadius = 5
      contentView.addSubview(infoView!)
      
      let textFrame = CGRect(x: frame.size.width/2, y: frame.size.height*6/7, width: frame.size.width/2, height: frame.size.height/7)
      infoLabel = UILabel(frame: textFrame)
      
      infoLabel.backgroundColor = UIColor.clearColor()
      
      infoLabel.text = "More Info"
      infoLabel.font = UIFont(name: "Avenir", size: 8)
      infoLabel.textColor = UIColor.lightGrayColor()
      //infoLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
      infoLabel.textAlignment = .Center
      contentView.addSubview(infoLabel!)
      doOnce = false
    }
  }
  
  
  
}