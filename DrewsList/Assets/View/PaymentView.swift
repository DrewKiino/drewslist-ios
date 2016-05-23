//
//  PaymentView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 3/30/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Neon

public class PaymentView: DLViewController, UITableViewDataSource, UITableViewDelegate {
  
  private let controller = PaymentController()
  private var model: PaymentModel { get { return controller.model } }
  
  private var tableView: DLTableView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setNavBarTitle("Manage Payments")
    title = "Manage Payments"
    
    setupTableView()
    setupDataBinding()
    
    tableView?.fillSuperview()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    controller.getPaymentInfoFromServer()
  }
  
  public func setupDataBinding() {
    model._cards.removeAllListeners()
    model._cards.listen(self) { [weak self] cards in
      self?.tableView?.reloadData()
    }
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 36
    case 1: return 24
    default: return 48
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.cards.count + 2
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("FullTitleCell", forIndexPath: indexPath) as? FullTitleCell {
        cell.titleButton?.setTitle("Add Payment", forState: .Normal)
        cell.onClick = { [weak self] in
          self?.navigationController?.pushViewController(PaymentInputView(), animated: true)
        }
        return cell
      }
      break
    case 1:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaddingCell", forIndexPath: indexPath) as? PaddingCell {
        cell.paddingLabel?.text = "Cards"
        return cell
      }
      break
    default:
      if let cell = tableView.dequeueReusableCellWithIdentifier("CardInfoCell", forIndexPath: indexPath) as? CardInfoCell {
        
        cell.cardType = model.cards[indexPath.row - 2].type
        cell.cardNumber = model.cards[indexPath.row - 2].number
        cell.isDefault = model.cards[indexPath.row - 2].isDefault
        
        cell.onSelect = { [weak self] in
          
          if let card_id = self?.model.cards[indexPath.row - 2].card_id, let number = self?.model.cards[indexPath.row - 2].number {
            
            var alertController: UIAlertController! = UIAlertController(title: "Edit Card", message: "PERSONAL **** \(number)", preferredStyle: .ActionSheet)
            
            if self?.model.cards[indexPath.row - 2].isDefault == false {
              alertController.addAction(UIAlertAction(title: "Make Default", style: .Default) { action in
                
                self?.showActivity(.RightBarButton)
                
                self?.controller.changeDefaultCard(card_id) { (json, error) in
                  
                  self?.hideActivity(.RightBarButton)
                  
                  self?.tableView?.reloadData()
                  
                  if error != nil || json["statusCode"].int == 404 {
                    self?.showAlert("Our apologies!", message: "An error has occurred and we are unable to set your default card. \u{1F623}")
                  }
                }
              })
            }
            
            alertController.addAction(UIAlertAction(title: "Delete", style: .Destructive) { action in
              
              self?.showActivity(.RightBarButton)
              
              self?.controller.deleteCardInServer(card_id) { (json, error) in
                
                  self?.hideActivity(.RightBarButton)
                
                self?.tableView?.reloadData()
                
                if error != nil || json["statusCode"].int == 404 {
                  self?.showAlert("Our apologies!", message: "An error has occurred and we are unable to delete your card. \u{1F623}")
                }
              }
            })
            
            alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { action in
            })
            
            self?.presentViewController(alertController, animated: true, completion: nil)
            
            alertController = nil
          }
        }
        return cell
      }
      break
    }
    
    return DLTableViewCell()
  }
}

public class CardInfoCell: DLTableViewCell {
  
  private var containerView: UIView?
  
  private var cardImageView: UIImageView?
  private var cardLabel: UILabel?
  
  public var isDefault: Bool = false
  
  public var cardNumber: String? {
    didSet {
      if let number = cardNumber {
        cardLabel?.text = "PERSONAL **** \(number)"
      }
    }
  }
  
  public var cardType: String? {
    didSet {
      if let cardType = cardType {
        cardImageView?.dl_setImage(UIImage(named: cardType))
      }
    }
  }
  
  public var onSelect: (() -> Void)?
  
  public override func setupSelf() {
    super.setupSelf()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selected"))
    
    setupContainerView()
    setupCardView()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    containerView?.fillSuperview(left: 8, right: 8, top: 8, bottom: 8)
    
    cardImageView?.anchorToEdge(.Left, padding: 8, width: 24, height: 24)
    cardLabel?.alignAndFillWidth(align: .ToTheRightCentered, relativeTo: cardImageView!, padding: 8, height: 36)
    
    containerView?.layer.borderColor = isDefault ? UIColor.juicyOrange().CGColor : UIColor.coolBlack().CGColor
  }
  
  private func setupContainerView() {
    containerView = UIView()
    containerView?.layer.borderWidth = 1.0
    containerView?.layer.cornerRadius = 5.0
    addSubview(containerView!)
  }
  
  private func setupCardView() {
    cardImageView = UIImageView()
    containerView?.addSubview(cardImageView!)
    
    cardLabel = UILabel()
    cardLabel?.textColor = .coolBlack()
    cardLabel?.font = .asapRegular(12)
    containerView?.addSubview(cardLabel!)
  }
  
  public func selected() {
    onSelect?()
  }
}