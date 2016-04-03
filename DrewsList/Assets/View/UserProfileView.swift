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
import MIBadgeButton_Swift

public class UserProfileViewContainer: DLNavigationController {
  
  public var userProfileView: UserProfileView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupProfileView()
    
    FBSDKController.createCustomEventForName("UserProfileView")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    userProfileView?.viewDidAppear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
  }
  
  private func setupProfileView() {
    userProfileView = UserProfileView().setIsOtherUser(false)
    
    setRootViewController(userProfileView)
    //rootView = userProfileView
    setViewControllers([rootView!], animated: false)
    setRootViewTitle("Profile")
  }
  
  public func setList_id(list_id: String?) -> Self {
   return self
  }
  
  public func isUserListing() -> Self {
    title = "Your Listing"
    return self
  }
  
  
  // MARK: Realm Functions
  
}


public class UserProfileView: UIViewController,  UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource {
  // NOTE:
  // Steven's ISBNScannerView has a great example of correct naming of 'marks'
  
  // MARK: Properties 
  
  private var originalBGViewFrame: CGRect? = CGRectZero
  
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
  public var bookShelf: DLTableView?
  public var saleListView: UICollectionView?
  public var wishListView: UICollectionView?
  public var arrow: UIImageView?
  public var isOtherUser: Bool?
  public var callButton: UIButton?
  public var chatButton: UIButton?
  
  
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
    setupScrollView()
    setupBGView()
    setupProfileImg()
    setupDescriptionTextView()
    setupBookshelf()
    setupUsernameLabel()
    setupButtons()
    setupDataBinding()
    
    // MARK: Neon Layouts
    
    scrollView?.fillSuperview()
    scrollView?.hidden = true
    
