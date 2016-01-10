//
//  BookProfileModel.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import UIKit
import Signals


public class BookProfileModel {
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book} }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
}