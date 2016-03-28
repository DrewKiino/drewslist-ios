//
//  ListFeedView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class ListFeedNavigationView: DLNavigationController {
  
  public var listFeedViewContainer: ListFeedViewContainer?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setRootViewTitle("Community")
    setupListFeedViewContainer()
    
    FBSDKController.createCustomEventForName("UserListFeed")
  }
  
  private func setupListFeedViewContainer() {
    listFeedViewContainer = ListFeedViewContainer()
    rootView?.view = listFeedViewContainer
    
    rootView?.navigationItem.rightBarButtonItem = UIBarButtonItem(
      image: Toucan(image: UIImage(named: "Icon-Search-1")).resize(CGSize(width: 24, height: 24)).image,
      style: UIBarButtonItemStyle.Done,
      target: self,
      action: "selectedSearchButton"
    )
  }
  
  public func selectedSearchButton() {
    pushViewController(SearchListingView(), animated: true)
  }
}

public class ListFeedViewContainer: UIView, UIScrollViewDelegate {
  
  private var scrollView: UIScrollView?
  private var pageTitleContainer: UIView?
  private var pageTitleBorderFrame: UIView?
  private var leftPageTitleButton: UIButton?
  private var rightPageTitleButton: UIButton?
  private var pageSelector: UIView?
  
  private var shouldDisableScrollDetection: Bool = false
  
  public var saleListFeedView: ListFeedView?
  public var wishListFeedView: ListFeedView?
  
  public let _chatButtonPressed = Signal<Listing?>()
  public let _callButtonPressed = Signal<Listing?>()
  public let _bookProfilePressed = Signal<Book?>()
  public let _userImagePressed = Signal<User?>()
  
  public init() {
    super.init(frame: CGRectZero)
    
    setupScrollView()
    setupPageTitleContainer()
    setupPageSelector()
    setupLeftPageTitleButton()
    setupRightPageTitleButton()
 
    setupSaleListFeed()
    setupWishListFeed()
    
    // select middle page
    scrollView?.contentSize = CGSizeMake(screen.width * 2, screen.height / 2)
    shouldDisableScrollDetection = true
    scrollView?.setContentOffset(CGPointMake(screen.width, 0), animated: false)
    selectPage(.Right)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    pageTitleContainer?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 55)
    
    pageTitleBorderFrame?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 56)
    pageTitleBorderFrame?.backgroundColor = .tableViewNativeSeparatorColor()
    
    pageTitleContainer?.groupAndFill(group: .Horizontal, views: [leftPageTitleButton!, rightPageTitleButton!], padding: 8)
    
    pageSelector?.frame = rightPageTitleButton!.frame
    