    bgView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 300)
    bgView?.groupAndFill(group: .Vertical, views: [bgViewTop!, bgViewBot!], padding: 0)
    
    bgView?.layer.shadowColor = UIColor.clearColor().CGColor
    bgView?.layer.shadowPath = UIBezierPath(roundedRect: bgView!.bounds, cornerRadius: 0).CGPath
    bgView?.layer.shadowOffset = CGSize(width: 0, height: 1.0)
    bgView?.layer.shadowOpacity = 0.5
    bgView?.layer.shadowRadius = 2
    bgView?.layer.masksToBounds = true
    bgView?.clipsToBounds = false
    
    // set the profile image's layouts, then fetch image
    profileImg?.anchorInCenter(width: 165, height: 165)
    
    profileUsername?.alignAndFillWidth(align: .UnderCentered, relativeTo: profileImg!, padding: 8, height: 48)
    
    // record the background view's original height
    originalBGViewFrame = bgViewTop?.frame
    
    // MARK: UI methods
    view.showActivityView(-64, width: nil, height: nil)
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    controller.viewDidAppear()
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    descriptionTextView?.alignAndFillWidth(
      align: .UnderCentered,
      relativeTo: bgView!,
      padding: 4,
      height: descriptionTextView!.frame.size.height < 36 ? descriptionTextView!.frame.size.height : 36
    )
    
    bookShelf?.align(.UnderCentered, relativeTo: descriptionTextView!, padding: 8, width: screen.width, height: 600)
    
    scrollView?.contentSize = CGSizeMake(screen.width,
      425
//      + 300
//      + 225
      + ((model.user?.listings.filter { $0.listType == "selling" })?.first != nil ? 260: 48)
      + ((model.user?.listings.filter { $0.listType == "buying" })?.first != nil ? 260 : 48)
    )
  }
  
  // MARK: Data Binding
  
  public func getUserFromServer() {
    controller.getUserFromServer(true)
  }
  
  private func setupDataBinding() {
    model._user.removeAllListeners()
    model._user.listen(self) { [weak self] user in
      if self?.isOtherUser == true { self?.title = "User Profile" }
      else { self?.title = "Profile" }
    }
    controller.isLoadingUserDataFromServer.removeAllListeners()
    controller.isLoadingUserDataFromServer.listen(self) { [weak self] isLoading in
      DLNavigationController.showActivityAnimation(self, leftHandSide: true)
    }
    controller.didLoadUserDataFromServer.removeAllListeners()
    controller.didLoadUserDataFromServer.listen(self) { [weak self] didLoad in
      
      DLNavigationController.hideActivityAnimation(self, leftHandSide: true)
      
      self?.scrollView?.hidden = false
      
      self?.view.dismissActivityView()
      
      if didLoad {
        self?.bookShelf?.reloadData()
      }
      
      // MARK: Images
      self?.profileImg?.dl_setImageFromUrl(self?.model.user?.imageUrl, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
      self?.bgViewTop?.dl_setImageFromUrl(self?.model.user?.bgImage, placeholder: UIImage(named: "background_books_1"))
      
      self?.callButton?.hidden = false
      self?.chatButton?.hidden = false
      
      // MARK: Texts
      self?.profileUsername?.text = self?.model.user?.getName()
      self?.descriptionTextView?.text = self?.model.user?.school
      
      if let bgView = self?.bgView, let descriptionTextView = self?.descriptionTextView {
        descriptionTextView.text = "\(self?.model.user?.school != nil ? "Student at \(self?.model.user?.school ?? "")" : "")"
        descriptionTextView.sizeToFit()
        descriptionTextView.alignAndFillWidth(
          align: .UnderCentered,
          relativeTo: bgView,
          padding: 4,
          //      height: isOtherUser == true ? 50 : 0
          //      height: 50
          height: descriptionTextView.frame.size.height < 36 ? descriptionTextView.frame.size.height : 36
        )
      }
    }
  }
  
  // MARK: UI Setup
  
  public func setupSelf() {
    controller.changeOtherUserBoolean(isOtherUser)
    controller.getUserFromServer()
  }
  
  public func setupScrollView() {
    scrollView = UIScrollView()
    scrollView?.tag = 0
    scrollView?.delegate = self
    scrollView?.backgroundColor = UIColor.whiteColor()
    scrollView?.showsVerticalScrollIndicator = false
    self.view.addSubview(scrollView!)
  }
  
  public func setupBGView() {
    bgView = UIView()
    scrollView?.addSubview(bgView!)
    
    bgViewTop = UIImageView()
    bgViewTop?.backgroundColor = UIColor.whiteColor()
    bgView?.addSubview(bgViewTop!)
    
    bgViewBot = UIView()
    bgViewBot?.backgroundColor = UIColor.whiteColor()
    bgView?.addSubview(bgViewBot!)
  }
  
  public func setupProfileImg() {
    profileImg = UIImageView()
    bgView?.addSubview(profileImg!)
  }
  
  public func setupUsernameLabel() {
    profileUsername = UILabel()
    profileUsername?.text = model.user?.username
    profileUsername?.font = UIFont.asapBold(24)
    profileUsername?.textAlignment = .Center
    profileUsername?.textColor = .coolBlack()
    bgView?.addSubview(profileUsername!)
  }
  
  private func setupDescriptionTextView() {
    descriptionTextView = UITextView()
    descriptionTextView?.editable = false
    descriptionTextView?.showsVerticalScrollIndicator = false
    descriptionTextView?.font = .asapRegular(12)
    descriptionTextView?.backgroundColor = .whiteColor()
    descriptionTextView?.textColor = .coolBlack()
    scrollView?.addSubview(descriptionTextView!)
  }
  
  private func setupBookshelf() {
    bookShelf = DLTableView()
    bookShelf?.delegate = self
    bookShelf?.dataSource = self
    bookShelf?.scrollEnabled = false
    bookShelf?.multipleTouchEnabled = true
    bookShelf?.backgroundColor = .whiteColor()
    scrollView?.addSubview(bookShelf!)
  }
  
  private func setupButtons() {
    if isOtherUser == false {
      let myImage = UIImage(named: "Icon-SettingsGear")
      let resizedImage = Toucan.Resize.resizeImage(myImage!, size: CGSize(width: screenSize.width/20, height: screenSize.width/20))
      
      let settingsButton = UIBarButtonItem(image: resizedImage, style: UIBarButtonItemStyle.Plain, target: self, action: "settingsButtonPressed")
      
      //settingsButton.action
      // TODO: check if user is self
      self.navigationItem.rightBarButtonItem = settingsButton
      
    } else {
      
      let iconWidth = screen.width / 12
      
      var myImage = UIImage(named: "Call Icon-2")
      var resizedImage = Toucan.Resize.resizeImage(myImage!, size: CGSize(width: iconWidth, height: iconWidth))
      resizedImage?.imageWithRenderingMode(.AlwaysOriginal)
      
      callButton = UIButton()
      callButton?.addTarget(self, action: "callFriend", forControlEvents: .TouchUpInside)
      callButton?.setImage(resizedImage, forState: .Normal)
      callButton?.frame = CGRectMake(screen.width * (1 / 3) - iconWidth / 2, 0, iconWidth, iconWidth)
      callButton?.alpha = isOtherUser == true ? 0.0 : model.user?.phone != nil ? model.user?.privatePhoneNumber == false ? 1.0 : 0.0 : 0.0
      callButton?.hidden = true
     
      myImage = UIImage(named: "Message Icon-1")
      resizedImage = Toucan.Resize.resizeImage(myImage!, size: CGSize(width: iconWidth, height: iconWidth))
      resizedImage?.imageWithRenderingMode(.AlwaysOriginal)
      
      chatButton = UIButton()
      chatButton?.addTarget(self, action: "chatFriend", forControlEvents: .TouchUpInside)
      chatButton?.setImage(resizedImage, forState: .Normal)
      chatButton?.frame = CGRectMake(screen.width * (2 / 3) - iconWidth / 2, 0, iconWidth, iconWidth)
      chatButton?.hidden = true
      
      descriptionTextView?.addSubview(callButton!)
      descriptionTextView?.addSubview(chatButton!)
      
      
      myImage = nil
      resizedImage = nil
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
  
  public func setIsOtherUser(isOtherUser: Bool?) -> Self {
    self.isOtherUser = isOtherUser
    return self
  }
  
  public func setUser(user: User?) -> Self {
    // fixture
    guard let user = user else { return self}
    // read the user currently logged in
    controller.readRealmUser()
    isOtherUser = user._id != model.user?._id
    // Check if incoming set user is the current user or is another user
    if isOtherUser == true {
      //self.isOtherUser = is
      model.user = user
    }
    
    controller.changeOtherUserBoolean(isOtherUser)
    
    return self
  }
  
  // MARK: Button Action
  
  public func settingsButtonPressed(){
    navigationController?.pushViewController(SettingsView(), animated: true)
  }
  
  public func callFriend(){
    self.model.user?.phone?.callNumber()
  }
  
  public func chatFriend(){
    TabView.currentView()?.pushViewController(ChatView().setUsers(UserModel.sharedUser().user, friend: model.user), animated: true)
  }
  
  
  // MARK: Table View Delegates
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0:
      if (model.user?.listings.filter { $0.listType == "selling" })?.first == nil {
        return 48
      }
      break
    case 1:
      if (model.user?.listings.filter { $0.listType == "buying" })?.first == nil {
        return 48
      }
      break
    default: break
    }
    return 235
  }

  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    guard let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileListView", forIndexPath: indexPath) as? UserProfileListView else { return DLTableViewCell() }
    
    switch indexPath.row {
    case 0:
      
      cell.tag = 0
      cell.label?.text =  "I'm Selling"
      cell.label?.font = .asapBold(16)
      
      if let user = model.user, let listings = (model.user?.listings.filter { $0.listType == "selling" }) where user._id != nil && listings.first?.book?._id != nil {
        
        // set data
        cell.controller.model.bookList = listings
      }
        
      cell.onBadgeButtonPress = { [weak self] in
        self?.presentViewController(SearchBookView().setOnDismiss() { [weak self] in
          self?.presentViewController(CreateListingView().setBook(SearchBookModel.sharedInstance().book).setListType("selling"), animated: true, completion: nil)
        }, animated: true, completion: nil)
      }
      
      break
    case 1:
      
      cell.tag = 1
      cell.label?.text = "I'm Buying"
      cell.label?.font = .asapBold(16)
      
      if let user = model.user, let listings = (model.user?.listings.filter { $0.listType == "buying" }) where user._id != nil && listings.first?.book?._id != nil {
        
        // set data
        cell.controller.model.bookList = listings
      }
      
      cell.onBadgeButtonPress = { [weak self] in
        self?.presentViewController(SearchBookView().setOnDismiss() { [weak self] in
          self?.presentViewController(CreateListingView().setBook(SearchBookModel.sharedInstance().book).setListType("buying"), animated: true, completion: nil)
        }, animated: true, completion: nil)
      }

      break
    default: break
    }
    
    // add databinding to cells
    cell._didSelectListing.removeAllListeners()
    cell._didSelectListing.listen(self) { [weak navigationController] list_id in
      navigationController?.pushViewController(ListViewContainer().setList_id(list_id).isUserListing(), animated: true)
    }
    
    cell._didSelectMatch.removeAllListeners()
    cell._didSelectMatch.listen(self) { [weak navigationController] list_id in
      navigationController?.pushViewController(ListViewContainer().setList_id(list_id), animated: true)
    }
    
    return cell
  }
  
  // MARK: Scroll View Delegates
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let offset: CGFloat? = -scrollView.contentOffset.y where offset > 0 {
      let ratio = originalBGViewFrame!.width / originalBGViewFrame!.height
      bgViewTop?.frame = CGRectMake(originalBGViewFrame!.origin.x - offset!, originalBGViewFrame!.origin.y - offset!, originalBGViewFrame!.width + (offset! * ratio), originalBGViewFrame!.height + (offset!))
      
      // if the offset is greater than 64, then call the server to update the user object in the model
      // Refresh
      if offset >= 128 && model.shouldRefrainFromCallingServer == false {
        if isOtherUser == false { controller.readRealmUser() }
        controller.getUserFromServer()
      }
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
    layer.shadowColor = UIColor.coolBlack().CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.4
    layer.shadowRadius = 3
  }
}


