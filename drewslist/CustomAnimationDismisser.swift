//
//  CustomAnimationDismisser.swift
//  ViewAllocationsExample
//
//  Created by Jason Picallos on 7/28/17.
//  Copyright © 2017 Greek APP. All rights reserved.
//
import UIKit

class CustomAnimationDismisser: CustomAnimation {
  
  // MARK: Delegates
  override func transitionDuration(using _: UIViewControllerContextTransitioning?) -> TimeInterval {
    return self.transitionDuration
  }
  
  override func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    
    // Custom animation container for adding subviews
    let containerView = transitionContext.containerView
    
    guard let fromView = transitionContext.view(forKey: .from),
      let toView = transitionContext.view(forKey: .to) else { return }
    
    // Add View to container
    containerView.addSubview(toView)
    containerView.addSubview(fromView)
    
    if !isModal {
      toView.frame = CGRect(x: 0, y: -toView.frame.height, width: toView.frame.width, height: toView.frame.height)
    }
    
    // Animate
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: { [weak self] in
      // Set the frames post animation of dismissal
      if self?.isModal == false {
        toView.frame = CGRect(x: 0, y: 0, width: toView.frame.width, height: toView.frame.height)
      }
      fromView.frame = CGRect(x: 0, y: fromView.frame.height, width: fromView.frame.width, height: fromView.frame.height)
      
    }) { _ in
      transitionContext.completeTransition(true)
    }
  }
}
