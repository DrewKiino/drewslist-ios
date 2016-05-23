//
//  PaymentInputController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 3/30/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Stripe
import Alamofire
import SwiftyJSON
import CreditCardValidator

public typealias HTTPCompletionBlock = (json: JSON, error: NSError?) -> Void

public class PaymentInputController {
  
  public let model = PaymentModel.sharedInstance()
  
  public func createTokenWithCard(card: STPCardParams?, completionBlock: STPTokenCompletionBlock?) {
    if let card = card {
      STPAPIClient.sharedClient().createTokenWithCard(card) { (token, error) in
        completionBlock?(token, error)
        if let error = error {
          log.error(error)
        } else {
          log.info(token)
        }
      }
    }
  }
  
  public func createCustomerInServer(token: STPToken?, completionBlock: HTTPCompletionBlock) {
    
    // app should crash because these assertions should always pass!
    assert(UserModel.sharedUser().user?._id != nil, "user_id needed for saving token to server")
    assert(token != nil, "token shouldn't be nil")
    
    if  let user_id = UserModel.sharedUser().user?._id, let token = token {
      Alamofire.request(.POST, ServerUrl.Default.getValue() + "/payment/createCustomer", parameters: [
        "user_id": user_id,
        "token": token,
        ] as [ String: AnyObject ] )
        .response { req, res, data, error in
          completionBlock(json: JSON(data: data ?? NSData()), error: error)
          if let error = error {
            log.error(error)
          } else if let data = data, let json: JSON! = JSON(data: data) {
            if let error = json["error"].string {
              log.error(error)
            } else {
              log.debug(json)
            }
          }
      }
    }
  }
  
  public func saveTokenToServer(token: STPToken?, cardParams: STPCardParams?, completionBlock: HTTPCompletionBlock) {
    
    // app should crash because these assertions should always pass!
    assert(UserModel.sharedUser().user?._id != nil, "user_id needed for saving token to server")
    assert(token != nil, "token shouldn't be nil")
    assert(cardParams != nil, "card params shouldn't be nil")
    
    if  let user_id = UserModel.sharedUser().user?._id,
        let token = token,
        let cardNumber = cardParams?.number?.substringWithRange(12, length: 4),
        let cardType = getCreditCardType(cardParams?.number)
    {
      Alamofire.request(.POST, ServerUrl.Default.getValue() + "/payment/setToken", parameters: [
        "user_id": user_id,
        "token": token,
        "cardNumber": cardNumber,
        "cardType": cardType
      ] as [ String: AnyObject ] )
      .response { [weak self] req, res, data, error in
        completionBlock(json: JSON(data: data ?? NSData()), error: error)
        if let error = error {
          log.error(error)
        } else if let data = data, let json: JSON! = JSON(data: data) {
          if let error = json["error"].string {
            log.error(error)
            
          } else if let jsonArray: [JSON] = JSON(data: data)["payments"].array {
            
            self?.model.cards.removeAll(keepCapacity: false)
            
            for json in jsonArray {
              if let card_id = json["card_id"].string, let number = json["cardNumber"].string, let type = json["cardType"].string, let isDefault = json["default"].bool {
                self?.model.cards.append((card_id, number, type, isDefault) as CardInfo)
              }
            }
          }
        }
      }
    }
  }
  
  public func getCreditCardType(cardNumber: String?) -> String? {
    if let cardNumber = cardNumber {
      return CreditCardValidator().typeFromString(cardNumber)?.name.lowercaseString
    } else {
      return nil
    }
  }
}