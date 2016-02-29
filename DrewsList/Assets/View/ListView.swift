//
//  ListView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import Gifu
import SDWebImage
import SwiftDate
import Async
import Signals
import RealmSwift

public class ListViewContainer: UIViewController {
  
  public var listView: ListView?
  
  public var doOnce = true
  
  private let controller = DeleteListingController()
  private var model: DeleteListingModel  { get { return controller.model } }
  private var ScreenSize = UIScreen.mainScreen().bounds
  private var TableView: DLTableView?

  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupListView()
    
    listView?.fillSuperview()
    
    FBSDKController().createCustomEventForName("UserList")
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
  private func setupSelf() {
    
    view.backgroundColor = .whiteColor()
  }
  
  private func setupListView() {
    listView?._callButtonPressed.removeAllListeners()
    listView?._callButtonPressed.listen(self) { [weak self] bool in
      self?.listView?.model.user?.phone?.callNumber()
    }
    listView?._chatButtonPressed.removeAllListeners()
    listView?._chatButtonPressed.listen(self) { [weak self] bool in
      self?.readRealmUser()
      self?.navigationController?.pushViewController(
        ChatView()
          .setUsers(self?.listView?.model.user, friend: self?.listView?.model.listing?.user)
          .setListing(self?.doOnce == true ? self?.listView?.model.listing : nil), animated: true
      )
      self?.doOnce = false
    }
    // FIXME: these signal listeners aren't being used??
    listView?._bookProfilePressed.removeAllListeners()
    listView?._bookProfilePressed.listen(self) { [weak self] book in
      self?.navigationController?.pushViewController(BookProfileView().setBook(book), animated: true)
    }
    listView?._userProfilePressed.removeAllListeners()
    listView?._userProfilePressed.listen(self) { [weak self] user in
      self?.navigationController?.pushViewController(UserProfileView().setUser(user), animated: true)
    }
    listView?.model._listing.removeAllListeners()
    listView?.model._listing.listen(self) { [weak self] listing in
      if listing?.user?._id == UserModel.sharedUser().user?._id {
        self?.showEditButton()
      } else {
        self?.hideEditButton()
      }
    }
    
    view.addSubview(listView!)
  }
  
  public func showEditButton() {
    hideEditButton()
    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editButtonPressed")
  }
  
  public func hideEditButton() {
    navigationItem.rightBarButtonItem = nil
  }
  
  public func setListing(listing: Listing?) -> Self {
    listView = ListView()
    listView?.setListing(listing)
    return self
  }
  
  public func setList_id(list_id: String?) -> Self {
    listView = ListView()
    listView?.getListingFromServer(list_id)
    return self
  }
  
  public func isUserListing() -> Self {
    listView?.isUserListing = true
    title = "Your Listing"
    return self
  }
 
  public func editButtonPressed() {
//    navigationController?.pushViewController(DeleteListingView().setListing(listView?.model.listing), animated: true)
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    alertController.addAction(UIAlertAction(title: "Edit", style: .Default) { [weak self] action in
    })
    alertController.addAction(UIAlertAction(title: "Delete", style: .Default) { [weak self] action in
      if let strongSelf = self {
        self?.listView?.controller.serverCallbackFromDeletelIsting.removeAllListeners()
        self?.listView?.controller.serverCallbackFromDeletelIsting.listen(strongSelf) { [weak self] didCallback in
          log.debug(didCallback)
        }
      }
      self?.listView?.controller.deleteListingFromServer()
    })
    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
    })
    UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(alertController, animated: true, completion: nil)
  }
  
  // MARK: Realm Functions
  
  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { listView?.model.user = realmUser.getUser() } }
  public func writeRealmUser() { try! Realm().write { try! Realm().add(RealmUser().setRealmUser( self.listView?.model.user), update: true) } }
}

