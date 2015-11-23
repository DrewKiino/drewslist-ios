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


public class UserProfileView: UIViewController,  UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource{
  
  var scrollView: UIScrollView?
  var bgView: UIView?
  var bgViewTop: UIView?
  var bgViewBot: UIView?
  var profileImg: UIImageView?
  var profileUsername: UILabel?
  var settingsButton: UIButton?
  var tabView: UIView?
  var tableView: UITableView?
  var collectionView: UICollectionView?
  var collectionView2: UICollectionView?
  var arrowRight: UIImageView?
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    scrollView = UIScrollView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height))
    if let scrollView = scrollView {
      scrollView.tag = 0
      scrollView.delegate = self
      scrollView.backgroundColor = UIColor.blackColor()
      view.addSubview(scrollView)
    }
    
    bgView = UIView(frame: CGRectMake(0, 0, screenSize.width, screenSize.height / 2))
    if let bgView = bgView {
      bgView.backgroundColor = UIColor.orangeColor()
      scrollView?.addSubview(bgView)
    }
    
    bgViewTop = UIView(frame: CGRectMake(0, 0, screenSize.width, (bgView?.frame.height)! / 2))
    if let bgViewTop = bgViewTop {
      bgViewTop.backgroundColor = UIColor.blueColor()
      bgView?.addSubview(bgViewTop)
    }
    
    bgViewBot = UIView(frame: CGRectMake(0, (bgView?.frame.height)! / 2, screenSize.width, (bgView?.frame.height)! / 2))
    if let bgViewBot = bgViewBot {
      bgViewBot.backgroundColor = UIColor.whiteColor()
      bgView?.addSubview(bgViewBot)
    }
    
    profileImg = UIImageView(frame: CGRectMake(screenSize.width / 2 - screenSize.width / 5, screenSize.height / 4 - screenSize.width / 5, screenSize.width / 2.5, screenSize.width / 2.5))
    if let profileImg = profileImg {
      profileImg.backgroundColor = UIColor.purpleColor()
      profileImg.layer.cornerRadius = profileImg.frame.size.width / 2
      profileImg.clipsToBounds = true
      bgView?.addSubview(profileImg)
    }
    
    profileUsername = UILabel(frame: CGRectMake(screenSize.width / 3 , screenSize.height / 2 -  screenSize.width / 5, screenSize.width / 3, screenSize.height / 30))
    if let profileUsername = profileUsername {
    
      profileUsername.text = "User Name"
      profileUsername.font = UIFont(name: "Avenir", size: 100)
      profileUsername.font = UIFont.boldSystemFontOfSize(20.0)
      profileUsername.textAlignment = .Center
      profileUsername.textColor = UIColor.blackColor()
      bgView?.addSubview(profileUsername)
    }
    
    settingsButton = UIButton(frame: CGRectMake(screenSize.width-screenSize.width/12, screenSize.width/12, screenSize.width / 20, screenSize.width / 20))
    if let settingsButton = settingsButton {
      settingsButton.setImage(UIImage(named: "Icon-SettingsGear") as UIImage?, forState: .Normal)
      bgView?.addSubview(settingsButton)
    }
    
    tabView = UIView(frame: CGRectMake(0, screenSize.height / 2 - screenSize.height / 17, screenSize.width, screenSize.height / 17))
    if let tabView = tabView {
    
      tabView.backgroundColor = UIColor.brownColor()
      applyPlainShadow(tabView)
      
      scrollView?.addSubview(tabView)
    }
    
    tableView = UITableView(frame: CGRectMake(0, screenSize.height / 2, screenSize.width, screenSize.height * (2/2.75)), style: .Plain)
    if let tableView = tableView {
      tableView.backgroundColor = UIColor.greenColor()
      tableView.delegate = self
      tableView.dataSource = self
      tableView.rowHeight = view.frame.height / 4
      tableView.scrollEnabled = false
      scrollView!.addSubview(tableView)
    }
    
    // Do any additional setup after loading the view, typically from a nib.
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .Horizontal
    layout.minimumLineSpacing = 20.0
    
    collectionView = UICollectionView(frame: CGRectMake(0, 0, 1, (tableView?.frame.height)! * (7.5/20)), collectionViewLayout: layout)
    collectionView2 = UICollectionView(frame: CGRectMake(0, 0, 1, (tableView?.frame.height)! * (7.5/20)), collectionViewLayout: layout)

    if let collectionView = collectionView {
      collectionView.tag = 1
      collectionView.registerClass(Cell.self, forCellWithReuseIdentifier: "cell")
      collectionView.delegate = self
      collectionView.dataSource = self
      collectionView.pagingEnabled = true
      collectionView.backgroundColor = UIColor.whiteColor()
    }
    if let collectionView2 = collectionView2 {
      collectionView2.tag = 2
      collectionView2.registerClass(Cell.self, forCellWithReuseIdentifier: "cell")
      collectionView2.delegate = self
      collectionView2.dataSource = self
      collectionView2.pagingEnabled = true
      collectionView2.backgroundColor = UIColor.whiteColor()
    }
    
    arrowRight = UIImageView(frame: CGRectMake( 0, 0, screenSize.width / 15, screenSize.width / 15))
    if let arrowRight = arrowRight {
      arrowRight.backgroundColor = UIColor.orangeColor()
      arrowRight.layer.cornerRadius = arrowRight.frame.size.width / 2
      arrowRight.clipsToBounds = true
      tabView?.addSubview(arrowRight)
    }
 
    arrangeViews()
    
  }
  
  //Table View Functions
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return screenSize.height / 2.75
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    let cell = UITableViewCell()
    cell.selectionStyle = .None
    
    let shelfLabel = UILabel()
    
    if(indexPath.row == 0) {
      shelfLabel.text = "I'M SELLING"
      shelfLabel.font = UIFont(name: "Avenir", size: 12)
      shelfLabel.font = UIFont.boldSystemFontOfSize(10.0)
      shelfLabel.textColor = UIColor.lightGrayColor()
      shelfLabel.frame = CGRectMake(screenSize.width / 20, 0, screenSize.width, tableView.height * (1/10))
      
      collectionView!.frame = CGRectMake(0, tableView.height * (1/12), screenSize.width, tableView.height * (7.5/20))
     
      cell.backgroundColor = UIColor.whiteColor()
      cell.addSubview(shelfLabel)
      cell.addSubview(collectionView!)
      
    } else {
      shelfLabel.text = "MY WISHLIST"
      shelfLabel.font = UIFont(name: "Avenir", size: 12)
      shelfLabel.font = UIFont.boldSystemFontOfSize(10.0)
      shelfLabel.textColor = UIColor.lightGrayColor()
      shelfLabel.frame = CGRectMake(screenSize.width / 20, 0, screenSize.width, tableView.height * (1/10))

      collectionView2!.frame = CGRectMake(0, tableView.height * (1/12), screenSize.width, tableView.height * (7.5/20) )
      
      cell.backgroundColor = UIColor.whiteColor()
      cell.addSubview(shelfLabel)
      cell.addSubview(collectionView2!)
    }
    print(collectionView?.contentSize.width)
    return  cell
  }
  
  // Collection View Functions
  
  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
    return CGSizeMake( screenSize.width / 3.5, collectionView.frame.height - collectionView.frame.height / 10)
  }
  
  public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets{
    let leftRightInset = screenSize.width / 25.0
    return UIEdgeInsetsMake(0, leftRightInset, 0, leftRightInset)
  }
  
  public func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("cell", forIndexPath: indexPath) as? Cell
    cell!.backgroundColor = UIColor.purpleColor()
    //cell?.setup()
    cell?.setup()
    return cell!
  }
  
  public func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 20
  }
  
