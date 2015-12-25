//
//  CommunityView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/17/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon

public class CommunityFeedView: DLNavigationController, UIScrollViewDelegate {
  
  private let controller = CommunityFeedController()
  private var model: CommunityFeedModel { get { return controller.model } }
  
  private var scrollView: UIScrollView?
  
  private var pageTitleContainer: UIView?
  private var leftPageTitleButton: UIButton?
  private var middlePageTitleButton: UIButton?
  private var rightPageTitleButton: UIButton?
  private var pageSelector: UIView?
  
  private var shouldDisableScrollDetection: Bool = false
  
  private var currentPage: CommunityPage = .Middle
  
  public var leftPage: UIView?
  public var middlePage: ListFeedViewContainer?
  public var rightPage: UIView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupPageTitleContainer()
    setupPageSelector()
    setupLeftPageTitleButton()
    setupMiddlePageTitleButton()
    setupRightPageTitleButton()
    setupScrollView()
    setupPages()
    
    scrollView?.contentSize = CGSizeMake(screen.width * 3, screen.height / 2)
    // select middle page
    shouldDisableScrollDetection = true
    scrollView?.setContentOffset(CGPointMake(screen.width, 0), animated: false)
    selectPage(.Middle)
    
    view.backgroundColor = .whiteColor()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    pageTitleContainer?.anchorAndFillEdge(.Top, xPad: 8, yPad: 0, otherSize: 36)
    pageTitleContainer?.groupAndFill(group: .Horizontal, views: [leftPageTitleButton!, middlePageTitleButton!, rightPageTitleButton!], padding: 0)
    
    pageSelector?.frame = middlePageTitleButton!.frame
    
    scrollView?.alignAndFillHeight(align: .UnderCentered, relativeTo: pageTitleContainer!, padding: 0, width: screen.width)
    
    leftPage?.anchorAndFillEdge(.Left, xPad: 0, yPad: 0, otherSize: screen.width)
    middlePage?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: leftPage!, padding: 0, width: screen.width)
    rightPage?.alignAndFillHeight(align: .ToTheRightCentered, relativeTo: middlePage!, padding: 0, width: screen.width)
    
    leftPage?.showComingSoonScreen()
    rightPage?.showComingSoonScreen()
  }
  
  private func setupSelf() {
  }
  
  private func setupPageTitleContainer() {
    pageTitleContainer = UIView()
    pageTitleContainer?.backgroundColor = .whiteColor()
    rootView?.view.addSubview(pageTitleContainer!)
  }
  
  private func setupPageSelector() {
    pageSelector = UIView()
    pageSelector?.backgroundColor = .sweetBeige()
    pageSelector?.layer.cornerRadius = 8.0
    pageTitleContainer?.addSubview(pageSelector!)
  }
  
  private func setupLeftPageTitleButton() {
    leftPageTitleButton = UIButton()
    leftPageTitleButton?.setTitle("Classrooms", forState: .Normal)
    leftPageTitleButton?.setTitleColor(.blackColor(), forState: .Normal)
    leftPageTitleButton?.titleLabel?.font = .asapBold(12)
    leftPageTitleButton?.titleLabel?.textAlignment = .Center
    leftPageTitleButton?.layer.masksToBounds = true
    leftPageTitleButton?.backgroundColor = .clearColor()
    leftPageTitleButton?.addTarget(self, action: "selectLeftPage", forControlEvents: .TouchUpInside)
    pageTitleContainer?.addSubview(leftPageTitleButton!)
  }
  
  private func setupMiddlePageTitleButton() {
    middlePageTitleButton = UIButton()
    middlePageTitleButton?.setTitle("Listings", forState: .Normal)
    middlePageTitleButton?.setTitleColor(.blackColor(), forState: .Normal)
    middlePageTitleButton?.titleLabel?.font = .asapBold(12)
    middlePageTitleButton?.titleLabel?.textAlignment = .Center
    middlePageTitleButton?.titleLabel?.layer.masksToBounds = true
    middlePageTitleButton?.backgroundColor = .clearColor()
    middlePageTitleButton?.addTarget(self, action: "selectMiddlePage", forControlEvents: .TouchUpInside)
    pageTitleContainer?.addSubview(middlePageTitleButton!)
  }
  
  private func setupRightPageTitleButton() {
    rightPageTitleButton = UIButton()
    rightPageTitleButton?.setTitle("Professors", forState: .Normal)
    rightPageTitleButton?.setTitleColor(.blackColor(), forState: .Normal)
    rightPageTitleButton?.titleLabel?.font = .asapBold(12)
    rightPageTitleButton?.titleLabel?.textAlignment = .Center
    rightPageTitleButton?.titleLabel?.layer.masksToBounds = true
    rightPageTitleButton?.backgroundColor = .clearColor()
    rightPageTitleButton?.addTarget(self, action: "selectRightPage", forControlEvents: .TouchUpInside)
    pageTitleContainer?.addSubview(rightPageTitleButton!)
  }
  
  private func setupScrollView() {
    scrollView = UIScrollView()
    scrollView?.scrollEnabled = true
    scrollView?.pagingEnabled = true
    scrollView?.showsHorizontalScrollIndicator = false
    scrollView?.delegate = self
    rootView?.view.addSubview(scrollView!)
  }
  
  private func setupPages() {
    leftPage = UIView()
    scrollView?.addSubview(leftPage!)
    
    middlePage = ListFeedViewContainer()
    middlePage?._chatButtonPressed.removeAllListeners()
    middlePage?._chatButtonPressed.listen(self) { [weak self] listing in
      self?.controller.readRealmUser()
      self?.pushViewController(ChatView().setUsers(self?.model.user, friend: listing?.user), animated: true)
    }
    scrollView?.addSubview(middlePage!)
    
    rightPage = UIView()
    scrollView?.addSubview(rightPage!)
  }
  
  public func selectLeftPage() {
    shouldDisableScrollDetection = true
    scrollView?.setContentOffset(CGPointMake(0, 0), animated: true)
    selectPage(.Left)
  }
  
  public func selectMiddlePage() {
    shouldDisableScrollDetection = true
    scrollView?.setContentOffset(CGPointMake(screen.width, 0), animated: true)
    selectPage(.Middle)
  }
  
  public func selectRightPage() {
    shouldDisableScrollDetection = true
    scrollView?.setContentOffset(CGPointMake(screen.width * 2, 0), animated: true)
    selectPage(.Right)
  }
  
  private func selectPage(page: CommunityPage) {
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
    case .Middle:
      UIView.animateWithDuration(duration, delay: 0, usingSpringWithDamping: damping, initialSpringVelocity: velocity, options: .CurveEaseInOut, animations: { [weak self] in
        self?.pageSelector?.frame = self!.middlePageTitleButton!.frame
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
  
  public enum CommunityPage {
    case Left
    case Middle
    case Right
  }
  
  // MARK: Scroll View Delegates
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let offset: CGFloat? = scrollView.contentOffset.x where offset > 0 && shouldDisableScrollDetection == false {
      switch Float(offset!) {
      case 0...Float(screen.width * 0.5):
        selectPage(.Left)
        break
      case Float(screen.width * 0.5 + 1)...Float(screen.width * 1.5 + -1):
        selectPage(.Middle)
        break
      case Float(screen.width * 1.5)...Float(screen.width * 2):
        selectPage(.Right)
        break
      default: break
      }
    }
  }
}

































