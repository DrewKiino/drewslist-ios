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
    
    public let model = BookModel()
  
  public func get_Book() -> Signal<Book?> { return model._book }
  
  public func getBook() -> Book? { return model.book }
  
    // MARK: Getters -> Model
    
//    public func getID() -> String? { return model.book._id }
//    public func get_ID() -> Signal<String?> { return model.book.__id }
//    
//    public func getTitle() -> String? { return model.book.title }
//    public func get_Title() -> Signal<String?> { return model.book._title }
//    
//    public func getSubtitle() -> String? { return model.book.subtitle }
//    public func get_Subtitle() -> Signal<String?> { return model.book._subtitle }
//    
//    public func getAuthors() -> [Author] { return model.book.authors }
//    public func get_Authors() -> Signal<[Author]> { return model.book._authors }
//    
//    public func getPublisher() -> String? { return model.book.publisher }
//    public func get_Publisher() -> Signal<String?> { return model.book._publisher }
//    
//    public func getPublishedDate() -> String? { return model.book.publishedDate }
//    public func get_PublishedDate() -> Signal<String?> { return model.book._publishedDate }
//    
//    public func getDescription() -> String? { return model.book.description }
//    public func get_Description() -> Signal<String?> { return model.book._description }
//    
//    public func getISBN10() -> String? { return model.book.ISBN10 }
//    public func get_ISBN10() -> Signal<String?> { return model.book._ISBN10 }
//    
//    public func getISBN13() -> String? { return model.book.ISBN13 }
//    public func get_ISBN13() -> Signal<String?> { return model.book._ISBN13 }
//    
//    public func pageCount() -> String? { return model.book.pageCount }
//    public func get_pageCount() -> Signal<String?> { return model.book._pageCount }
//    
//    public func getCategories() -> String? { return model.book.categories }
//    public func get_Categories() -> Signal<String?> { return model.book._categories }
//    
//    public func getAverageRating() -> String? { return model.book.averageRating }
//    public func get_AverageRating() -> Signal<String?> { return model.book._averageRating }
//    
//    public func getMaturityRating() -> String? { return model.book.maturityRating }
//    public func get_MaturityRating() -> Signal<String?> { return model.book._maturityRating }
//  
//    public func getLanguage() -> String? { return model.book.language }
//    public func get_Language() -> Signal<String?> { return model.book._language }
//    
//    public func getListPrice() -> String? { return model.book.listPrice }
//    public func get_ListPrice() -> Signal<String?> { return model.book._listPrice }
//    
//    public func getRetailPrice() -> String? { return model.book.retailPrice }
//    public func get_RetailPrice() -> Signal<String?> { return model.book._retailPrice }
//    
//    public func getSmallImage() -> String? { return model.book.smallImage }
//    public func get_SmallImage() -> Signal<String?> { return model.book._smallImage }
//    
//    public func getLargeImage() -> String? { return model.book.largeImage }
//    public func get_LargeImage() -> Signal<String?> { return model.book._largeImage }
  
  
    
}
