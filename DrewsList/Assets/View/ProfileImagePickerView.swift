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
  
  
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    setUpTableView()
    
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
  
  public func setUpTableView(){
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  
  // MARK: private functions
  
  private func setupDataBinding() {
    // setup view's databinding
    model._user.listen(self) { [weak self] user in
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
    return 9
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell : UITableViewCell = UITableViewCell()
    
    switch (indexPath.row) {
      
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "http://www.drawingcoach.com/image-files/240x434xhtd_bunny_st5.gif.pagespeed.ic.Q5eg7QP9kx.png"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Harry"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "http://clipartfreefor.com/cliparts/penguin-clip-art/cliparti1_penguin-clip-art_01.jpg"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Muffins"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 2:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "http://www.how-to-draw-funny-cartoons.com/image-files/wolf-cartoon-006.jpg"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Puff"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "https://s-media-cache-ak0.pinimg.com/originals/2a/33/17/2a3317dad8bf7f15920f2d2e1fd68840.jpg"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Niko"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "http://images5.fanpop.com/image/photos/28500000/pandas-cartoon-pandas-28525562-455-500.png"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Paul"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 5:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "https://s-media-cache-ak0.pinimg.com/564x/6b/c5/37/6bc537a241ffc746acb7d2180d2253d8.jpg"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Mosby"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 6:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "http://www.clker.com/cliparts/e/c/2/c/11954410851373638183Gerald_G_Cartoon_Cat_Sitting.svg.hi.png"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Brownie"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 7:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "http://www.clipartbest.com/cliparts/4i9/aB9/4i9aB9r5T.png"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Jasper"
        cell.label?.textAlignment = .Center
        return cell
      }
      break
    case 8:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigImageCell", forIndexPath: indexPath) as? BigImageCell {
        let imageURL = "https://www.wpclipart.com/animals/dogs/cartoon_dogs/cartoon_dogs_6/cartoon_dog.png"
        cell.downloadImageFromURL(imageURL)
        cell.label?.text = "Randy"
        cell.label?.textAlignment = .Center
        cell._didSelectCell.listen(self) { [weak cell] list in
          self.model.user?.imageUrl = imageURL
          self.dismissViewControllerAnimated(true, completion: nil)
        }
        
        
        return cell
      }
      break
    default:
      break
    }
    return cell
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return screen.height / 10
  }
  
}
