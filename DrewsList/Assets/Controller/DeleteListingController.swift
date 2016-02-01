//
//  DeleteListingController.swift
//  DrewsList
//
//  Created by Starflyer on 1/17/16.
//  Copyright © 2016 Totem. All rights reserved.
//

import Foundation
import SwiftyTimer
import Signals
import Alamofire
import SwiftyJSON
import RealmSwift


public class DeleteListingController {

    public let model = DeleteListingModel()
    private var refrainTimer: NSTimer?
    private var view: EditListingView?
  
  
  public func viewDidLoad() {
  
    GetBookFromServer()
    
    
  }
  public func setBookID(bookID: String?) {
    model.book = Book(_id: bookID)
    
  }
  
  
  //MARK: Server Methods
  public func deleteListingFromServer() {
  
    
    
  }
  
  public func GetBookFromServer() {
    guard let book_id = model.book?._id else { return }
    
    //to secure against several multiple server call when the server has no more to //retrive, we also use time to impede the controller's calls
    model.shouldRefrainFromCallingServer = true
    
    
    Alamofire.request(.GET, ServerUrl.Default.getValue() + "/book", parameters: [ "_id": book_id ], encoding: .URL)
      .response { [weak self] req, res, data, error in
        if let error = error {
          log.error(error)
        } else if let data = data, let json: JSON! = JSON(data: data) {
          
          //create and userobject
          self?.model.book = Book(json: json)
          
        }
    
        //Throttler created
        self?.refrainTimer?.invalidate()
        self?.refrainTimer = nil
        self?.refrainTimer = NSTimer.after(1.0) { [weak self] in
          //allow the controller to do server calls once more
          self?.model.shouldRefrainFromCallingServer = false
          
        }
        
    }
    
    
    //In case no response 
    refrainTimer?.invalidate()
    refrainTimer = nil
    refrainTimer = NSTimer.after(60.0) { [weak self] in
      //disable loading screen
      self?.model.shouldRefrainFromCallingServer = false
      
    }
  }
  
    
        
        
   //Fetching the Model
  
  public func getModel() -> DeleteListingModel { return model }
  public func get_Book() -> Signal<Book?> { return model._book }
  public func getBook() -> Book? { return model.book }

  
  // MARK: Realm Functions
  //  public func readRealmUser() { if let realmUser =  try! Realm().objects(RealmUser.self).first { model.user = realmUser.getUser() } }
  //  public func writeRealmUser(){ try! Realm().write { try! Realm().add(RealmUser().setRealmUser(model.user), update: true) } }
        
        
  }