public class UserProfileListView: DLTableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
  
  public var label: UILabel?
  public var badgeButton: MIBadgeButton?
  
  public var collectionViewLayout: UICollectionViewFlowLayout?
  public var collectionView: UICollectionView?
  
  public let controller = UserProfileListingController()
  public var model: UserProfileListingModel { get { return controller.model } }
  
  public let _collectionViewFrame = Signal<CGRect>()
  public var collectionViewFrame: CGRect = CGRectZero { didSet { _collectionViewFrame => collectionViewFrame } }
  
  public let _didSelectListing = Signal<String?>()
  public let _didSelectMatch = Signal<String?>()
  
  public var onBadgeButtonPress: (() -> Void)?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupDataBinding()
    setupCollectionView()
    setupAttributes()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    if model.bookList.isEmpty {
      label?.anchorToEdge(.Left, padding: 8, width: 76, height: 36)
    } else {
      label?.anchorInCorner(.TopLeft, xPad: 8, yPad: 8, width: 76, height: 36)
    }
    
    badgeButton?.align(.ToTheRightCentered, relativeTo: label!, padding: 0, width: 48, height: 48)
    badgeButton?.badgeEdgeInsets = UIEdgeInsetsMake(20, -12, 0, 0)
    badgeButton?.badgeString = ((label?.text == "I'm Selling") ? "\(UserModel.sharedUser().user?.freeListings ?? 0)" : nil)
    badgeButton?.addTarget(self, action: "badgeButtonPressed", forControlEvents: .TouchUpInside)
    
    collectionView?.alignAndFill(align: .UnderCentered, relativeTo: label!, padding: 0)
    collectionViewFrame = collectionView!.frame
    collectionViewLayout?.itemSize = CGSizeMake(100, collectionViewFrame.height)
  }
  
  private func setupDataBinding() {
    model._bookList.listen(self) { [weak self] list in
      self?.collectionView?.reloadData()
    }
  }
  
  private func setupCollectionView() {
    
    collectionViewLayout = UICollectionViewFlowLayout()
    collectionViewLayout?.scrollDirection = .Horizontal
    
    collectionView?.removeFromSuperview()
    collectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: collectionViewLayout!)
    collectionView?.registerClass(ListCell.self, forCellWithReuseIdentifier: "ListCell")
    collectionView?.delegate = self
    collectionView?.dataSource = self
    collectionView?.backgroundColor = UIColor.whiteColor()
    collectionView?.showsHorizontalScrollIndicator = false
    collectionView?.multipleTouchEnabled = true
    
    addSubview(collectionView!)
  }
  
  private func setupAttributes() {
    label = UILabel()
    label?.font = UIFont.systemFontOfSize(16)
    label?.textColor = UIColor.coolBlack()
    addSubview(label!)
    
    badgeButton = MIBadgeButton(type: .ContactAdd)
    badgeButton?.addTarget(self, action: "badgeButtonPressed", forControlEvents: .TouchUpInside)
    addSubview(badgeButton!)
  }
  
  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    return UIEdgeInsetsMake(0, 8, 0, 8)
  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return model.bookList.count
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    
    if let cell = collectionView.dequeueReusableCellWithReuseIdentifier("ListCell", forIndexPath: indexPath) as? ListCell {
      
      cell.setListing(model.bookList[indexPath.row])
      
      // databind the cells
      cell._didSelectListing.removeListener(self)
      cell._didSelectListing.listen(self) { [weak self] list_id in
        self?._didSelectListing.fire(list_id)
      }
      
      // databind the cells
      cell._didSelectMatch.removeListener(self)
      cell._didSelectMatch.listen(self) { [weak self] list_id in
        self?._didSelectMatch.fire(list_id)
      }
      
      return cell
    }
    
    return UICollectionViewCell()
  }
  
  public func badgeButtonPressed() {
    onBadgeButtonPress?()
  }
}

