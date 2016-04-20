//
//  ProfileImagePickerView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 2/7/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals

public class ProfileImagePickerView: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
  
  private let controller = ProfileImagePickerController()
  private var model: ProfileImagePickerModel { get { return controller.model } }
  private let screenSize = UIScreen.mainScreen().bounds

  private var scrollView: UIScrollView?
  private var tableView: DLTableView?
  private var profileImgURLs: [String] = []
  private var profileImgNames: [String] = []
  
  // Navigation Header Views
  private var headerView: UIView?
  private var cancelButton: UIButton?
  //  private var chooseButton: UIButton?
  private var headerTitle: UILabel?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupHeaderView()
    setupProfileImages()
    setupScrollView()
    setupTableView()
    
    FBSDKController.createCustomEventForName("UserProfileImagePicker")
    
    headerView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: 60)
    headerTitle?.anchorToEdge(.Bottom, padding: 12, width: 150, height: 24)
    cancelButton?.anchorInCorner(.BottomLeft, xPad: 8, yPad: 8, width: 64, height: 24)
    
    tableView?.alignAndFill(align: .UnderCentered, relativeTo: headerView!, padding: 0)
//    tableView?.fillSuperview()
    tableView?.contentSize = CGSizeMake(screen.width, screen.height * 2)
  }
  
  public override func viewWillAppear(animated: Bool) {
  }
  
  public override func viewWillDisappear(animated: Bool) {
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  // MARK: setup view functions
  
  private func setupHeaderView() {
    headerView = UIView()
    headerView?.backgroundColor = .soothingBlue()
    view.addSubview(headerView!)
    
    headerTitle = UILabel()
    headerTitle?.text = "Edit Profile Image"
    headerTitle?.textAlignment = .Center
    headerTitle?.font = UIFont.asapBold(16)
    headerTitle?.textColor = .whiteColor()
    headerView?.addSubview(headerTitle!)
    
    cancelButton = UIButton()
    cancelButton?.setTitle("Cancel", forState: .Normal)
    cancelButton?.titleLabel?.font = UIFont.asapRegular(16)
    cancelButton?.addTarget(self, action: "cancel", forControlEvents: .TouchUpInside)
    headerView?.addSubview(cancelButton!)
  }
  
  public func cancel() {
    dismissViewControllerAnimated(true, completion: nil)
  }
  
  public func setupProfileImages(){
    if let fbProfileImageURL = self.model.fbProfileImageURL {
      profileImgURLs = [ fbProfileImageURL, "http://www.drawingcoach.com/image-files/240x434xhtd_bunny_st5.gif.pagespeed.ic.Q5eg7QP9kx.png", "http://clipartfreefor.com/cliparts/penguin-clip-art/cliparti1_penguin-clip-art_01.jpg", "http://www.how-to-draw-funny-cartoons.com/image-files/wolf-cartoon-006.jpg", "https://s-media-cache-ak0.pinimg.com/originals/2a/33/17/2a3317dad8bf7f15920f2d2e1fd68840.jpg", "http://images5.fanpop.com/image/photos/28500000/pandas-cartoon-pandas-28525562-455-500.png", "https://s-media-cache-ak0.pinimg.com/564x/6b/c5/37/6bc537a241ffc746acb7d2180d2253d8.jpg", "http://www.clker.com/cliparts/e/c/2/c/11954410851373638183Gerald_G_Cartoon_Cat_Sitting.svg.hi.png", "http://www.clipartbest.com/cliparts/4i9/aB9/4i9aB9r5T.png", "https://www.wpclipart.com/animals/dogs/cartoon_dogs/cartoon_dogs_6/cartoon_dog.png"]
      profileImgNames = ["Facebook Profile", "Harry", "Muffins", "Puff", "Niko", "Paul", "Mosby", "Brownie", "Jasper", "Randy"]
    } else {
      profileImgURLs = [ "http://www.drawingcoach.com/image-files/240x434xhtd_bunny_st5.gif.pagespeed.ic.Q5eg7QP9kx.png", "http://clipartfreefor.com/cliparts/penguin-clip-art/cliparti1_penguin-clip-art_01.jpg", "http://www.how-to-draw-funny-cartoons.com/image-files/wolf-cartoon-006.jpg", "https://s-media-cache-ak0.pinimg.com/originals/2a/33/17/2a3317dad8bf7f15920f2d2e1fd68840.jpg", "http://images5.fanpop.com/image/photos/28500000/pandas-cartoon-pandas-28525562-455-500.png", "https://s-media-cache-ak0.pinimg.com/564x/6b/c5/37/6bc537a241ffc746acb7d2180d2253d8.jpg", "http://www.clker.com/cliparts/e/c/2/c/11954410851373638183Gerald_G_Cartoon_Cat_Sitting.svg.hi.png", "http://www.clipartbest.com/cliparts/4i9/aB9/4i9aB9r5T.png", "https://www.wpclipart.com/animals/dogs/cartoon_dogs/cartoon_dogs_6/cartoon_dog.png"]
      profileImgNames = ["Harry", "Muffins", "Puff", "Niko", "Paul", "Mosby", "Brownie", "Jasper", "Randy"]
    }
    
  }
  
  public func setupScrollView(){
    scrollView = UIScrollView()
    scrollView?.scrollEnabled = true
    scrollView?.pagingEnabled = true
    scrollView?.showsHorizontalScrollIndicator = false
    scrollView?.delegate = self
    view.addSubview(scrollView!)
  }
  
  
  public func setupTableView(){
    tableView = DLTableView()
    tableView?.scrollEnabled = true
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.backgroundColor = .whiteColor()
    view.addSubview(tableView!)
  }
  
  
  // MARK: private functions
  
  private func setupDataBinding() {
    // setup view's databinding
    model._user.removeAllListeners()
    model._user.listen(self) { [weak self] user in
      self?.model.fbProfileImageURL = user?.facebook_image
      self?.setupProfileImages()
      self?.tableView!.reloadData()
    }
  }
  
  public func setUser(user: User?) {
    guard let user = user else { return }
    model.user = user
  }
  
  private func setupSelf() {
    title = "Profile Image"
  }
  
  // MARK: UITableView Classes
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return profileImgURLs.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
      cell.imageUrl = profileImgURLs[indexPath.row]
      cell.label?.text = profileImgNames[indexPath.row]
      cell._didSelectCell.removeAllListeners()
      cell._didSelectCell.listen(self) { [weak self] list in
        self?.model.user?.imageUrl = self?.profileImgURLs[indexPath.row]
        UserController.updateUserToServer({ (user) -> User? in
          user?.imageUrl = self?.model.user?.imageUrl
          return user
        }) { [weak self] user in
          self?.dismissViewControllerAnimated(true) { bool in
            if let editProfileView = TabView.currentView()?.visibleViewController as? EditProfileView {
              editProfileView.setUser(user)
            }
          }
        }
      }
      cell.label?.textAlignment = .Center
      
      return cell
    }
   
    return DLTableViewCell()
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return screen.height / 9
  }
}
