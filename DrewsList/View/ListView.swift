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

public class ListView: UIViewController {
  
  private let controller = ListController()
  private var model: ListModel { get { return controller.getModel() } }
  
  private var bookView: BookView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = UIColor.whiteColor()
    
    bookView  = BookView(book_id: "566e19abb9ac4f05d56b132a")
    
    view.addSubview(bookView!)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    
    bookView?.anchorInCenter(width: screen.width, height: 200)
  }
}