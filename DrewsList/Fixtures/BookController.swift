//
//  BookController.swift
//  DrewsList
//
//  Created by Steven Yang on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import Signals

public class BookController {
    
    let model = Book()
    
    // MARK: Getters -> Model
    
    public func getID() -> String? { return model._id }
    public func get_ID() -> Signal<String?> { return model.__id }
    
    public func getTitle() -> String? { return model.title }
    public func get_Title() -> Signal<String?> { return model._title }
    
    public func getSubtitle() -> String? { return model.subtitle }
    public func get_Subtitle() -> Signal<String?> { return model._subtitle }
    
    public func getAuthors() -> String? { return model.authors }
    public func get_Authors() -> Signal<String?> { return model._authors }
    
    public func getPublisher() -> String? { return model.publisher }
    public func get_Publisher() -> Signal<String?> { return model._publisher }
    
    public func getPublishedDate() -> String? { return model.publishedDate }
    public func get_PublishedDate() -> Signal<String?> { return model._publishedDate }
    
    public func getDescription() -> String? { return model.description }
    public func get_Description() -> Signal<String?> { return model._description }
    
    public func getISBN10() -> String? { return model.ISBN10 }
    public func get_ISBN10() -> Signal<String?> { return model._ISBN10 }
    
    public func getISBN13() -> String? { return model.ISBN13 }
    public func get_ISBN13() -> Signal<String?> { return model._ISBN13 }
    
    public func pageCount() -> String? { return model.pageCount }
    public func get_pageCount() -> Signal<String?> { return model._pageCount }
    
    public func getCategories() -> String? { return model.categories }
    public func get_Categories() -> Signal<String?> { return model._categories }
    
    public func getAverageRating() -> String? { return model.averageRating }
    public func get_AverageRating() -> Signal<String?> { return model._averageRating }
    
    public func getMaturityRating() -> String? { return model.maturityRating }
    public func get_MaturityRating() -> Signal<String?> { return model._maturityRating }
  
    public func getLanguage() -> String? { return model.language }
    public func get_Language() -> Signal<String?> { return model._language }
    
    public func getListPrice() -> String? { return model.listPrice }
    public func get_ListPrice() -> Signal<String?> { return model._listPrice }
    
    public func getRetailPrice() -> String? { return model.retailPrice }
    public func get_RetailPrice() -> Signal<String?> { return model._retailPrice }
    
    public func getSmallImage() -> String? { return model.smallImage }
    public func get_SmallImage() -> Signal<String?> { return model._smallImage }
    
    public func getLargeImage() -> String? { return model.largeImage }
    public func get_LargeImage() -> Signal<String?> { return model._largeImage }
    
}
