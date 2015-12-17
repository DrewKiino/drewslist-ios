//
//  ViewController.swift
//  ISBN_Scanner_Prototype
//
//  Created by Andrew Aquino on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import AVFoundation
import Toucan
import Neon

public class ScannerView: UIViewController {
    
  // MARK: Properties
  
  private var session: AVCaptureSession?
  private var previewLayer: AVCaptureVideoPreviewLayer?
  private var  identifiedBorder: DiscoveredBarCodeView?
  private weak var timer: NSTimer?
  
  private var topView: UIView?
  private var helpButton: UIButton?
  private var searchButton: UIButton?
  
  private let controller = ScannerController()
  
 // MARK: Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupScanner()
    setupTopView()
    setupHelpButton()
    setupSearchButton()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
  }
  
  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    session?.stopRunning()
  }
 
    // MARK: Setup
  private func setupTopView() {
    topView = UIView(frame: CGRectMake(0, 16, view.frame.width, 100))
    view.addSubview(topView!)
  }
  
  private func setupHelpButton() {
    helpButton = UIButton(frame: CGRectMake(0, 0, 48, 48))
    guard let helpButton = helpButton,
          let topView = topView
    else { return }
    helpButton.layer.zPosition = 1.0
    helpButton.addTarget(self, action: "toggleHelp", forControlEvents: .TouchUpInside)
    topView.addSubview(helpButton)
  }
  
  private func setupSearchButton() {
    searchButton = UIButton()
    guard let searchButton = searchButton,
          let topView = topView
    else { return }
    searchButton.layer.zPosition = 1.0
    searchButton.addTarget(self, action: "searchButtonSelected", forControlEvents:  .TouchUpInside)
    topView.addSubview(searchButton)
  }
  
  public func toggleHelp() {
    
    guard let helpButton = helpButton,
          let popoverImage = UIImage(named: "Icon-PopOver"),
          let searchImage = UIImage(named: "help-button")
    else { return }
    
    if helpButton.tag == 1 {
      
      
      helpButton.tag = 0
      helpButton.alpha = 0.0
      
      UIView.animateWithDuration(
        0.2,
        delay: 0.0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 1.0,
        options: .CurveEaseInOut,
        animations: { [weak self] in
          self?.helpButton?.alpha = 1.0
          self?.helpButton?.frame.size = CGSizeMake(48, 48)
          self?.helpButton?.setImage(
            Toucan(image: searchImage).resize(helpButton.frame.size).image,
            forState: .Normal
          )
        },
        completion: nil
      )
      
    } else {
      
      helpButton.tag = 1
      helpButton.alpha = 0.0

      
      UIView.animateWithDuration(
        0.2,
        delay: 0.0,
        usingSpringWithDamping: 0.5,
        initialSpringVelocity: 1.0,
        options: .CurveEaseInOut,
        animations: { [weak self] in
          self?.helpButton?.alpha = 1.0
          self?.helpButton?.frame.size = CGSizeMake(225, 225)
          self?.helpButton?.setImage(
            Toucan(image: popoverImage).resize(helpButton.frame.size).image,
            forState: .Normal
          )
        },
        completion: nil
      )
    }
  }
    
  public func searchButtonSelected() {
        print("Search Button selected!")
  }
    
    public func switchViewToCreateListing() {
         self.presentViewController(CreateListingView(), animated: true, completion: nil)
    }
  
  private func setupScanner() {
    do {
      let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
      let inputDevice = try AVCaptureDeviceInput(device: captureDevice)
      session = AVCaptureSession()
      session?.addInput(inputDevice)
      setupPreviewLayer()
      
      identifiedBorder = DiscoveredBarCodeView(frame: view.bounds)
      guard let identifiedBorder = identifiedBorder else { return }
      identifiedBorder.backgroundColor = UIColor.clearColor()
      identifiedBorder.hidden = true;
      controller.identifiedBorder = identifiedBorder
      
      controller.get_ShouldHideBorder().listen(self) { [weak self] bool in
        self?.identifiedBorder?.hidden = bool
      }
        
      controller.get_ISBN().listen(self) { (isbn) in
            print("The isbn number is \(isbn)")
            // Stop the scanning session
            self.session?.stopRunning()
            // Switch the view
            self.switchViewToCreateListing()
        }
      
      view.addSubview(identifiedBorder)
      
      /* Check for metadata */
      let output = AVCaptureMetadataOutput()
      session?.addOutput(output)
      output.metadataObjectTypes = output.availableMetadataObjectTypes
      output.setMetadataObjectsDelegate(controller, queue: dispatch_get_main_queue())
      session?.startRunning()
      
    } catch let error as NSError {
      print(error)
      return
    }
  }
  
  /* Add the preview layer here */
  public func setupPreviewLayer() {
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    guard let previewLayer = previewLayer else { return }
    previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    previewLayer.bounds = self.view.bounds
    previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
    previewLayer.zPosition = -1
    controller.previewLayer = previewLayer
    controller.view = self.view
    view.layer.addSublayer(previewLayer)
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    guard let helpButton = helpButton,
          let searchButton = searchButton,
          let topView = topView,
          let helpImage = UIImage(named: "help-button"),
          let searchImage = UIImage(named: "search-button")
    else { return }
    
    topView.groupInCorner(group: .Horizontal, views: [helpButton], inCorner: .TopLeft, padding: 10, width: 48, height: 48)
    topView.groupInCorner(group: .Horizontal, views: [searchButton], inCorner: .TopRight, padding: 10, width: 48, height: 48)
    helpButton.setImage(Toucan(image: helpImage).resize(helpButton.frame.size).image, forState: .Normal)
    searchButton.setImage(Toucan(image: searchImage).resize(searchButton.frame.size).image, forState: .Normal)
  }
}

public class DiscoveredBarCodeView: UIView {
  
  var borderLayer : CAShapeLayer?
  var corners : [CGPoint]?
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setMyView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func drawBorder(points : [CGPoint]) {
    guard let point = points.first else { return }
    let path = UIBezierPath()
    path.moveToPoint(point)
    for point in points {
      path.addLineToPoint(point)
    }
    borderLayer?.path = path.CGPath
  }
  
  public func setMyView() {
    borderLayer = CAShapeLayer()
    guard let borderLayer = borderLayer else { return }
    borderLayer.strokeColor = UIColor.whiteColor().CGColor
    borderLayer.lineWidth = 1.0
    borderLayer.fillColor = UIColor.clearColor().CGColor
    self.layer.addSublayer(borderLayer)
  }
}










