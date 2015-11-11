//
//  ViewController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 10/28/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import Alamofire
import Socket_IO_Client_Swift
import SwiftyJSON
import SwiftyTimer

public class ViewController: UIViewController {

  private let url = "http://localhost:1337/"
  let socket = SocketIOClient(socketURL: "localhost:1337", options: [.Log(false), .ForcePolling(false)])
  let response = UILabel(frame: CGRectMake(64, 124, 256, 48))
  let request = UITextField(frame: CGRectMake(64, 172, 256, 48))
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    
    print("hello, world!")
    socket.on("message") { data in
      print(data)
    }
    socket.on("broadcastCallback") { data in
      if let response = data.0.first?.valueForKey("response") {
        print(response)
      } else if let error = data.0.first?.valueForKey("error") {
        print(error)
      }
    }
    socket.on("checkForMessagesCallback") { data in
      if let response = data.0.first?.valueForKey("response") {
        print(response)
      } else if let error = data.0.first?.valueForKey("error") {
        print(error)
      }
    }
    socket.connect()
    
    NSTimer.after(1.0) { [unowned self] in
      self.socket.emit("subscribe", "56413a1512d4fb16616a8af0")
      
      let message: [String: AnyObject] = [
        "user_id": "56413a1512d4fb16616a8af0",
        "friend_id": "56413a2e12d4fb16616a8af3",
        "friend_username": "Jynx",
        "message": "Hello, how are you?"
      ]
      
      self.socket.emit("broadcast", message)
    }
    
    NSTimer.after(3.0) { [unowned self] in
      self.socket.emit("subscribe", "56413a2e12d4fb16616a8af3")
      self.socket.emit("checkForMessages", "56413a2e12d4fb16616a8af3")
    }
    
    NSTimer.after(4.0) { [unowned self] in
      let message: [String: AnyObject] = [
        "user_id": "56413a2e12d4fb16616a8af3",
        "friend_id": "56413a1512d4fb16616a8af0",
        "friend_username": "Graves",
        "message": "I'm fine thank you :)"
      ]
      self.socket.emit("broadcast", message)
    }
    
    NSTimer.after(10.0) { [unowned self] in
      self.socket.disconnect()
    }
  }
  
  
  private func initButton() {
    let button1 = UIButton(frame: CGRectMake(64, 24, 100, 24))
    button1.setTitle("connect", forState: .Normal)
    button1.setTitleColor(UIColor.blackColor(), forState: .Normal)
    button1.addTarget(
      self,
      action: "connect",
      forControlEvents:
      .TouchUpInside
    )
    view.addSubview(button1)
    
    let button2 = UIButton(frame: CGRectMake(64, 48, 100, 24))
    button2.setTitle("send", forState: .Normal)
    button2.setTitleColor(UIColor.blackColor(), forState: .Normal)
    button2.addTarget(
      self,
      action: "send",
      forControlEvents:
      .TouchUpInside
    )
    view.addSubview(button2)
    
    let button3 = UIButton(frame: CGRectMake(64, 72, 100, 24))
    button3.setTitle("disconnect", forState: .Normal)
    button3.setTitleColor(UIColor.blackColor(), forState: .Normal)
    button3.addTarget(
      self,
      action: "disconnect",
      forControlEvents:
      .TouchUpInside
    )
    view.addSubview(button3)
    view.addSubview(response)
    request.backgroundColor = UIColor.grayColor()
    view.addSubview(request)
  }
  
  public func send() {
    socket.emit("message", [
      "message": request.text!
    ])
  }
  
  public func connect() {
    log.debug("connecting to server...")
    socket.connect()
  }
  
  public func disconnect() {
    log.debug("disconnecting from server...")
    socket.emit("unsubscribe", [ "room": "global" ])
  }

  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
    
  }
}

