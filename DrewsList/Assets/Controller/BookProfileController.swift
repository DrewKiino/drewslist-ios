//
//  BookProfileController.swift
//  DrewsList
//
//  Created by Kevin Mowers on 12/27/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import SwiftyTimer
import Signals
import Alamofire
import SwiftyJSON
import RealmSwift

public class BookProfileController {
  
  public let model = BookProfileModel()
  private var refrainTimer: NSTimer?
  private var view: BookProfileView?
  
  public func viewDidLoad() {
    
    log.debug(model.book)
    getBookFromServer()
  }
  
  public func setBookID(bookID: String?){
    model.book = Book(_id: bookID)
  }
  
  public func getBookFromServer() {
    guard let book_id = model.book?._id  else { return }
    
    // to safeguard against multiple server calls when the server has no more data
    // to send back, we use a timer to disable this controller's server calls
    model.shouldRefrainFromCallingServer = true
    
    Alamofire.request(.GET, ServerUrl.Staging.getValue() + "/book", parameters: [ "_id": book_id ], encoding: .URL)
      .response { [weak self] req, res, data, error in
        
        if let error = error {
          log.error(error)
        } else if let data = data, let json: JSON! = JSON(data: data) {
          
          log.debug(json)
          
          // create and  user object
          self?.model.book = Book(json: json)
        }
        
        // create a throttler
        // this will disable this controllers server calls for 10 seconds
        self?.refrainTimer?.invalidate()
        self?.refrainTimer = nil
        self?.refrainTimer = NSTimer.after(1.0) { [weak self] in
          // allow the controller to make server calls again
          self?.model.shouldRefrainFromCallingServer = false
        }
    }
    
    // just in case the doesn't ever respond...
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      // disable loading screen
      self?.model.shouldRefrainFromCallingServer = false
    }
    
  }
  
  public func getModel() -> BookProfileModel { return model }
  
  public func get_Book() -> Signal<Book?> { return model._book }
  public func getBook() -> Book? { return model.book }
  
  // MARK: Realm Functions
//  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
//  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(model.user), update: true) } }
}