//    scrollView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 32, otherSize: screen.height - 32 - 112)
    scrollView?.alignAndFill(align: .UnderCentered, relativeTo: pageTitleContainer!, padding: 0)
    
    wishListFeedView?.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: screen.width)
    saleListFeedView?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: wishListFeedView!, padding: 0, width: screen.width)
  }
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView?.scrollEnabled = true
    scrollView?.pagingEnabled = true
    scrollView?.showsHorizontalScrollIndicator = false
    scrollView?.delegate = self
    addSubview(scrollView!)
  }
  
  private func setupPageTitleContainer() {
    pageTitleBorderFrame = UIView()
    addSubview(pageTitleBorderFrame!)
    
    pageTitleContainer = UIView()
    pageTitleContainer?.backgroundColor = .whiteColor()
    addSubview(pageTitleContainer!)
  }
  
  private func setupPageSelector() {
    pageSelector = UIView()
    pageSelector?.backgroundColor = .sweetBeige()
    pageSelector?.layer.cornerRadius = 8.0
    pageSelector?.layer.masksToBounds = false
    pageSelector?.clipsToBounds = true
    pageTitleContainer?.addSubview(pageSelector!)
  }
  
  private func setupLeftPageTitleButton() {
    leftPageTitleButton = UIButton()
    leftPageTitleButton?.setTitle("Buyers", forState: .Normal)
    leftPageTitleButton?.setTitleColor(.coolBlack(), forState: .Normal)
    leftPageTitleButton?.titleLabel?.font = .asapBold(12)
    leftPageTitleButton?.titleLabel?.textAlignment = .Center
    leftPageTitleButton?.layer.masksToBounds = true
    leftPageTitleButton?.backgroundColor = .clearColor()
    leftPageTitleButton?.addTarget(self, action: "selectLeftPage", forControlEvents: .TouchUpInside)
    pageTitleContainer?.addSubview(leftPageTitleButton!)
  }
  
  private func setupRightPageTitleButton() {
    rightPageTitleButton = UIButton()
    rightPageTitleButton?.setTitle("Sellers", forState: .Normal)
    rightPageTitleButton?.setTitleColor(.coolBlack(), forState: .Normal)
    rightPageTitleButton?.titleLabel?.font = .asapBold(12)
    rightPageTitleButton?.titleLabel?.textAlignment = .Center
    rightPageTitleButton?.titleLabel?.layer.masksToBounds = true
    rightPageTitleButton?.backgroundColor = .clearColor()
    rightPageTitleButton?.addTarget(self, action: "selectRightPage", forControlEvents: .TouchUpInside)
    pageTitleContainer?.addSubview(rightPageTitleButton!)
  }
  
  public func setupSaleListFeed() {
    saleListFeedView = ListFeedView()
    saleListFeedView?.setListType("selling")
    saleListFeedView?._callButtonPressed.removeAllListeners()
    saleListFeedView?._callButtonPressed.listen(self) { [weak self] listing in
      self?._callButtonPressed.fire(listing)
    }
    saleListFeedView?._chatButtonPressed.removeAllListeners()
    saleListFeedView?._chatButtonPressed.listen(self) { [weak self] listing in
      self?._chatButtonPressed.fire(listing)
    }
    saleListFeedView?._bookProfilePressed.removeAllListeners()
    saleListFeedView?._bookProfilePressed.listen(self) { [weak self] book in
      self?._bookProfilePressed.fire(book)
    }
    saleListFeedView?._userImagePressed.removeAllListeners()
    saleListFeedView?._userImagePressed.listen(self) { [weak self] user in
      self?._userImagePressed.fire(user)
    }
    scrollView?.addSubview(saleListFeedView!)
  }
  
  public func setupWishListFeed() {
    wishListFeedView = ListFeedView()
    wishListFeedView?.setListType("buying")
    wishListFeedView?._callButtonPressed.removeAllListeners()
    wishListFeedView?._callButtonPressed.listen(self) { [weak self] listing in
      self?._callButtonPressed.fire(listing)
    }
    wishListFeedView?._chatButtonPressed.removeAllListeners()
    wishListFeedView?._chatButtonPressed.listen(self) { [weak self] listing in
    }
    wishListFeedView?._bookProfilePressed.removeAllListeners()
    wishListFeedView?._bookProfilePressed.listen(self) { [weak self] book in
      self?._bookProfilePressed.fire(book)
    }
    wishListFeedView?._userImagePressed.removeAllListeners()
    wishListFeedView?._userImagePressed.listen(self) { [weak self] user in
      print("listFeedViewContainer")
      self?._userImagePressed.fire(user)
    }
    scrollView?.addSubview(wishListFeedView!)
  }
  
  public func selectLeftPage() {
    shouldDisableScrollDetection = true
    scrollView?.setContentOffset(CGPointMake(0, 0), animated: true)
    selectPage(.Left)
  }
  
  public func selectRightPage() {
    shouldDisableScrollDetection = true
    scrollView?.setContentOffset(CGPointMake(screen.width, 0), animated: true)
    selectPage(.Right)
  }
  
  public func selectPage(page: ListFeedPage) {
    let duration: NSTimeInterval = 0.7
    let damping: CGFloat = 0.5
    let velocity: CGFloat = 1.0
    switch page {
    case .Left:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        self?.pageSelector?.frame = self!.leftPageTitleButton!.frame
      }, completion: { [weak self] bool in
        self?.shouldDisableScrollDetection = false
      })
      break
    case .Right:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        self?.pageSelector?.frame = self!.rightPageTitleButton!.frame
      }, completion: { [weak self] bool in
        self?.shouldDisableScrollDetection = false
      })
      break
    }
  }
  
  // MARK: Scroll View Delegates
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let offset: CGFloat? = scrollView.contentOffset.x where offset > 0 && shouldDisableScrollDetection == false {
      switch Float(offset!) {
      case 0...Float(screen.width * 0.5):
        selectPage(.Left)
        break
      case Float(screen.width * 0.5 + 1)...Float(screen.width * 1.5 + -1):
        selectPage(.Right)
        break
      default: break
      }
    }
  }
  
  public enum ListFeedPage {
    case Left
    case Right
  }
  
  public func getListingsFromServer(skip: Int?, listing: String?) {
    if listing == "buying" { wishListFeedView?.getListingsFromServer(skip, listing: listing, clearListings: true) }
    else if listing == "selling" { saleListFeedView?.getListingsFromServer(skip, listing: listing, clearListings: true) }
  }
}

