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
import Signals


public class UserProfileView: UINavigationController,  UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
  
  // NOTE:
  // Steven's ISBNScannerView has a great example of correct naming of 'marks'
  
  // MARK: Properties 
  
  private var originalBGViewFrame: CGRect? = CGRectZero
  
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
    
    controller.viewDidLoad()
    
    setupDataBinding()
    setRootView()
    setupScrollView()
    setupBGView()
    setupProfileImg()
    setupBookshelf()
    setupUsernameLabel()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
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
    
    profileUsername?.alignAndFillWidth(align: .UnderCentered, relativeTo: profileImg!, padding: 8, height: 48)
    
    bookShelf?.alignAndFillWidth(align: .UnderCentered, relativeTo: bgView!, padding: 0, height: 400)
    scrollView?.contentSize = CGSizeMake(view.frame.size.width, view.frame.size.height + 200)
    
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
    model._user.listen(self) { [weak self] user in
      
      self?.profileUsername?.text = user?.username
      self?.bookShelf?.reloadData()
      
      self?.fetchProfileImage()
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
      scrollView.showsVerticalScrollIndicator = false
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
      profileUsername.text = model.user?.username
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
      bookShelf.delegate = self
      bookShelf.dataSource = self
      bookShelf.scrollEnabled = false
      bookShelf.separatorStyle = .None
      bookShelf.multipleTouchEnabled = true
      bookShelf.registerClass(BookListView.self, forCellReuseIdentifier: "cell")
      scrollView!.addSubview(bookShelf)
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
  
  // MARK: Table View Delegates
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 200
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCellWithIdentifier("cell") as? BookListView else { return UITableViewCell() }
    
    switch indexPath.row {
    case 0:
      cell.tag = 0
      cell.label.text = "I'm Selling"
      guard let user = model.user else { break }
      
      // set data
      cell.controller.model.bookList = user.saleList
      
      // data bind
      user._saleList.listen(self) { [weak cell] list in
        cell?.controller.model.bookList = list
      }
      
      break
    case 1:
      cell.tag = 1
      cell.label.text = "I'm Buying"
      guard let user = model.user else { break }
      
      // set data
      cell.controller.model.bookList = user.wishList
      
      
      // data bind
      user._wishList.listen(self) { [weak cell] list in
        cell?.controller.model.bookList = list
      }

      break
    default: break
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
    label.font = UIFont.systemFontOfSize(12)
    label.textColor = UIColor.lightGrayColor()
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
    
    if let url = model.bookList[indexPath.row].smallImage, let nsurl = NSURL(string: url) {
      cell.imageView?.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "BookListViewImageView", diskCapacity: 10 * 1024 * 1024) { [unowned cell] image in
        return Toucan(image: image).resize(cell.imageView.frame.size, fitMode: .Crop).maskWithRoundedRect(cornerRadius: 5).image
      })
    }
    
    if let url = tag == 0 ? model.bookList[indexPath.row].bestBuyer?.image : model.bookList[indexPath.row].bestSeller?.image, let nsurl = NSURL(string: url) {
      cell.infoImageView?.hnk_setImageFromURL(nsurl, format: Format<UIImage>(name: "BookListViewInfoImageView", diskCapacity: 10 * 1024 * 1024) { [unowned cell] image in
        return Toucan(image: image).resize(cell.infoImageView.frame.size, fitMode: .Crop).maskWithEllipse().image
      })
    }
    
    if let text = tag == 0 ? model.bookList[indexPath.row].bestBuyerListing : model.bookList[indexPath.row].bestSellerListing {
      cell.infoLabel.text = "Best \(tag == 0 ? "Buyer" : "Seller") $\(text)"
    }
    
    return cell
  }
}

public class BookCell: UICollectionViewCell {
  
  public var imageView: UIImageView!
  public var infoView: UIView!
  public var infoImageView: UIImageView!
  public var infoLabel: UILabel!
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupImageView()
    setupInfoView()
    setupInfoImageView()
    setupInfoLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  private func setupImageView() {
    imageView = UIImageView()
    addSubview(imageView)
  }
  
  private func setupInfoView() {
    infoView = UIView()
    addSubview(infoView)
  }
  
  private func setupInfoImageView() {
    infoImageView = UIImageView()
    infoView.addSubview(infoImageView)
  }
  
  private func setupInfoLabel() {
    infoLabel = UILabel()
    infoLabel.textColor = UIColor.juicyOrange()
    infoLabel.adjustsFontSizeToFitWidth = true
    infoLabel.minimumScaleFactor = 0.1
    infoView.addSubview(infoLabel)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    imageView.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 150)
    infoView.alignAndFill(align: .UnderCentered, relativeTo: imageView, padding: 0)
    infoImageView.anchorAndFillEdge(.Left, xPad: 2, yPad: 2, otherSize: 20)
    infoLabel.alignAndFill(align: .ToTheRightCentered, relativeTo: infoImageView, padding: 4)
  }
}