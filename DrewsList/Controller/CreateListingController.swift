//
//  CreateListingController.swift
//  DrewsList
//
//  Created by Steven Yang on 11/29/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

public class CreateListingController {
    
    public let book = Book()
    
    public init() {
        
    }
    
    public func getBook() {
        // using Alamofire, we create a request
        // and pass in the url and parameters
        // the parameter type is a [String: AnyObject], they represent JSON objects
        // that you can pass to the server
        Alamofire.request(.GET, "http://drewslist-staging.herokuapp.com/book/search?query=flowers+for+algernon")
            // then using the builder pattern, chain a response call after
            .response { [weak self] req, res, data, error in
                
                // unwrap error and check if it exists
                if let error = error {
                    
                    print(error)
                    
                    // use JSON library to jsonify the results ( NSData => JSON )
                    // since the results is an array of objects, we get the first name
                } else if let data = data, let jsonArray = JSON(data: data).array {
                    for json in jsonArray {
                        
                        self?.book.title = json["title"].description
                        
                        print(json)
                    }
                }
        }
    }

    
    // MARK: Book Listing
    // Book Image
    
    // 1. GET: smallImage
    
    // 2. Populate CLView with image
    
    // Book Title
    
    // Author
    
    // ISBN
    
    // Edition
    
    // Book Details
    
    // MARK: For
    // Toggle
    
    // MARK: Condition
    
    // MARK: Cover
    // Toggle Button
    
    // MARK: Price
    
    // MARK: Notes
    
}