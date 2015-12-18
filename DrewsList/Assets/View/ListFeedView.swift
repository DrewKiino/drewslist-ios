//
//  ListFeedView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit

public class ListFeedViewContainer: UIView, UIScrollViewDelegate {
  
  private var scrollView: UIScrollView?
  private var pageTitleContainer: UIView?
  private var leftPageTitleButton: UIButton?
  private var rightPageTitleButton: UIButton?
  private var pageSelector: UIView?
  
  private var shouldDisableScrollDetection: Bool = false
  
  public var saleListFeedView: ListFeedView?
  public var wishListFeedView: ListFeedView?
  
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
    
    pageTitleContainer?.anchorAndFillEdge(.Top, xPad: 8, yPad: 4, otherSize: 24)
    
    pageTitleContainer?.groupAndFill(group: .Horizontal, views: [leftPageTitleButton!, rightPageTitleButton!], padding: 0)
    
    pageSelector?.frame = rightPageTitleButton!.frame
    
    scrollView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 32, otherSize: screen.height - 148 - 32)
    
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
    pageTitleContainer = UIView()
    pageTitleContainer?.backgroundColor = .whiteColor()
    pageTitleContainer?.layer.cornerRadius = 8.0
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
    leftPageTitleButton?.setTitleColor(.blackColor(), forState: .Normal)
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
    rightPageTitleButton?.setTitleColor(.blackColor(), forState: .Normal)
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
    scrollView?.addSubview(saleListFeedView!)
    
    saleListFeedView?.showLoadingScreen(-132)
  }
  
  public func setupWishListFeed() {
    wishListFeedView = ListFeedView()
    wishListFeedView?.setListType("buying")
    scrollView?.addSubview(wishListFeedView!)
    
    wishListFeedView?.showLoadingScreen(-132)
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
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [unowned self] in
        self.pageSelector?.frame = self.leftPageTitleButton!.frame
        }, completion: { [weak self] bool in
          self?.shouldDisableScrollDetection = false
        })
      break
    case .Right:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [unowned self] in
        self.pageSelector?.frame = self.rightPageTitleButton!.frame
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
}

public class ListFeedView: UITableView, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = ListFeedController()
  private var model: ListFeedModel { get { return controller.getModel() } }
  
  public init() {
    super.init(frame: CGRectZero, style: .Plain)
    
    setupDataBinding()
    setupTableView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  private func setupDataBinding() {
    model._listings.listen(self) { [weak self] listings in
      self?.reloadData()
    }
    model._listType.listen(self) { [weak self] listType in
      self?.model.listings.removeAll(keepCapacity: false)
      self?.controller.getListingsFromServer(0, listType: listType)
    }
  }
  
  private func setupTableView() {
    registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    registerClass(ListFeedCell.self, forCellReuseIdentifier: "ListFeedCell")
    delegate = self
    dataSource = self
    separatorColor = .clearColor()
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 420
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.listings.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let listing = model.listings[indexPath.row]
    
    let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("ListFeedCell", forIndexPath: indexPath) as? ListFeedCell {
      cell.listView?.setListing(listing)
    }
    
    return cell
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if contentOffset.y >= (contentSize.height - frame.size.height) &&
        frame.height > 0 && controller.getModel().shouldLockView == false && controller.getModel().shouldRefrainFromCallingServer == false
    {
      // user has scrolled to the bottom!
      // begin getting more data
      controller.getListingsFromServer(model.listings.count, listType: model.listType)
    }
  }
  
  public func setListType(listType: String?) {
    guard let listType = listType else { return }
    
    model.listType = listType
  }
}

public class ListFeedCell: UITableViewCell {
  
  public var listView: ListView?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupListView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    listView?.fillSuperview()
  }
  
  private func setupListView() {
    listView = ListView()
    listView?.tableView?.scrollEnabled = false
    addSubview(listView!)
  }
}