public class ListView: UIView, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = ListController()
  private var model: ListModel { get { return controller.getModel() } }
  public var isUserListing: Bool = false
  
  public let _chatButtonPressed = Signal<Bool>()
  public let _callButtonPressed = Signal<Bool>()
  public let _bookProfilePressed = Signal<Book?>()
  public let _userProfilePressed = Signal<User?>()
  
  public var tableView: DLTableView?
  
  public init() {
    super.init(frame: CGRectZero)
    
    setupDataBinding()
    setupTableView()
    
    backgroundColor = UIColor.whiteColor()
  }
  
  public required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    tableView?.fillSuperview()
  }
  
  public func setListing(listing: Listing?) -> Bool {
    
    model.listing = listing
    
    tableView?.reloadData()
    
    return true
  }
  
  public func getListingFromServer(list_id: String?) {
    controller.getListingFromServer(list_id)
  }
  
  private func setupTableView() {
    tableView?.removeFromSuperview()
    tableView = DLTableView()
    tableView?.dataSource = self
    tableView?.delegate = self
    tableView?.backgroundColor = .whiteColor()
    
    addSubview(tableView!)
  }
  
  private func setupDataBinding() {
    model._listing.removeAllListeners()
    model._listing.listen(self) { [weak self] listing in
      self?.tableView?.reloadData()
    }
    
    
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
      if bool == true {
        self?.showActivityView()
        self?.tableView?.hidden = true
      }
    }
    
    model._serverCallbackFromFindListing.removeAllListeners()
    model._serverCallbackFromFindListing.listen(self) { [weak self] bool in
      if bool == true { self?.tableView?.reloadData() }
      self?.dismissActivityView()
      self?.tableView?.hidden = false
    }
  }
  
  // MARK: UITableView Delegates 
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 166
    case 1: return 48
    case 2: return 200
    default: return 0
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 3
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    // get listing reference
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
        
        cell.bookView?.setBook(model.listing?.book)
        model._listing.removeListener(self)
        model._listing.listen(self) { [weak cell] listing in
          cell?.bookView?.setBook(listing?.book)
        }
        
        cell._cellPressed.removeAllListeners()
        cell._cellPressed.listen(self) { [weak self] bool in
          print("moo2")
          if bool == true {
            self?._bookProfilePressed.fire(self?.model.listing?.book)
          }
        }
        
        return cell
      }
    case 1:
      
      if  let cell = tableView.dequeueReusableCellWithIdentifier("ListerProfileViewCell", forIndexPath: indexPath) as? ListerProfileViewCell {
        cell.setListing(model.listing)
        model._listing.removeListener(self)
        model._listing.listen(self) { [weak cell] listing in
          cell?.setListing(listing)
        }
        
        return cell
      }
    case 2:
      if  let cell = tableView.dequeueReusableCellWithIdentifier("ListerAttributesViewCell", forIndexPath: indexPath) as? ListerAttributesViewCell {
        cell.setListing(model.listing)
        cell.showSeparatorLine()
        cell._callButtonPressed.removeAllListeners()
        cell._callButtonPressed.listen(self) { [weak self] bool in
          self?._callButtonPressed.fire(bool)
        }
        cell._chatButtonPressed.removeAllListeners()
        cell._chatButtonPressed.listen(self) { [weak self] bool in
          self?._chatButtonPressed.fire(bool)
        }
        model._listing.removeListener(self)
        model._listing.listen(self) { [weak cell] listing in
          cell?.setListing(listing)
        }
        
        return cell
        
      }
      break;
    case 3:
      if let cell = tableView.dequeueReusableCellWithIdentifier("BigButtonCell", forIndexPath: indexPath) as? BigButtonCell {
        cell.backgroundColor = .whiteColor()
        cell.hideBothTopAndBottomBorders()
        cell.button?.fillSuperview(left: screen.width / 30, right: screen.width / 30, top: 0, bottom: 0)
        cell.button?.cornerRadius = 2
        cell.button?.buttonColor = .juicyOrange()
        cell.button?.setTitle("Delete Book", forState: .Normal)
        cell._onPressed.removeAllListeners()
        cell._onPressed.listen(self) {[ weak self] bool in
          //self?.controller.setBookID(self?.model.listing?._id)
          //self?.controller.deleteListingFromServer()
          //self?.dismissViewControllerAnimated(true, completion: nil)
          
          
        }
        
        return cell
      }
      
      
      break;
    case 4:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.backgroundColor = .whiteColor()
        
        return cell
      }

      
    default: break
    }
    
    return DLTableViewCell()
  }
}