public class ListCell: UICollectionViewCell {
  
  public var listing: Listing?
  
  private var containerView: UIView?
  
  public var bookImageView: UIImageView?
  public var bookPriceLabel: UILabel?
  
  public var matchInfoView: UIView?
  public var matchUserImageView: UIImageView?
  public var matchPriceLabel: UILabel?
  public var matchUserNameLabel: UILabel?
  
  public let _didSelectListing = Signal<String?>()
  public let _didSelectMatch = Signal<String?>()
  
  private var matchTapGesture: UITapGestureRecognizer?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupSelf()
    setupContainerView()
    setupBookImageView()
    setupBookPriceLabel()
    setupMatchInfoView()
    setupMatchUserImageView()
    setupMatchPriceLabel()
    setupMatchUserNameLabel()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView?.fillSuperview(left: 0, right: 0, top: 0, bottom: 5)
    
    bookImageView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 150)
    bookPriceLabel?.alignAndFillWidth(align: .UnderCentered, relativeTo: bookImageView!, padding: 4, height: 12)
    matchInfoView?.anchorAndFillEdge(.Bottom, xPad: 0, yPad: 0, otherSize: 32)
//    matchInfoView?.alignAndFillWidth(align: .UnderCentered, relativeTo: bookPriceLabel!, padding: 0, height: 36)
    matchUserImageView?.anchorInCorner(.TopLeft, xPad: 4, yPad: 4, width: 24, height: 24)
    matchPriceLabel?.alignAndFill(align: .ToTheRightCentered, relativeTo: matchUserImageView!, padding: 4)
    
    // load the UI for the listing once the frame's have been set
    loadListingIntoView()
  }
  
  private func setupSelf() {
    backgroundColor = .whiteColor()
  }
  
  private func setupContainerView() {
    containerView = UIView()
    containerView?.backgroundColor = .whiteColor()
    containerView?.layer.shadowColor = UIColor.darkGrayColor().CGColor
    containerView?.layer.shadowOffset = CGSize(width: 2.0, height: 2.0)
    containerView?.layer.shadowOpacity = 0.5
    containerView?.layer.shadowRadius = 2
    containerView?.layer.masksToBounds = true
    containerView?.clipsToBounds = false
    addSubview(containerView!)
  }
  
  private func setupBookImageView() {
    bookImageView?.removeFromSuperview()
    bookImageView = UIImageView()
    bookImageView?.userInteractionEnabled = true
    bookImageView?.backgroundColor = .whiteColor()
    bookImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectedListing"))
    
    containerView?.addSubview(bookImageView!)
  }
  
  private func setupBookPriceLabel() {
    bookPriceLabel = UILabel()
    bookPriceLabel?.textColor = UIColor.moneyGreen()
    bookPriceLabel?.font = UIFont.asapBold(12)
    bookPriceLabel?.adjustsFontSizeToFitWidth = true
    bookPriceLabel?.minimumScaleFactor = 0.1
    bookPriceLabel?.backgroundColor = .whiteColor()
    containerView?.addSubview(bookPriceLabel!)
  }
  
  private func setupMatchInfoView() {
    matchInfoView = UIView()
    matchInfoView?.userInteractionEnabled = true
    matchInfoView?.backgroundColor = .whiteColor()
    containerView?.addSubview(matchInfoView!)
    
    matchTapGesture = UITapGestureRecognizer(target: self, action: "selectedMatch")
    matchInfoView?.addGestureRecognizer(matchTapGesture!)
  }
  
  private func setupMatchUserImageView() {
    matchUserImageView = UIImageView()
    matchInfoView?.addSubview(matchUserImageView!)
  }
  
  private func setupMatchPriceLabel() {
    matchPriceLabel = UILabel()
    matchPriceLabel?.textColor = .whiteColor()
    matchPriceLabel?.font = .asapBold(12)
    matchPriceLabel?.adjustsFontSizeToFitWidth = true
    matchPriceLabel?.minimumScaleFactor = 0.1
    matchInfoView?.addSubview(matchPriceLabel!)
  }
  
  private func setupMatchUserNameLabel() {
    matchUserNameLabel = UILabel()
    matchUserNameLabel?.textColor = .coolBlack()
    matchUserNameLabel?.font = .asapRegular(12)
    matchUserNameLabel?.adjustsFontSizeToFitWidth = true
    matchUserNameLabel?.minimumScaleFactor = 0.1
    matchInfoView?.addSubview(matchUserNameLabel!)
  }
  
  public func selectedMatch() {
    _didSelectMatch => listing?.highestLister?._id
  }
  
  public func selectedListing() {
    _didSelectListing => listing?._id
  }
  
  public func setListing(listing: Listing?) {
    self.listing = listing
    loadListingIntoView()
  }
  
  private func loadListingIntoView() {
    
    // load book image once the image view's frame has been set
    bookImageView?.dl_setImageFromUrl(listing?.book?.getImageUrl())
    
    // set user price label
    bookPriceLabel?.text = nil
    
    Async.background { [weak listing] in
      
      var coloredString: NSMutableAttributedString? = NSMutableAttributedString(string: "Price: \(listing?.getPriceText() ?? "")")
      coloredString?.addAttribute(NSForegroundColorAttributeName, value: UIColor.coolBlack(), range: NSRange(location: 0,length: 6))
      coloredString?.addAttribute(NSFontAttributeName, value: UIFont.asapRegular(12), range: NSRange(location: 0,length: 6))
      
      Async.main { [weak self] in
        
        self?.bookPriceLabel?.attributedText = coloredString
        
        coloredString = nil
      }
    }
    
    matchUserImageView?.image = nil
    matchPriceLabel?.text = nil
    
    if listing?.highestLister != nil && listing?.highestLister?.user?._id != listing?.user?._id {
      
      containerView?.layer.borderColor = UIColor.juicyOrange().CGColor
      containerView?.layer.borderWidth = 1.0
      
      matchInfoView?.backgroundColor = .juicyOrange()
      
      // unhide the match info view
      matchInfoView?.hidden = false
      // set highest matcher's user imagee
      matchUserImageView?.dl_setImageFromUrl(listing?.highestLister?.user?.imageUrl, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
      // set highest matcher's list price
      matchPriceLabel?.text = "Best \(listing?.highestLister?.getListTypeText2() ?? "") \(listing?.highestLister?.getPriceText() ?? "")"
      // resize the container view
      containerView?.removeConstraints(containerView!.constraints)
      containerView?.fillSuperview(left: 0, right: 0, top: 0, bottom: 5)
      containerView?.layer.shadowPath = UIBezierPath(roundedRect: containerView!.bounds, cornerRadius: 0).CGPath
    } else {
      // hide the match info view
      matchInfoView?.hidden = true
      // resize the container view
      containerView?.removeConstraints(containerView!.constraints)
      containerView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 175)
      containerView?.layer.shadowPath = UIBezierPath(roundedRect: containerView!.bounds, cornerRadius: 0).CGPath
    }
  }
}

