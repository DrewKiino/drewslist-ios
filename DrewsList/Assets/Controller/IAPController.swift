//
//  IAPController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 4/6/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import StoreKit
import Alamofire
import SwiftyJSON

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (success: Bool, products: [SKProduct]?) -> ()
public typealias TransactionInProgressBlock = (inProgress: Bool) -> ()
public typealias TransactionSuccessBlock = (success: Bool) -> ()

public class IAPController: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
  private struct Singleton {
    static let controller = IAPController()
  }
  
  public class func sharedInstance() -> IAPController {
    return Singleton.controller
  }
  
  // MARK: Static Vars
  
  public static let prefix: String = "com.totemv.drewslistios."
  public static let DL_ListingFee: String = "DL0001"
  
  // MARK: Vars
  
  private var productsRequest: SKProductsRequest?
  public var productIdentifiers = Set<ProductIdentifier>()
  
  public var products: [SKProduct]?
  
  // MARK: Blocks
  
  public var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  public var transactionInProgressBlock: TransactionInProgressBlock?
  public var transactionSuccessBlock: TransactionSuccessBlock?
  
  public override init() {
    super.init()
    
    // add the product identifiers for the payments
    productIdentifiers.insert(IAPController.DL_ListingFee)
    
    // add a transaction observer
    SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
  }
  
  deinit {
    SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
  }
  
  
  public func purchaseProduct(product: SKProduct?) {
    
    let _id: String = UserModel.sharedUser().user?._id ?? ""
    // make sure user exists in server
    let parameters: [ String: AnyObject ] = [
      "_id": _id
    ]
    
    DLHTTP.GET("/user/find", parameters: parameters) { [weak self] (json, error) in
      if  let json = json, let product = product where Sockets.sharedInstance().isConnected() && json["null"].string != "null" && json["error"].string == nil {
        // make sure we are connected to the server
        log.debug("transaction in progress...")
        SKPaymentQueue.defaultQueue().addPayment(SKPayment(product: product))
        self?.transactionInProgressBlock?(inProgress: true)
      } else {
        // user does not exist
        self?.transactionSuccessBlock?(success: false)
      }
    }
  }
  
  public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      
      switch transaction.transactionState {
        
      case SKPaymentTransactionState.Purchased:
        log.info("Transaction completed successfully.")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        transactionInProgressBlock?(inProgress: false)
        validatePurchaseInServer(transaction.payment)
        break
        
      case SKPaymentTransactionState.Failed:
        log.warning("Transaction Failed.");
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        transactionInProgressBlock?(inProgress: false)
        break
        
      default:
        break
      }
    }
  }
  
  public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    
    products = response.products
    productsRequestCompletionHandler?(success: true, products: response.products)
    
    clearRequestAndHandler()
  }
  
  public func requestProducts(completionHandler: ProductsRequestCompletionHandler? = nil) {
    
    if SKPaymentQueue.canMakePayments() && UserModel.sharedUser().user?._id != nil {
      
      SKPaymentQueue.defaultQueue().restoreCompletedTransactions()
      
      products = nil
      
      productsRequest?.cancel()
      productsRequestCompletionHandler = completionHandler
      
      productsRequest = SKProductsRequest(productIdentifiers: [IAPController.DL_ListingFee])
      productsRequest!.delegate = self
      productsRequest!.start()
      
    } else {
      
      log.warning("Cannot perform In App Purchases.")
    }
  }
  
  public func request(request: SKRequest, didFailWithError error: NSError) {
    log.error(error)
    productsRequestCompletionHandler?(success: false, products: nil)
    clearRequestAndHandler()
  }
  
  private func clearRequestAndHandler() {
    productsRequest = nil
    productsRequestCompletionHandler = nil
  }
  
  private func validatePurchaseInServer(payment: SKPayment) {
    
    let user_id: String = UserModel.sharedUser().user?._id ?? ""
    let session_id: String = Sockets.sharedInstance().session_id ?? ""
    let receipt: NSString = (try! NSData(contentsOfURL: NSBundle.mainBundle().appStoreReceiptURL!, options: [])).base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    
    let parameters: [ String: AnyObject ] = [
      "user_id": user_id,
      "session_id": session_id,
      "product_id": payment.productIdentifier,
      "receipt": receipt
    ]
    
    DLHTTP.POST("/listing/validatePurchase", parameters: parameters) { [weak self] (json, error) in
      if let json = json where json["null"].string != "null" {
        self?.transactionSuccessBlock?(success: true)
        UserModel.setSharedUser(User(json: json))
      }
    }
  }
}














