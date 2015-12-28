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
    if profileImg?.image == nil { view.showLoadingScreen() }
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
    model._user.removeAllListeners()
    model._user.listen(self) { [weak self] user in
    }
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
      if bool == true {
        self?.view.showLoadingScreen(nil, bgOffset: nil ,fadeIn: true) { [weak self] in
          if let frame = self?.originalBGViewFrame { self?.bgViewTop?.frame = frame }
          self?.scrollView?.panGestureRecognizer.enabled = false
          self?.scrollView?.panGestureRecognizer.enabled = true
        }
      } else {
        self?.setUser(self?.model.user)
        self?.bookShelf?.reloadData()
        self?.view.hideLoadingScreen()
      }
    }
  }
  
  // MARK: UI Setup
  
  public func setupSelf() {
    controller.viewDidLoad()
    setRootViewTitle("Profile")
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
    bookShelf = DLTableView()
    bookShelf?.delegate = self
    bookShelf?.dataSource = self
    bookShelf?.scrollEnabled = false
    bookShelf?.multipleTouchEnabled = true
    bookShelf?.backgroundColor = .whiteColor()
    scrollView?.addSubview(bookShelf!)
  }
  
  private func setupButtons() {
    
    let myImage = UIImage(named: "Icon-SettingsGear")
    let resizedImage = Toucan.Resize.resizeImage(myImage!, size: CGSize(width: screenSize.width/20, height: screenSize.width/20))
    
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
    
    // fixture
//    user?.description = "Bacon ipsum dolor amet kielbasa bacon landjaeger brisket venison fatback. Sausage pork flank, hamburger bresaola cupim sirloin swine pastrami pig leberkas brisket. Prosciutto sirloin venison bresaola meatloaf swine landjaeger, shankle turkey shoulder. Spare ribs strip steak salami venison kielbasa pancetta prosciutto turducken beef ham hock shank tri-tip brisket tenderloin. Bresaola shankle pork chop, short loin jerky brisket strip steak frankfurter ground round. Tri-tip t-bone jowl tail pancetta. Prosciutto tail filet mignon, kevin pork chop tenderloin pork belly jowl beef ribs. Shank strip steak t-bone flank, ham cow porchetta pork loin spare ribs short ribs bresaola rump capicola. Strip steak salami picanha ball tip, ground round beef doner. Ham hock pig prosciutto, sirloin tri-tip flank kielbasa swine short loin beef jerky picanha filet mignon meatball. T-bone prosciutto brisket tongue, spare ribs tail salami corned beef. Turkey spare ribs shoulder frankfurter tail boudin. Frankfurter andouille sirloin ball tip beef ribs kevin brisket tongue corned beef ham hock t-bone cupim. Picanha leberkas bacon, ground round tongue short loin kevin meatloaf pork loin shankle cow jowl. Swine t-bone kielbasa andouille sausage, ball tip boudin jowl hamburger meatball ground round biltong. Tongue tenderloin frankfurter short ribs ball tip turkey cow alcatra. Pork loin ham hock bresaola short ribs porchetta, bacon corned beef. Venison cow drumstick, hamburger kielbasa prosciutto beef. Meatloaf shoulder chuck short ribs ball tip bacon turkey t-bone cow tongue capicola swine venison. Pork frankfurter alcatra spare ribs jerky landjaeger. Short ribs turkey ham meatball. Pork frankfurter brisket, sirloin shankle short loin beef prosciutto spare ribs porchetta sausage. Doner leberkas swine, pig beef kevin salami pancetta t-bone. Frankfurter corned beef ham pig shoulder meatball biltong. Turducken pork loin jowl beef jerky filet mignon meatball flank corned beef meatloaf venison brisket."
    
    guard let user = user else { return }
    
    let duration: NSTimeInterval = 0.2
    
    // MARK: Images
    if user.image != nil {
      
      profileImg?.dl_setImageFromUrl(user.image) { [weak self] image, error, cache, url in
        Async.background { [weak self] in
          // NOTE: correct way to handle memory management with toucan
          // init toucan and pass in the arguments directly in the parameter headers
          // do the resizing in the background
          var toucan: Toucan? = Toucan(image: image).resize(self?.profileImg?.frame.size, fitMode: .Crop).maskWithEllipse()
          
          Async.main { [weak self] in
            
            self?.profileImg?.alpha = 0.0
            
            // set the image view's image
            self?.profileImg?.image = toucan?.image
            
            UIView.animateWithDuration(duration) { [weak self] in
              self?.profileImg?.alpha = 1.0
            }
            
            // deinit toucan
            toucan = nil
          }
        }
      }
    } else {
      
      Async.background { [weak self] in
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "profile-placeholder")).resize(self?.profileImg?.frame.size, fitMode: .Crop).maskWithEllipse()
        
        Async.main { [weak self] in
          
          self?.profileImg?.alpha = 0.0
          
          self?.profileImg?.image = toucan?.image
          
          UIView.animateWithDuration(duration) { [weak self] in
            self?.profileImg?.alpha = 1.0
          }
          
          toucan = nil
        }
      }
    }
    
    if user.bgImage != nil {
      
      bgViewTop?.dl_setImageFromUrl(user.bgImage) { [weak self] image, error, cache, url in
        Async.background { [weak self] in
          
          // NOTE: correct way to handle memory management with toucan
          // init toucan and pass in the arguments directly in the parameter headers
          // do the resizing in the background
          var toucan: Toucan? = Toucan(image: image).resize(self?.bgViewTop?.frame.size, fitMode: .Crop)
          
          Async.main { [weak self] in
            
            self?.bgViewTop?.alpha = 0.0
            
            self?.bgViewTop?.image = toucan?.image
            
            UIView.animateWithDuration(duration) { [weak self] in
              self?.bgViewTop?.alpha = 1.0
            }
            
            // deinit toucan
            toucan = nil
          }
        }
      }
    } else {
      
      Async.background { [weak self] in
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "background-image2")).resize(self?.profileImg?.frame.size, fitMode: .Clip)
        
        Async.main { [weak self] in
          
          self?.bgViewTop?.alpha = 0.0
          
          self?.bgViewTop?.image = toucan?.image
          
          UIView.animateWithDuration(duration) { [weak self] in
            self?.bgViewTop?.alpha = 1.0
          }
          
          toucan = nil
        }
      }
    }
    
    profileUsername?.alpha = 0.0
    descriptionTextView?.alpha = 0.0
    
    UIView.animateWithDuration(duration) { [weak self, weak user] in
      self?.profileUsername?.text = user?.username ?? user?.getName()
      self?.descriptionTextView?.text = user?.description
      
      self?.profileUsername?.alpha = 1.0
      self?.descriptionTextView?.alpha = 1.0
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
    
    guard let cell = tableView.dequeueReusableCellWithIdentifier("UserProfileListView") as? UserProfileListView else { return DLTableViewCell() }
    
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
    cell._didSelectListing.removeAllListeners()
    cell._didSelectListing.listen(self) { [weak self] list_id in
      self?.pushViewController(ListViewContainer().setList_id(list_id).isUserListing(), animated: true)
    }
    
    cell._didSelectMatch.removeAllListeners()
    cell._didSelectMatch.listen(self) { [weak self] list_id in
      self?.pushViewController(ListViewContainer().setList_id(list_id), animated: true)
    }
    
    return cell
  }
  
  // MARK: Scroll View Delegates
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let offset: CGFloat? = -scrollView.contentOffset.y where offset > 0 {
      let ratio = originalBGViewFrame!.width / originalBGViewFrame!.height
      bgViewTop?.frame = CGRectMake(originalBGViewFrame!.origin.x - offset!, originalBGViewFrame!.origin.y - offset!, originalBGViewFrame!.width + (offset! * ratio), originalBGViewFrame!.height + (offset!))
      
      // if the offset is greater than 64, then call the server to update the user object in the model
      if offset >= 128 && model.shouldRefrainFromCallingServer == false {
        controller.readRealmUser()
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
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.4
    layer.shadowRadius = 3
  }
}