public class ListerProfileViewCell: DLTableViewCell {
  
  private var userImageView: UIImageView?
  private var nameLabel: UILabel?
  private var listTypeLabel: UILabel?
  private var listDateTitle: UILabel?
  private var listDateLabel: UILabel?
  private var cellListing: Listing?
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUserImage()
    setupNameLabel()
    setupListTypeLabel()
    setupListDateLabel()
    setupListDateTitle()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    userImageView?.anchorToEdge(.Left, padding: 16, width: 36, height: 36)
    
    nameLabel?.align(.ToTheRightMatchingTop, relativeTo: userImageView!, padding: 8, width: 160, height: 16)
    
    listTypeLabel?.align(.ToTheRightMatchingBottom, relativeTo: userImageView!, padding: 8, width: 160, height: 16)
    
    listDateTitle?.anchorInCorner(.TopRight, xPad: 16, yPad: 6, width: 100, height: 16)
    
    listDateLabel?.anchorInCorner(.BottomRight, xPad: 16, yPad: 6, width: 100, height: 16)
  }
  
  public override func setupSelf() {
    backgroundColor = .whiteColor()
  }
  
  private func setupUserImage() {
    userImageView = UIImageView()
    userImageView?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "userImageViewPressed"))
    userImageView?.userInteractionEnabled = true
    addSubview(userImageView!)
  }
  
  
  private func setupNameLabel() {
    nameLabel = UILabel()
    nameLabel?.font = UIFont.asapRegular(12)
    addSubview(nameLabel!)
  }
  
  private func setupListTypeLabel() {
    listTypeLabel = UILabel()
    listTypeLabel?.font = UIFont.asapBold(12)
    addSubview(listTypeLabel!)
  }
  
  private func setupListDateTitle() {
    listDateTitle = UILabel()
    listDateTitle?.font = UIFont.asapRegular(12)
    listDateTitle?.textAlignment = .Right
    addSubview(listDateTitle!)
  }
  
  private func setupListDateLabel() {
    
    listDateLabel = UILabel()
    listDateLabel?.font = UIFont.asapRegular(12)
    listDateLabel?.textAlignment = .Right
    addSubview(listDateLabel!)
  }
  
  public func setListing(listing: Listing?) {
    guard let listing = listing, let user = listing.user else { return }
    
    cellListing = listing
    
    // MARK: Images
    userImageView?.dl_setImageFromUrl(user.imageUrl, placeholder: UIImage(named: "profile-placeholder"), maskWithEllipse: true)
    
    Async.background { [weak self] in
      
      Async.main { [weak self] in
        self?.nameLabel?.text = user.username ?? user.getName()
        self?.listTypeLabel?.text = listing.getListTypeText() ?? ""
      }
      
      // NOTE: DONT FORGET THESE CODES OMFG
      // converts the date strings sent from the server to local time strings
      if  let dateString = listing.createdAt?.toRegion(.ISO8601, region: Region.LocalRegion())?.toShortString(true, time: false),
          let relativeString = listing.createdAt?.toDateFromISO8601()?.toRelativeString(abbreviated: true, maxUnits: 1)
      {
        let coloredString = NSMutableAttributedString(string: "Listed At \(dateString)")
        coloredString.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 10))
        
        Async.main { [weak self] in
          self?.listDateTitle?.attributedText = coloredString
          self?.listDateLabel?.text = 60.seconds.ago > listing.createdAt?.toDateFromISO8601() ? relativeString : "just now"
        }
      }
      
    }
      
    // not really sure, but the book view covers this view.
    // so I had to set the z position to go over the book view
    // then set the background color to clear
    backgroundColor = .clearColor()
    layer.zPosition = 1
  }
  
  public func userImageViewPressed() {
    TabView.currentView()?.pushViewController(UserProfileView().setUser(cellListing?.user), animated: true)
  }
}

