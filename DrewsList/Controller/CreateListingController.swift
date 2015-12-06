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
import Signals

public class CreateListingController {
    
    // MARK: Properties
    private let isbn: String?
    
    public let model = Book()
    
    public let scannerController = ScannerController()
    
    public init() {
        
        isbn = scannerController.getISBN()
        print(isbn)
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
                        
                        self?.model._id = json["google_id"].description
                        self?.model.title = json["title"].description
                        self?.model.subtitle = json["subtitle"].description
                        self?.model.authors = json["authors"].description
                        self?.model.publisher = json["publisher"].description
                        self?.model.publishedDate = json["publishedDate"].description
                        self?.model.description = json["description"].description
                        self?.model.ISBN10 = json["ISBN10"].description
                        self?.model.ISBN13 = json["ISBN13"].description
                        self?.model.pageCount = json["pageCount"].description
                        self?.model.categories = json["categories"].description
                        self?.model.averageRating = json["averageRating"].description
                        self?.model.maturityRating = json["maturityRating"].description
                        self?.model.language = json["language"].description
                        self?.model.listPrice = json["listPrice"].description
                        self?.model.retailPrice = json["retailPrice"].description
                        self?.model.smallImage = json["smallImage"].description
                        self?.model.largeImage = json["largeImage"].description
                        
                        print(json)
                    }
                }
        }
    }
    
    
    // MARK: Server
    // Make the server call to populate the book model

    
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