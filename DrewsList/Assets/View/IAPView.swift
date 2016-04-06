//
//  IAPView.swift
//  DrewsList
//
//  Created by Andrew Aquino on 4/6/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import StoreKit

public class IAPView: UIViewController {
  
  private let controller = IAPController()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .whiteColor()
    
    controller.requestProducts() { (bool, products) in
      log.debug("mark")
    }
    
  }
}