public class ListerAttributesViewCell: DLTableViewCell {
  
  private var priceLabel: UILabel?
  private var conditionLabel: UILabel?
  private var notesTitle: UILabel?
  private var notesTextViewContainer: UIView?
  private var notesTextView: UITextView?
  
  public var listing: Listing?
  
  private var chatButton: UIButton?
  private var callButton: UIButton?
  
  public let _chatButtonPressed = Signal<Bool>()
  public let _callButtonPressed = Signal<Bool>()
  
  public override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupSelf()
    setupPriceLabel()
    setupChatButton()
    setupCallButton()
    setupConditionLabel()
    setupNotesTitle()
    setupNotesTextViewContainer()
    setupNotesTextView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    priceLabel?.anchorInCorner(.TopLeft, xPad: 16, yPad: 16, width: 200, height: 12)
    
    chatButton?.anchorInCorner(.TopRight, xPad: 16, yPad: 16, width: 30, height: 30)
    
    callButton?.align(.ToTheLeftCentered, relativeTo: chatButton!, padding: 24, width: 30, height: 30)
    
    conditionLabel?.align(.UnderMatchingLeft, relativeTo: priceLabel!, padding: 8, width: 200, height: 12)
    
    notesTitle?.align(.UnderMatchingLeft, relativeTo: conditionLabel!, padding: 8, width: 200, height: 12)
  }
  
  public override func setupSelf() {
    
    backgroundColor = .whiteColor()
  }

  
  private func setupPriceLabel() {
    priceLabel = UILabel()
    priceLabel?.font = UIFont.asapRegular(12)
    priceLabel?.textColor = UIColor.moneyGreen()
    addSubview(priceLabel!)
  }
  
  private func setupChatButton() {
    chatButton = UIButton()
    chatButton?.addTarget(self, action: "chatButtonPressed", forControlEvents: .TouchUpInside)
    addSubview(chatButton!)
  }
  
  private func setupCallButton() {
    callButton = UIButton()
    callButton?.addTarget(self, action: "callButtonPressed", forControlEvents: .TouchUpInside)
    addSubview(callButton!)
  }
  
  private func setupConditionLabel() {
    conditionLabel = UILabel()
    conditionLabel?.font = UIFont.asapRegular(12)
    addSubview(conditionLabel!)
  }
  
  private func setupNotesTitle() {
    notesTitle = UILabel()
    notesTitle?.font = UIFont.asapBold(12)
    addSubview(notesTitle!)
  }
  
  private func setupNotesTextViewContainer() {
    notesTextViewContainer = UIView()
    notesTextViewContainer?.layer.mask = nil
    notesTextViewContainer?.hidden = true
    addSubview(notesTextViewContainer!)
  }
  
  private func setupNotesTextView() {
    notesTextView = UITextView()
    notesTextView?.showsVerticalScrollIndicator = false
    notesTextView?.editable = false
    notesTextViewContainer?.addSubview(notesTextView!)
  }
  
  public func setListing(listing: Listing?) {
    
    self.listing = listing
    
    notesTextViewContainer?.hidden = true
    
    let isUserListing = listing?.user?._id == UserController.sharedUser().user?._id
    
    chatButton?.alpha = isUserListing ? 0.0 : 1.0
    callButton?.alpha = isUserListing ? 0.0 : listing?.user?.phone != nil ? listing?.user?.privatePhoneNumber == false ? 1.0 : 0.0 : 0.0
    
    Async.background { [weak self, weak listing] in
      
      let string1 = "Desired Price: \(listing?.getPriceText() ?? "")"
      let coloredString1 = NSMutableAttributedString(string: string1)
      coloredString1.addAttribute(NSForegroundColorAttributeName, value: UIColor.blackColor(), range: NSRange(location: 0,length: 13))
      coloredString1.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 13))
      
      Async.main { [weak self] in self?.priceLabel?.attributedText = coloredString1 }
      
      // init toucan
      var toucan1: Toucan? = Toucan(image: UIImage(named: "Icon-CallButton")!).resize(self?.callButton?.frame.size)
      
      Async.main { [weak self] in
        self?.callButton?.hidden = false
        self?.callButton?.setImage(toucan1?.image, forState: .Normal)
        // deinit toucan
        toucan1 = nil
      }
      
      var toucan2: Toucan? = Toucan(image: UIImage(named: "Icon-MessageButton")!).resize(self?.chatButton?.frame.size)
      
      Async.main { [weak self] in
        self?.chatButton?.hidden = false
        self?.chatButton?.setImage(toucan2?.image, forState: .Normal)
        toucan2 = nil
      }
      
      let string2 = "Condition: \(listing?.getConditionText() ?? "")"
      let coloredString2 = NSMutableAttributedString(string: string2)
      coloredString2.addAttribute(NSFontAttributeName, value: UIFont.asapBold(12), range: NSRange(location: 0,length: 10))
      
      Async.main { [weak self] in
        self?.conditionLabel?.attributedText = coloredString2
      }
    }
    
    if notesTextView?.attributedText == listing?.notes { return }
    else { notesTextView?.attributedText = nil }
      
    Async.background { [weak self, weak listing] in
      if let notes = listing?.notes {
        Async.main { [weak self] in
          self?.notesTitle?.text = !notes.isEmpty ? "Notes:" : nil
        }
      }
      
      // create paragraph style class
      var paragraphStyle: NSMutableParagraphStyle? = NSMutableParagraphStyle()
      paragraphStyle?.alignment = .Justified
      
      let attributedString: NSAttributedString = NSAttributedString(string: listing?.notes ?? "", attributes: [
        NSParagraphStyleAttributeName: paragraphStyle!,
        NSBaselineOffsetAttributeName: NSNumber(float: 0),
        NSForegroundColorAttributeName: UIColor.blackColor(),
        NSFontAttributeName: UIFont.asapRegular(12)
      ])
      
      // dealloc paragraph style
      paragraphStyle = nil
      
      Async.main { [weak self] in
        
        self?.notesTextView?.attributedText = attributedString
        self?.notesTextView?.sizeToFit()
        
        let height: CGFloat! = self?.notesTextView!.frame.size.height < 100 ? self?.notesTextView!.frame.size.height : 100
        var notesTitle: UILabel! = self?.notesTitle!
        
        self?.notesTextViewContainer?.alignAndFillWidth(
          align: .UnderCentered,
          relativeTo: notesTitle,
          padding: 11,
          height: height
        )
        
        notesTitle = nil
        
        self?.notesTextView?.fillSuperview()
        
        self?.notesTextViewContainer?.layer.mask = nil
        
        Async.background { [weak self] in
          let layer: CALayer! = self?.notesTextViewContainer?.layer
          let bounds: CGRect! = self?.notesTextViewContainer?.bounds
          var gradient: CAGradientLayer? = CAGradientLayer(layer: layer)
          gradient?.frame = bounds
          gradient?.colors = [UIColor.clearColor().CGColor, UIColor.whiteColor().CGColor]
          gradient?.startPoint = CGPoint(x: 0.0, y: 1.0)
          gradient?.endPoint = CGPoint(x: 0.0, y: 0.85)
          
          Async.main { [weak self] in
            self?.notesTextViewContainer?.layer.mask = gradient
            self?.notesTextViewContainer?.hidden = false
            gradient = nil
          }
        }
      }
    }
    
    // same things is happening as the view view before this
    layer.zPosition = 2
  }
  
  public func chatButtonPressed() {
    if let listing = listing { TabView.currentView()?.pushViewController(ChatView().setListing(listing).setUsers(UserModel.sharedUser().user, friend: listing.user), animated: true) }
  }
  
  public func callButtonPressed() {
    listing?.user?.phone?.callNumber()
  }
}












