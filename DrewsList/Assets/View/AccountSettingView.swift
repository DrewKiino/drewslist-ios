//
//  AccountSettingView.swift
//  DrewsList
//
//  Created by Starflyer on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import QuartzCore
import TextFieldEffects
import Neon

import SwiftyButton
import Former

/*

public class AccountSettingView: QuickTableViewController

{


  //MARK: - AccountSettingView
  
  override public func viewDidLoad() {
    super.viewDidLoad()
    
    title = "Account Settings"
    
    _ = MaterialDesignSymbol(text: MaterialDesignIcon.exitToApp48px, size:24).imageWithSize(CGSize(width: 24, height: 24))
    _ = MaterialDesignSymbol(text: MaterialDesignIcon.language48px, size:24).imageWithSize(CGSize(width: 24, height: 24))
    _ = MaterialDesignSymbol(text: MaterialDesignIcon.history48px, size:24).imageWithSize(CGSize(width: 24, height: 24))
    
  
      tableContents = [
        
      //SwitchTableButtons
      //Section(title: "Switch", rows: [
        //SwitchRow(title: "Setting 1", switchValue: true, action: { _ in }),
        //SwitchRow(title: "Setting 2", switchValue: false, action: { _ in }),
        //]),
      
      Section(title: "Email", rows: [
        NavigationRow(title: "Email", subtitle: .None, icon: UIImage(named:"Icon-EmailButton"), action: showAlert)
        ]),
        
      
       Section(title: "Platforms & Intergration", rows: [
        NavigationRow(title: "Log in with Facebook", subtitle: .None, icon: UIImage(named: "FB"), action: showAlert)
        //TapActionRow(title: "Log in with Twitter", action: showAlert),
        //TapActionRow(title: "Log in with Google +", action: showAlert)
        ]),
        
      
        Section(title: "Permissions", rows: [
          NavigationRow(title: "Push Notification",subtitle: .None, action: PushNotificationAlert),
          NavigationRow(title: "Email Notifications",subtitle: .None, action: EmailNotificationAlert),
          TapActionRow(title: "Clear Browsing History", action: showAlert),
          TapActionRow(title: "Deactivate Account", action: showAlert),
          ])
        
    ]}


  
  
  // MARK: - UITableViewDataSource
  
  override public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = super.tableView(tableView, cellForRowAtIndexPath: indexPath)
    if tableContents[indexPath.section].title == nil {
      // Alter the cells created by QuickTableViewController
      let symbol = MaterialDesignSymbol(text: MaterialDesignIcon.highlightRemove48px, size:24)
      cell.imageView?.image = symbol.imageWithSize(CGSize(width: 24, height: 24))
    }
    return cell
  }
  
  
  // MARK: - Actions/Targets
  
  private func showAlert(sender: Row) {
    let alert =  UIAlertController(title: "Pressed Buttons", message: nil, preferredStyle: .Alert)
    
    //NavButtons
    alert.addAction(UIAlertAction(title: "Ok", style: .Cancel) { [unowned self] _ in
      self.dismissViewControllerAnimated(true, completion: nil)})
  
    
    //ActionInitilizer
    presentViewController(alert, animated: true, completion: nil)
  }
  
  private func PushNotificationAlert(sender: Row) {
    let PushAlert = UIAlertController(title: "Push Notification", message: "Would you yike to recive Push Notifaction?", preferredStyle: UIAlertControllerStyle.Alert)
    
    //Navbuttons
    PushAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
    PushAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Cancel, handler: nil))
    PushAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Destructive, handler: nil))
    
    
    
    //ActionIntilier
    self.presentViewController(PushAlert, animated: true, completion: nil)
    
    
  }
  
  private func EmailNotificationAlert(sender: Row) {
    let EmailAlert = UIAlertController(title: "Email Notification", message: "Would you like to recieve email notifications?", preferredStyle: UIAlertControllerStyle.Alert)
    
    //NavButton
    EmailAlert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: nil))
    EmailAlert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
    
    //ActionIntilizer
    self.presentViewController(EmailAlert, animated: true, completion: nil)
    
  }

  
}

  private func printValue(sender: Row) {
    if let row = sender as? SwitchRow {
      print("\(row.title) = \(row.switchValue)")
    }
  }


*/
  
  
  
  
  
  
  
  
  































































































//Need To DBG

//   private let controller = AccountSettingController()
//   //private var model: AccountSettingModel{ get { return controller.model } }
//  
//  //MARK: Outlets For UI Elements.
//  private let NavBar = UIImageView()
//  private let containerView = UIView()
//  var SettingsView: UITableView?
//  var items: [String] = ["Email", "Password"]
//  
//  
//  
//  public override func viewDidLoad() {
//    super.viewDidLoad()
//    
//    setupNavBar()
//    NavBar.fillSuperview()
//    navigationItem.titleView = NavBar
//    
//    //SettingViewRect
//    SettingsView?.frame = CGRectMake(0, 50, 320, 320)
//    SettingsView?.delegate = self
//    //SettingsView?.dataSource = self
//    
//    //IntilizingTableView
//    SettingsView?.registerClass(UITableViewCell.self, forHeaderFooterViewReuseIdentifier: "Cell")
//    self.view.addSubview(SettingsView!)
//    
//    
//  }
//
//
//  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//    
//        let cell:UITableViewCell = (tableView.dequeueReusableCellWithIdentifier("Cell") as UITableViewCell?)!
//    
//        cell.textLabel?.text = self.items[indexPath.row]
//    
//        return cell
//    
//      }
//  
//
//  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        print("You selected cell #\(indexPath.row)!")
//      }
//  
//  private func setupNavBar() {
//    NavBar.image = UIImage(named: "Icon-NavBar")
//    NavBar.contentMode = .ScaleAspectFit
//    
//    
//    
//  }


  
  

  














