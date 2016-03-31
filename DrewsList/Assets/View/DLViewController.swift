//
//  DLViewController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 3/30/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import UIKit

public class DLViewController: UIViewController {
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupSelf()
  }
  
  public func setupSelf() {
    
  }
  
  public func setNavBarTitle(title: String) {
    var label: UILabel! = UILabel(frame: CGRectMake(0, 0, 160, 20))
    label.textColor = .whiteColor()
    label.font = .asapBold(16)
    label.text = title
    navigationItem.titleView = label
    label = nil
  }
}