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
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
  
  public let _shouldHideBorder = Signal<Bool>()
  public var shouldHideBorder: Bool = false { didSet { _shouldHideBorder => shouldHideBorder } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  
}