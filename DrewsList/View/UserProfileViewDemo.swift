//
//  UserProfileView.swift
//  DrewsList
//
//  Created by Kevin Mowers on 11/7/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Toucan
import Haneke
import Neon

public class UserProfileViewDemo:
  UIViewController,
  UICollectionViewDelegate,
  UICollectionViewDataSource,
  UITableViewDataSource,
  UITableViewDelegate
{
  let screenWidth = UIScreen.mainScreen().bounds.width
  let screenHeight = UIScreen.mainScreen().bounds.height
  
  let scrollView = UIScrollView()
  let bgView = UIView()
  let bgViewTop = UIView()
  let bgViewBot = UIView()
  let profileImage = UIImageView()
  
  
  let controller = UserProfileController()
  
  //var profileImage = UIImage()
  var profileUsername = String()
  
  let topBackground = UIView()
  let botBackground = UIView()
  
  var bookshelf = UITableView()
  var salesList : UICollectionView?
  var wishList : UICollectionView?
  
  let profileUsernameLabel = UILabel()
  let button = UIButton()
  
  public func isPressed() {
    //controller.isPressed()
    //let toucan = Toucan(image: profileImage)
//    let circledImage = toucan.maskWithEllipse().image
//    circledImage
    button.addTarget(self, action: "buttonPressed", forControlEvents: .TouchUpInside)
  }
  
//  func buttonPressed() {
//    controller.setName(label.text)
//  }
  public func loadUsername(){
    profileUsernameLabel.text = profileUsername
  }
  
  
  func changeUIBGToRed() {
    
  }
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    profileUsernameLabel.frame = CGRectMake(0, 0, screenWidth, 100)
    setupScrollView()
    setupBGView()
    setupTableView()
    setupSalesList()
    setupWishList()
  }
  
  private func setupScrollView() {
    scrollView.backgroundColor = UIColor.blackColor()
    scrollView.frame = CGRectMake(0, 0, screenWidth, screenHeight)
    view.addSubview(scrollView)
  }
  
  private func setupBGView() {
    bgView.backgroundColor = UIColor.lightGrayColor()
    bgView.frame = CGRectMake(0, 0, screenWidth, 400)
    bgViewTop.backgroundColor = UIColor.blackColor()
    bgViewBot.backgroundColor = UIColor.blueColor()
    bgView.addSubview(bgViewTop)
    bgView.addSubview(bgViewBot)
    bgView.addSubview(profileImage)
    bgView.addSubview(profileUsernameLabel)
    
    scrollView.addSubview(bgView)
  }
  
  
  private func setupTableView() {
    bookshelf.frame = CGRectMake(0, 100, screenWidth, 100)
    bookshelf.registerClass(UITableViewCell.self, forCellReuseIdentifier: "bookshelfCell")
    bookshelf.delegate = self
    bookshelf.dataSource = self
    scrollView.addSubview(bookshelf)
  }
  
  private func setupSalesList() {
    
    let layout = UICollectionViewFlowLayout()
    
    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: 90, height: 120)
    
    salesList = UICollectionView(frame: CGRectMake(0, 50, screenWidth, 200), collectionViewLayout: layout)
    
    if let  salesList = salesList {
      salesList.backgroundColor = UIColor.orangeColor()
      salesList.tag = 0
      salesList.registerClass(BookCell.self, forCellWithReuseIdentifier: "salesListCell")
      salesList.delegate      =   self
      salesList.dataSource    =   self
    }
  }
  
  private func setupWishList() {
    
    let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
    
    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
    layout.itemSize = CGSize(width: 90, height: 120)

    wishList = UICollectionView(frame: CGRectMake(0, 50, screenWidth, 200), collectionViewLayout: layout)
    wishList?.backgroundColor = UIColor.redColor()

    wishList?.frame          =   CGRectMake(0, 0, screenWidth, 30);
    
    wishList?.tag  = 1
    wishList?.registerClass(BookCell.self, forCellWithReuseIdentifier: "wishListCell")
    wishList?.delegate       =   self
    wishList?.dataSource     =   self
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    profileImage.hnk_setImageFromURL(NSURL(string: "https://www.google.com/images/branding/googlelogo/2x/googlelogo_color_272x92dp.png")!)
  }
  
  override public func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    bgView.groupAndFill(group: .Vertical, views: [bgViewTop, bgViewBot], padding: 0)
    profileImage.anchorInCenter(width: bgView.frame.width / 3, height: bgView.frame.height / 3)
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCellWithIdentifier("bookshelfCell") as UITableViewCell?,
          let salesList = salesList,
          let wishList = wishList
          else { return UITableViewCell() }
    indexPath.row == 0 ? cell.addSubview(salesList) : cell.addSubview(wishList)
    return cell
  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 4
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    return collectionView.tag == 0 ?
      collectionView.dequeueReusableCellWithReuseIdentifier("salesListCell", forIndexPath: indexPath) as! BookCell :
      collectionView.dequeueReusableCellWithReuseIdentifier("wishListCell", forIndexPath: indexPath) as! BookCell
  }
}


