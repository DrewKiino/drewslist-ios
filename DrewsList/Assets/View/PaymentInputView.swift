//
//  CreditCardInputView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 3/28/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit
import Neon
import TextFieldEffects
import Stripe
import Signals
import SwiftyJSON

public class PaymentInputView: DLViewController, UITableViewDelegate, UITableViewDataSource {
  
  private let controller = PaymentInputController()
  private var model: PaymentModel { get { return controller.model } }
  
  private var tableView: DLTableView?
  
  private var validCard: Bool = false
  private var cardParams: STPCardParams?
  
  private var _shouldDismissKeyboard = Signal<()>()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupTableView()
    setupButtons()
    
    tableView?.fillSuperview()
  }
  
  public override func setupSelf() {
    super.setupSelf()
    
    view.backgroundColor = .whiteColor()
    
    title = "Add Payment"
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    view.addSubview(tableView!)
  }
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    switch indexPath.row {
    case 0: return 56
    default: return 36
    }
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 1
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    switch indexPath.row {
    case 0:
      if let cell = tableView.dequeueReusableCellWithIdentifier("PaymentInputCell", forIndexPath: indexPath) as? PaymentInputCell {
        _shouldDismissKeyboard.removeAllListeners()
        _shouldDismissKeyboard.listen(self) { [weak cell] in
          cell?.dismissKeyboard()
        }
        cell.validCard = { [weak self] (cardParams, isValid) in
          self?.cardParams = cardParams
          self?.validCard = isValid
        }
        cell.onSelect = {
        }
        return cell
      }
      break
    default: break
    }
    
    return DLTableViewCell()
  }
  
  public func dismissKeyboard() {
    _shouldDismissKeyboard.fire()
  }
  
  private func setupButtons() {
    setButton(.RightBarButton, title: "Save", target: self, selector: "save")
  }
  
  public func save() {
    
    if !validCard {
      
      showAlert("Invalid Card", message: "Please verify that the details of your card is correct.")
      
    } else {
      
      showActivity(.RightBarButton)
        
      controller.createTokenWithCard(cardParams) { [weak self] (token, error) in
        if error != nil {
          
          self?.showAlert("Our apologies!", message: "An error has occurred and we are unable to process your card. \u{1F623}")
          
        } else {
          
          self?.controller.saveTokenToServer(token, cardParams: self?.cardParams) { [weak self] (json, error) in
            self?.controller.createCustomerInServer(token) { [weak self] (json, error) in
              
              self?.setButton(.RightBarButton, title: "Save", target: self, selector: "save")
              
              if json["error"].string == nil {
                self?.navigationController?.popViewControllerAnimated(true)
              }
            }
          }
        }
      }
    }
  }
}

public class PaymentInputCell: DLTableViewCell, STPPaymentCardTextFieldDelegate {
  
  private var paymentTextField: STPPaymentCardTextField?
  
  public typealias validCardCallback = (cardParams: STPCardParams?, isValid: Bool) -> Void
  
  public var validCard: validCardCallback?
  
  public var onSelect: (() -> Void)?
  
  public override func setupSelf() {
    super.setupSelf()
    
    addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selected"))
    
    setupTextField()
  }
  
  public override func layoutSubviews() {
    super.layoutSubviews()
    
    paymentTextField?.fillSuperview(left: 8, right: 8, top: 8, bottom: 8)
  }
  
  private func setupTextField() {
    paymentTextField = STPPaymentCardTextField()
    paymentTextField?.delegate = self
    addSubview(paymentTextField!)
  }
  
  public func dismissKeyboard() {
    paymentTextField?.resignFirstResponder()
  }
  
  public func paymentCardTextFieldDidChange(textField: STPPaymentCardTextField) {
    validCard?(cardParams: textField.cardParams, isValid: textField.valid)
  }
  
  public func selected() {
    onSelect?()
  }
}









