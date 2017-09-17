//
//  CustomAnimationPresenter.swift
//  ViewAllocationsExample
//
//  Created by Jason Picallos on 7/28/17.
//  Copyright © 2017 Greek APP. All rights reserved.
//
import UIKit

class CustomAnimation: NSObject, UIViewControllerAnimatedTransitioning {
  var transitionDuration: TimeInterval = 1.0
  enum Transition {
    case push
    case pop
    case modalPush
    case modalPop
  }
  
  var isModal = false
  func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0
  }
  
  func animateTransition(using _: UIViewControllerContextTransitioning) {}
}

// Custom object animation present
class CustomAnimationPresenter: CustomAnimation {
  
  override func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.transitionDuration
  }
  
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    // Custom animation transition
    let containerView = transitionContext.containerView
    
    // View Transitioning to
    guard let toView = transitionContext.view(forKey: .to) else { return }
    containerView.addSubview(toView)
    
    guard let fromView = transitionContext.view(forKey: .from) else { return }
    
    // Set frame prior to animation
    let startingFrame = CGRect(x: 0, y: toView.frame.height, width: toView.frame.width, height: toView.frame.height)
    toView.frame = startingFrame
    
    // Animate
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
      
      // Set frame post leaving animation
      toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
      if self?.isModal == false {
        fromView.frame = CGRect(x: 0, y: -fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
      }
      
    }) { _ in
      // Complete Animation
      transitionContext.completeTransition(true)
    }
  }
}