public class ListFeedView: UIView, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = ListFeedController()
  private var model: ListFeedModel { get { return controller.getModel() } }
  
  private var tableView: DLTableView?
  
  private var refreshControl: UIRefreshControl?
  
  public let _chatButtonPressed = Signal<Listing?>()
  public let _callButtonPressed = Signal<Listing?>()
  public let _bookProfilePressed = Signal<Book?>()
  public let _userImagePressed = Signal<User?>()
  
  public init() {
    super.init(frame: CGRectZero)
    
    setupDataBinding()
    setupTableView()
    setupRefreshControl()
    
    showActivityView(-119, width: nil, height: nil)
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    tableView?.showsVerticalScrollIndicator = true
    tableView?.fillSuperview()
  }
  
  private func setupDataBinding() {
    controller.shouldRefreshViews.removeAllListeners()
    controller.shouldRefreshViews.listen(self) { [weak self] listings in
      
      self?.dismissActivityView()
      
      self?.tableView?.reloadData()
      
      NSTimer.after(1.0) { [weak self] in
        self?.refreshControl?.endRefreshing()
      }
    }
    
    model._listType.removeAllListeners()
    model._listType.listen(self) { [weak self] listType in
      self?.controller.getListingsFromServer(0, listType: listType, clearListings: true)
    }
    
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
    }
    
    UserController.sharedUser()._user.removeListener(self)
    UserController.sharedUser()._user.listen(self) { [weak self] user in
      self?.model.user = user
      self?.tableView?.reloadData()
    }
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.backgroundColor = .whiteColor()
    addSubview(tableView!)
  }
  
  private func setupRefreshControl() {
    refreshControl = UIRefreshControl()
    refreshControl?.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
    tableView?.addSubview(refreshControl!)
  }
  
  // MARK: UIRefreshControl methods
  
  public func refresh(sender: UIRefreshControl) {
    refreshControl?.beginRefreshing()
    controller.getListingsFromServer(clearListings: true)
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    
    if !model.listings.isEmpty, let notes = model.listings[indexPath.row].notes where !notes.isEmpty {
      
      let height = NSAttributedString(string: notes).heightWithConstrainedWidth(screen.width)
      
      return 325 + (height < 100 ? height : 100)
      
    } else if indexPath.row < model.listings.count { return 275 }
      
    else { return 48 }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.listings.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("ListFeedCell", forIndexPath: indexPath) as? ListFeedCell where model.listings.count > indexPath.row {
      cell.isUserListing = model.user?._id == model.listings[indexPath.row].user?._id
      cell.listView?.setListing(model.listings[indexPath.row])
      cell.listView?._callButtonPressed.removeAllListeners()
      cell.listView?._callButtonPressed.listen(self) { [weak self] bool in
        self?._callButtonPressed.fire(self?.model.listings[indexPath.row])
      }
      cell.listView?._chatButtonPressed.removeAllListeners()
      cell.listView?._chatButtonPressed.listen(self) { [weak self] bool in
        self?._chatButtonPressed.fire(self?.model.listings[indexPath.row])
      }
      cell.listView?._bookProfilePressed.removeAllListeners()
      cell.listView?._bookProfilePressed.listen(self) { [weak self] book in
        self?._bookProfilePressed.fire(book)
      }
      cell.listView?._userProfilePressed.removeAllListeners()
      cell.listView?._userProfilePressed.listen(self) { [weak self] user in
        self?._userImagePressed.fire(user)
      }
      //      cell.showSeparatorLine()
      cell.showBottomBorder()
      
      return cell
    }
    
    return DLTableViewCell()
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    guard let tableView = tableView else { return }
    if tableView.contentOffset.y >= (tableView.contentSize.height - frame.size.height) && frame.height > 0 {
      // user has scrolled to the bottom!
      // begin getting more data
      controller.getListingsFromServer(model.listings.count, listType: model.listType, clearListings: false)
    }
  }
  
  public func setListType(listType: String?) {
    guard let listType = listType else { return }
    
    model.listType = listType
  }
  
  public func getListingsFromServer(skip: Int?, listing: String?, clearListings: Bool) {
    controller.getModel().listings.removeAll(keepCapacity: false)
    controller.getListingsFromServer(skip, listType: listing, clearListings: clearListings)
  }
}

public class ListFeedCell: DLTableViewCell {
  
  public var listView: ListView?
  
  public let _cellPressed = Signal<Bool>()
  
  public var isUserListing: Bool = false { didSet { listView?.isUserListing = isUserListing } }
  
  public override func setupSelf() {
    super.setupSelf()
    
    setupListView()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "cellPressed"))
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    listView?.fillSuperview()
  }
  
  private func setupListView() {
    listView = ListView()
    listView?.tableView?.scrollEnabled = false
    listView?.isUserListing = isUserListing
    addSubview(listView!)
  }
  
  public func cellPressed() {
    _cellPressed => true
  }
}

