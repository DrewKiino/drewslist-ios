//
//  PaymentController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 3/30/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import SwiftyJSON

public typealias Payment = (customer_id: String?, token: String?, amount: String?, currency: String?, description: String?)

public class PaymentController {
  
  public let model = PaymentModel.sharedInstance()
  
  public class func chargePaymentToken(payment: Payment?, completionBlock: HTTPCompletionBlock) {
    
    assert(payment != nil, "payment should not be nil")
    
    if let payment = payment {
      Alamofire.request(.POST, ServerUrl.Local.getValue() + "/payment/chargePaymentToken", parameters: [
        "token": payment.token ?? "",
        "amount": payment.amount ?? "",
        "currency": payment.currency ?? "",
        "description": payment.description ?? ""
      ] as [ String: AnyObject ])
      .response { (request, response, data: NSData?, error: NSError?) in
        completionBlock(json: JSON(data: data ?? NSData()), error: error)
        log.debug(request?.URLString)
        log.debug(JSON(data: data!))
      }
    }
  }
  
  public class func chargeCustomer(payment: Payment?, completionBlock: HTTPCompletionBlock) {
    
    assert(payment != nil, "payment should not be nil")
    
    if let payment = payment {
      Alamofire.request(.POST, ServerUrl.Local.getValue() + "/payment/chargeCustomer", parameters: [
        "customer_id": payment.customer_id ?? "",
        "amount": payment.amount ?? "",
        "currency": payment.currency ?? "",
        "description": payment.description ?? ""
        ] as [ String: AnyObject ])
      .response { (request, response, data: NSData?, error: NSError?) in
        completionBlock(json: JSON(data: data ?? NSData()), error: error)
        log.debug(request?.URLString)
        log.debug(JSON(data: data!))
      }
    }
  }
  
  public func getPaymentInfoFromServer() {
    
    // DEBUG
    UserModel.setSharedUser(User().set(_id: "56fc4a137238d7cb0903639c"))
    
    assert(UserModel.sharedUser().user?._id != nil, "user_id should not be nil")
    
    if let user_id = UserModel.sharedUser().user?._id {
      Alamofire.request(.GET, ServerUrl.Default.getValue() + "/payment/getPaymentInfo?user_id=\(user_id)")
      .response { [weak self] req, res, data, error in
        if let error = error {
          log.error(error)
        } else if let data = data, let jsonArray: [JSON] = JSON(data: data)["payments"].array {
          
          self?.model.cards.removeAll(keepCapacity: false)
          
          log.debug(jsonArray)
          
          for json in jsonArray {
            if let number = json["cardNumber"].string, let type = json["cardType"].string {
              self?.model.cards.append((number, type) as CardInfo)
            }
          }
        }
      }
    }
  }
}