//  public func scrollViewDidEndDecelerating(scrollView: UIScrollView){
//    let scrollViewWidth = scrollView.frame.size.width
//    let scrollContentSizeWidth = scrollView.contentSize.width
//    let scrollOffset = scrollView.contentOffset.x
//    
//    if (scrollOffset == 0)
//    {
//      // then we are at the left
//      print("LEFT")
//      moveImage(arrowRight!)
//    }
//    else if (scrollOffset + scrollViewWidth == round(scrollContentSizeWidth))
//    {
//      // then we are at the end
//      
//      print("RIGHT")
//    }
//  }
  
  func applyPlainShadow(view: UIView) {
    let layer = view.layer
    
    layer.shadowColor = UIColor.blackColor().CGColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowOpacity = 0.4
    layer.shadowRadius = 3
  }
  
//  public func moveImage(view: UIImageView){
//    let toPoint: CGPoint = CGPointMake(screenSize.width - screenSize.width / 4, screenSize.height / 2)
//    let fromPoint : CGPoint = CGPointMake(30, 0)
//    print("moo")
//    let movement = CABasicAnimation(keyPath: "movement")
//    movement.additive = true
//    movement.fromValue =  NSValue(CGPoint: fromPoint)
//    movement.toValue =  NSValue(CGPoint: toPoint)
//    movement.duration = 2.0
//    
//    view.layer.addAnimation(movement, forKey: "move")
//  }
  
  public func arrangeViews(){
    scrollView!.contentSize = CGSizeMake(screenSize.width, bgView!.frame.height + (tableView?.frame.height)!)
    scrollView?.bringSubviewToFront(tabView!)
  }
  
  public override func viewDidAppear(animated: Bool) {
  }
  
  override public func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }
  
  
}

public class HorizontalCell: UITableViewCell {
  public func setup() {
  }
}

public class Cell: UICollectionViewCell {
    var bookImageView: UIImageView!
    var infoView: UIView!
    var infoLabel: UILabel!
  
  public func setup(){
    bookImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height*6/7))
    bookImageView.contentMode = UIViewContentMode.ScaleAspectFit
    bookImageView.backgroundColor = UIColor.blueColor()
    
    contentView.addSubview(bookImageView!)
    
    
    
    let viewFrame = CGRect(x: 0, y: frame.size.height*6/7, width: frame.size.width, height: frame.size.height/7)
    infoView = UILabel(frame: viewFrame)
    
    infoView.backgroundColor = UIColor.whiteColor()
    
    infoView.layer.shadowColor = UIColor.blackColor().CGColor
    infoView.layer.shadowOffset = CGSize(width: 2, height: 3)
    infoView.layer.shadowOpacity = 0.1
    infoView.layer.shadowRadius = 5
    contentView.addSubview(infoView!)
    
    let textFrame = CGRect(x: frame.size.width/2, y: frame.size.height*6/7, width: frame.size.width/2, height: frame.size.height/7)
    infoLabel = UILabel(frame: textFrame)
    
    infoLabel.backgroundColor = UIColor.clearColor()
    
    infoLabel.text = "More Info"
    infoLabel.font = UIFont(name: "Avenir", size: 8)
    infoLabel.textColor = UIColor.lightGrayColor()
    //infoLabel.font = UIFont.systemFontOfSize(UIFont.smallSystemFontSize())
    infoLabel.textAlignment = .Center
    contentView.addSubview(infoLabel!)
    
  }
  
}