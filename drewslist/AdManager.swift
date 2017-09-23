//
//  AdManager.swift
//  DrewsList
//
//  Created by Andrew Aquino on 9/17/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation

class AdManager: NSObject {
  static let shared = AdManager()
  var vungle: VungleSDK?
  private static let placementID = "DEFAULT48589"
  fileprivate var adClosedHandler: ((Bool) -> ())?
  var isReadyToShowAds: Bool {
    return vungle?.isInitialized == true && vungle?.isAdCached(forPlacementID: AdManager.placementID) == true
  }
  class func setup() {
    let this = AdManager.shared
    let appID = "59be24d48a12bf9245000ed1"
    let sdk: VungleSDK = VungleSDK.shared()
    sdk.delegate = this
    let placements: [String] = [
      AdManager.placementID
    ]
    do {
      try sdk.start(withAppId: appID, placements: placements)
      this.vungle = sdk
    } catch let error {
      log.error(error)
    }
  }

  func show(withPresenting viewController: UIViewController, completionHandler: ((Bool) -> Void)? = nil) {
    if isReadyToShowAds {
      do {
        try vungle?.playAd(viewController, options: nil, placementID: AdManager.placementID)
      } catch let error as NSError {
        log.error(error)
      }
      self.adClosedHandler = completionHandler
    }
  }
}

extension AdManager: VungleSDKDelegate {
  
  func vungleSDKDidInitialize() {
    log.info("vungleSDK initialized")
  }
  
  func vungleWillCloseAd(with info: VungleViewInfo, placementID _: String) {
    if info.didDownload == 1 {
      log.info("user did tap download")
    }
    if info.completedView == 1 {
      log.info("user did watch ad")
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [weak self] in
      self?.adClosedHandler?(info.completedView == 1)
    }
  }
  
  func vungleSDKFailedToInitializeWithError(_ error: Error) {
    log.info("vungleSDK failed to initialized")
  }
  
  func vungleAdPlayabilityUpdate(_ isAdPlayable: Bool, placementID: String?) {
    log.info(isAdPlayable, placementID)
  }
  
  func vungleWillShowAd(forPlacementID _: String?) {
    log.info("vungleSDK will show ad")
  }
}
