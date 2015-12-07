//
//  ResetController.swift
// //RMprallax 
//
//  Created by Starflyer on 11/29/15.
//  Copyright © 2015 abearablecode. All rights reserved.
///

import UIKit
import Onboard
import Toucan

public class OnboardingView : UIPageViewController, UIPageViewControllerDataSource {
  
  private var myViewControllers = Array(count: 2, repeatedValue:UIViewController())
  private var skipButton: UIButton?
  
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupOnboardingView()
  }
  
  private func setupOnboardingView() {
    
    skipButton = UIButton(frame: CGRectMake((view.frame.width / 2) - 50, view.frame.height - 60, 100, 48))
    skipButton?.addTarget(self, action: "skipOnboarding", forControlEvents: .TouchUpInside)
    
    let firstPage = UIViewController()
    let secondPage = UIViewController()
    let thirdPage = UIViewController()
    let fourthPage = UIViewController()
    let fifthPage = UIViewController()
    
    let firstPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding1")!).resize(firstPage.view.frame.size, fitMode: .Clip).image)
    firstPageBG.frame = firstPage.view.frame
    firstPage.view.addSubview(firstPageBG)
    firstPage.view.addSubview(skipButton!)
    
    let secondPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding2")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    secondPageBG.frame = firstPage.view.frame
    secondPage.view.addSubview(secondPageBG)
    
    let thirdPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding3")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    thirdPageBG.frame = thirdPage.view.frame
    thirdPage.view.addSubview(thirdPageBG)
    
    let fourthPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding4")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    fourthPageBG.frame = fourthPage.view.frame
    fourthPage.view.addSubview(fourthPageBG)
    
    let fifthPageBG = UIImageView(image: Toucan(image: UIImage(named: "onboarding5")!).resize(secondPage.view.frame.size, fitMode: .Clip).image)
    fifthPageBG.frame = fifthPage.view.frame
    fifthPage.view.addSubview(fifthPageBG)
    
    self.myViewControllers = [firstPage, secondPage, thirdPage, fourthPage, fifthPage]
    
    dataSource = self
    
    setViewControllers([firstPage], direction:.Forward, animated:false, completion:nil)
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex =  self.myViewControllers.indexOf(viewController)! + 1
    if currentIndex >= self.myViewControllers.count { return nil }
    
    let currentView = self.myViewControllers[currentIndex]
    
    currentView.view.addSubview(skipButton!)
    
    return currentView
  }
  
  public func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
    let currentIndex =  self.myViewControllers.indexOf(viewController)! - 1
    if currentIndex < 0 { return nil }
    
    let currentView = self.myViewControllers[currentIndex]
    
    currentView.view.addSubview(skipButton!)
    
    return currentView
  }
  
  public func skipOnboarding() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
}
