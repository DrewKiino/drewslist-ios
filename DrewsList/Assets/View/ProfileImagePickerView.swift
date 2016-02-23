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

  private var tableView: DLTableView?
  private var profileImgURLs: [String]?
  private var profileImgNames: [String]?
  
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setupProfileImages()
    setupTableView()
    
  }
  
  public override func viewWillAppear(animated: Bool) {
    
    controller.readRealmUser()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    controller.writeRealmUser()
    controller.updateUserInServer()
    
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView?.fillSuperview()
  }
  
  // MARK: setup view functions
  
  public func setupProfileImages(){
    if let fbProfileImageURL = self.model.fbProfileImageURL {
      profileImgURLs = [ fbProfileImageURL, "http://www.drawingcoach.com/image-files/240x434xhtd_bunny_st5.gif.pagespeed.ic.Q5eg7QP9kx.png", "http://clipartfreefor.com/cliparts/penguin-clip-art/cliparti1_penguin-clip-art_01.jpg", "http://www.how-to-draw-funny-cartoons.com/image-files/wolf-cartoon-006.jpg", "https://s-media-cache-ak0.pinimg.com/originals/2a/33/17/2a3317dad8bf7f15920f2d2e1fd68840.jpg", "http://images5.fanpop.com/image/photos/28500000/pandas-cartoon-pandas-28525562-455-500.png", "https://s-media-cache-ak0.pinimg.com/564x/6b/c5/37/6bc537a241ffc746acb7d2180d2253d8.jpg", "http://www.clker.com/cliparts/e/c/2/c/11954410851373638183Gerald_G_Cartoon_Cat_Sitting.svg.hi.png", "http://www.clipartbest.com/cliparts/4i9/aB9/4i9aB9r5T.png", "https://www.wpclipart.com/animals/dogs/cartoon_dogs/cartoon_dogs_6/cartoon_dog.png"]
      profileImgNames = ["Facebook Profile", "Harry", "Muffins", "Puff", "Niko", "Paul", "Mosby", "Brownie", "Jasper", "Randy"]
    } else {
      profileImgURLs = [ "http://www.drawingcoach.com/image-files/240x434xhtd_bunny_st5.gif.pagespeed.ic.Q5eg7QP9kx.png", "http://clipartfreefor.com/cliparts/penguin-clip-art/cliparti1_penguin-clip-art_01.jpg", "http://www.how-to-draw-funny-cartoons.com/image-files/wolf-cartoon-006.jpg", "https://s-media-cache-ak0.pinimg.com/originals/2a/33/17/2a3317dad8bf7f15920f2d2e1fd68840.jpg", "http://images5.fanpop.com/image/photos/28500000/pandas-cartoon-pandas-28525562-455-500.png", "https://s-media-cache-ak0.pinimg.com/564x/6b/c5/37/6bc537a241ffc746acb7d2180d2253d8.jpg", "http://www.clker.com/cliparts/e/c/2/c/11954410851373638183Gerald_G_Cartoon_Cat_Sitting.svg.hi.png", "http://www.clipartbest.com/cliparts/4i9/aB9/4i9aB9r5T.png", "https://www.wpclipart.com/animals/dogs/cartoon_dogs/cartoon_dogs_6/cartoon_dog.png"]
      profileImgNames = ["Harry", "Muffins", "Puff", "Niko", "Paul", "Mosby", "Brownie", "Jasper", "Randy"]
    }
    
  }
  
  
  public func setupTableView(){
    tableView = DLTableView()
    tableView?.scrollEnabled = true
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  
  // MARK: private functions
  
  private func setupDataBinding() {
    // setup view's databinding
    model._user.removeAllListeners()
    model._user.listen(self) { [weak self] user in
      self?.tableView!.reloadData()
    }
    model._fbProfileImageURL.removeAllListeners()
    model._fbProfileImageURL.listen(self) { [weak self] fbProfileImageURL in
      self?.setupProfileImages()
      self?.tableView!.reloadData()
    }
    
    // setup controller's databinding
    controller.setupDataBinding()
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
    if let profileImgURLs = profileImgURLs {
      return profileImgURLs.count
    } else { return 1 }
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
      if let profileImgURLs = profileImgURLs, profileImgNames = profileImgNames {
        cell.downloadImageFromURL(profileImgURLs[indexPath.row])
        cell.label?.text = profileImgNames[indexPath.row]
        cell._didSelectCell.listen(self) { [weak cell] list in
          self.model.user?.imageUrl = profileImgURLs[indexPath.row]
          self.navigationController?.popToRootViewControllerAnimated(true)
        }
      }
      cell.label?.textAlignment = .Center
      
      
      return cell
      
    } else {
      log.error("Cell not found: ProfileImagePickerView.swift")
      return UITableViewCell()
    }
   
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return screen.height / 9
  }
  
  public func cancel() {
  
  }
  
}
