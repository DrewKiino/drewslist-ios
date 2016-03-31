//
//  PaymentModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 3/30/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import Signals

public typealias CardInfo = (card_id: String?, number: String?, type: String?)

public class PaymentModel {
  
  private struct Singleton { private static let model = PaymentModel() }
  public class func sharedInstance() -> PaymentModel { return Singleton.model }
  
  public var _cards = Signal<[CardInfo]>()
  public var cards: [CardInfo] = [] { didSet { _cards => cards } }
}