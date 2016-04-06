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

public class IAPController: NSObject, SKProductsRequestDelegate {
  
  // MARK: Static Vars
  
  public static let prefix: String = "com.totemv.drewslistios."
  public static let DL_ListingFee: String = prefix + "DL_ListingFee"
  
  // MARK: Vars
  
  private var productsRequest: SKProductsRequest?
  public var productIdentifiers = Set<ProductIdentifier>()
  
  // MARK: Blocks
  
  public var productsRequestCompletionHandler: ProductsRequestCompletionHandler?
  
  public override init() {
    super.init()
    productIdentifiers.insert(IAPController.DL_ListingFee)
  }
  
  public func productsRequest(request: SKProductsRequest, didReceiveResponse response: SKProductsResponse) {
    
    print("Loaded list of products...")
    
    log.debug(response.products)
    
    let products = response.products
    
    productsRequestCompletionHandler?(success: true, products: products)
    
    clearRequestAndHandler()
    
    for p in products {
      print("Found product: \(p.productIdentifier) \(p.localizedTitle) \(p.price.floatValue)")
    }
  }
  
  public func requestProducts(completionHandler: ProductsRequestCompletionHandler) {
    
    productsRequest?.cancel()
    productsRequestCompletionHandler = completionHandler
    
    log.debug(IAPController.DL_ListingFee)
    
    productsRequest = SKProductsRequest(productIdentifiers: [IAPController.DL_ListingFee])
    productsRequest!.delegate = self
    productsRequest!.start()
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