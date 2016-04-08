//
//  IAPController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 4/6/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import StoreKit

public typealias ProductIdentifier = String
public typealias ProductsRequestCompletionHandler = (success: Bool, products: [SKProduct]?) -> ()
public typealias TransactionInProgressBlock = (inProgress: Bool) -> ()

public class IAPController: NSObject, SKProductsRequestDelegate, SKPaymentTransactionObserver {
  
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
  
  public override init() {
    super.init()
    
    // add the product identifiers for the payments
    productIdentifiers.insert(IAPController.DL_ListingFee)
    
    // add a transaction observer
    SKPaymentQueue.defaultQueue().addTransactionObserver(self)
  }
  
  deinit {
    SKPaymentQueue.defaultQueue().removeTransactionObserver(self)
  }
  
  
  public func purchaseProduct(product: SKProduct?) {
    if let product = product {
      SKPaymentQueue.defaultQueue().addPayment(SKPayment(product: product))
      transactionInProgressBlock?(inProgress: true)
    }
  }
  
  public func paymentQueue(queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    for transaction in transactions {
      
      switch transaction.transactionState {
        
      case SKPaymentTransactionState.Purchased:
        log.debug("Transaction completed successfully.")
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        transactionInProgressBlock?(inProgress: false)
        break
        
      case SKPaymentTransactionState.Failed:
        log.warning("Transaction Failed");
        SKPaymentQueue.defaultQueue().finishTransaction(transaction)
        transactionInProgressBlock?(inProgress: false)
        break
        
      default:
        break
      }
    }
  }
  
  public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    
    log.debug("number of products returned: \(response.products.count)")
    
    products = response.products
    productsRequestCompletionHandler?(success: true, products: response.products)
    
    clearRequestAndHandler()
  }
  
  public func requestProducts(completionHandler: ProductsRequestCompletionHandler? = nil) {
    
    if SKPaymentQueue.canMakePayments() {
      
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
}
