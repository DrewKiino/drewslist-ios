//
//  UserProfileController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 11/7/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import SwiftyTimer

public class UserProfileController {
  
  private let model = UserProfileModel()
  private var view: UserProfileView?
  
  public func viewDidLoad() {
    // init fixtures
    setupFixtures()
  }
  
  public func userViewWillAppear() {
  }
  
  private func setupFixtures() {
    let dummyUser = User()
    dummyUser._id = "1234"
    dummyUser.firstName = "Harry"
    dummyUser.lastName = "Potter"
    dummyUser.username = "GriffindorLover"
    dummyUser.image = "http://orig06.deviantart.net/b682/f/2013/135/4/3/profile_picture_by_mellodydoll_stock-d65fbf8.jpg"
    dummyUser.bgImage = "http://www.mybulkleylakesnow.com/wp-content/uploads/2015/11/books-stock.jpg"
    
    let dummyBooks1: [Book] = {
      var books: [Book] = []
      for _ in 0...5 {
        let buyer = User()
        buyer.username = "Hector337"
        buyer.image = "http://d13pix9kaak6wt.cloudfront.net/background/users/k/i/n/kingstock_1423567467_43.jpg"
        
        let book = Book()
        book.bestBuyer = buyer
        book.bestBuyerListing = "50"
        book.smallImage = "https://booksend.files.wordpress.com/2011/07/deathly-hallows-swedish.jpg"
        
        books.append(book)
      }
      return books
    }()
    
    let dummyBooks2: [Book] = {
      var books: [Book] = []
      for _ in 0...3 {
        let seller = User()
        seller.username = "Hector337"
        seller.image = "http://orig12.deviantart.net/dfc1/f/2011/060/b/c/female_stock_023_by_animegirlfever_stock-d3aobnz.jpg"
        
        let book = Book()
        book.bestSeller = seller
        book.bestSellerListing = "40"
        book.smallImage = "http://www.hp-lexicon.org/images/covers/ss-cover-large.jpg"
        
        books.append(book)
      }
      return books
    }()
    
    dummyUser.saleList = dummyBooks1
    dummyUser.wishList = dummyBooks2
    
    model.user = dummyUser
  }
  
  public func getModel() -> UserProfileModel { return model }
}
