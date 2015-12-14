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
  
  private var bookView: BookView? = BookView()
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupDataBinding()
    setupBookView()
    
    view.backgroundColor = UIColor.whiteColor()
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // fixtures
    controller.getBookFromServer("566e6fb9c2f704de12b77255")
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    bookView?.anchorAndFillEdge(.Top, xPad: 16, yPad: 16, otherSize: 200)
  }
  
  private func setupBookView() {
    view.addSubview(bookView!)
  }
  
  private func setupDataBinding() {
    controller.get_Book().listen(self) { [weak self] book in
      self?.bookView?.setBook(book)
    }
  }
}