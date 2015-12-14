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
  
  private var bookView: BookView?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    
    view.backgroundColor = UIColor.whiteColor()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    bookView?.anchorInCenter(width: screen.width, height: 200)
  }
  
  private func setupDataBinding() {
    controller.get_Book().listen(self) { [weak self] book in
      guard let book = book else { return }
      self?.bookView = BookView(book: book)
    }
  }
}