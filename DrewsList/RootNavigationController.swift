//
//  RootNavigationController.swift
//  drewslist
//
//  Created by Andrew Aquino on 8/27/17.
//  Copyright © 2017 Andrew Aquino. All rights reserved.
//

import Foundation
import UIKit

class RootNavigationController: UINavigationController, UINavigationControllerDelegate {
  // singleton instance
  static let shared = RootNavigationController(rootViewController: RootController.shared)
  static var topPresentedViewController: UIViewController? {
    return RootController.shared.navigationController?.topViewController
  }
  // variables
  var currentTransition: CustomAnimation.Transition = .modalPush
  // controller life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    // remove  the nav bar because we are only interested in
    // the nav controller's view management functionality
    navigationBar.isHidden = true
    // set custom transition delegates
    delegate = self
    transitioningDelegate = self
  }
  
  override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
    if let topViewController = topViewController {
      topViewController.present(viewControllerToPresent, animated: flag, completion: completion)
    } else {
      super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
  }
  
  // use these methods to transition controllers
  // we wrap the original push method in a animation transaction so we are able
  // to have a callback after the transition ends
  func pushViewController(_ viewController: UIViewController?, animated: Bool, completionBlock: (() -> Void)?) {
    guard let viewController = viewController else { return }
    self.currentTransition = .modalPush
    CATransaction.begin()
    super.pushViewController(viewController, animated: animated)
    CATransaction.setCompletionBlock(completionBlock)
    CATransaction.commit()
  }
  
  // use this method to pop controllers
  func popViewController(animated: Bool, completionBlock: (() -> Void)?) -> UIViewController? {
    self.currentTransition = .modalPop
    CATransaction.begin()
    let poppedController = super.popViewController(animated: animated)
    CATransaction.setCompletionBlock(completionBlock)
    CATransaction.commit()
    return poppedController
  }
  
  @discardableResult
  func popToRootViewController(animated: Bool, completionBlock: (() -> Void)?) -> [UIViewController]? {
    self.currentTransition = .modalPop
    CATransaction.begin()
    let poppedControllers = super.popToRootViewController(animated: animated)
    CATransaction.setCompletionBlock(completionBlock)
    CATransaction.commit()
    return poppedControllers
  }
  
  @discardableResult
  func popToViewController(_ viewController: UIViewController, animated: Bool, completionBlock: (() -> Void)?) -> [UIViewController]? {
    self.currentTransition = .modalPop
    CATransaction.begin()
    let poppedControllers = super.popToViewController(viewController, animated: animated)
    CATransaction.setCompletionBlock(completionBlock)
    CATransaction.commit()
    return poppedControllers
  }
}

extension RootNavigationController: UIViewControllerTransitioningDelegate {
  // MARK: Animation Protocols conforming to Delegate
  func animationController(forPresented _: UIViewController, presenting _: UIViewController, source _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomAnimationPresenter()
  }
  
  func animationController(forDismissed _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return CustomAnimationDismisser()
  }
  
  func navigationController(_: UINavigationController, animationControllerFor _: UINavigationControllerOperation, from _: UIViewController, to _: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    let customAnimation: CustomAnimation!
    switch currentTransition {
    case .push, .modalPush:
      customAnimation = CustomAnimationPresenter()
      customAnimation.isModal = currentTransition == .modalPush
      break
    case .pop, .modalPop:
      customAnimation = CustomAnimationDismisser()
      customAnimation.isModal = currentTransition == .modalPop
      break
    }
    return customAnimation
  }
}

extension RootNavigationController {
  class func presented(with window: inout UIWindow?) {
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = RootNavigationController.shared
    window?.makeKeyAndVisible()
  }
}

