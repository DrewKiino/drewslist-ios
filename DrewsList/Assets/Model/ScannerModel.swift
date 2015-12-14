//
//  ScannerModel.swift
//  ISBN_Scanner_Prototype
//
//  Created by Andrew Aquino on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class ScannerModel {
  
  public let _isbn = Signal<String?>()
  public var isbn: String? { didSet { _isbn => isbn } }
  
  public let _shouldHideBorder = Signal<Bool>()
  public var shouldHideBorder: Bool = false { didSet { _shouldHideBorder => shouldHideBorder } }
}