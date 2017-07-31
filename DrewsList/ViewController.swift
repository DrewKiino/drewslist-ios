//
//  ViewController.swift
//  DrewsList
//
//  Created by Andrew Aquino on 9/30/16.
//  Copyright © 2016 Andrew Aquino. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    
    // DEBUG: sign in anonymously so we can read and write
    AuthenticationManager.signInAnonymously() { user in
      // -LRegPMclwqRqbFH9jhcVO8b7a8x2-Tvvv56DZB6QgTwEpimisNIkKjY53
      ChatManager.join(["Tvvv56DZB6QgTwEpimisNIkKjY53"]) { [weak self] model in
        self?.navigationController?.pushViewController(ChatView(model: model), animated: false)
      }
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}

