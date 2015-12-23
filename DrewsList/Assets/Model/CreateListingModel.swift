//
//  CreateListingModel.swift
//  DrewsList
//
//  Created by Andrew Aquino on 12/20/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class CreateListingModel {
  
  public let _listing = Signal<Listing?>()
  public var listing: Listing? = Listing() { didSet { _listing => listing } }
  
  public let _book = Signal<Book?>()
  public var book: Book? { didSet { _book => book } }
  
  public let _user = Signal<User?>()
  public var user: User? { didSet { _user => user } }
  
  public let _shouldHideBorder = Signal<Bool>()
  public var shouldHideBorder: Bool = false { didSet { _shouldHideBorder => shouldHideBorder } }
  
  public let _shouldRefrainFromCallingServer = Signal<Bool>()
  public var shouldRefrainFromCallingServer: Bool = false { didSet { _shouldRefrainFromCallingServer => shouldRefrainFromCallingServer } }
  
  public let _serverCallbackFromUploadListing = Signal<Bool>()
  public var serverCallbackFromUploadlIsting: Bool = false { didSet { _serverCallbackFromUploadListing => serverCallbackFromUploadlIsting } }
}