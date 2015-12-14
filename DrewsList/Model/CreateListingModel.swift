//
//  CreateListingModel.swift
//  DrewsList
//
//  Created by Steven Yang on 12/13/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals
import ObjectMapper

public class CreateListingModel : Mappable {
    
    public let _isbn = Signal<String?>()
    public var isbn: String? { didSet { _isbn => isbn } }
    
    public let _book = Signal<Book?>()
    public var book: Book? { didSet { _book => book } }
    
    required public init?(_ map: Map) {}
    
    public func mapping(map: Map) {
        
    }
}
