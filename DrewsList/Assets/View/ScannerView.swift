//
//  ViewController.swift
//  ISBN_Scanner_Prototype
//
//  Created by Andrew Aquino on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import AVFoundation
import Neon
import Async

public class ScannerView: DLNavigationController, AVCaptureMetadataOutputObjectsDelegate {
    
  // MARK: Properties
  
  private weak var labelTimer: NSTimer?
  private var timer: NSTimer?
  public var previewLayer: AVCaptureVideoPreviewLayer?
  public var identifiedBorder: DiscoveredBarCodeView?
  public var shouldResetTimer = true
  public var session: AVCaptureSession?

  private var topView: UIView?
  private var helpButton: UIButton?
  private var searchButton: UIButton?
  
  private let controller = ScannerController()
  private var model: ScannerModel { get { return controller.getModel() } }
  
 // MARK: Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupSelf()
    setupDataBinding()
    setupScanner()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    session?.startRunning()
  }
  
  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    session?.stopRunning()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
  }
  
    // MARK: Setup
  
  private func setupSelf() {
    setRootViewTitle("Scanner")
  }
  
  private func setupDataBinding() {
    
    controller.get_ShouldHideBorder().removeAllListeners()
    controller.get_ShouldHideBorder().listen(self) { [weak self] bool in
      self?.identifiedBorder?.hidden = bool
    }
    
    controller.get_Book().removeAllListeners()
    controller.get_Book().listen(self) { [weak self] book in
      self?.presentCreateListingView(book)
    }
  }
  
  private func setupTopView() {
    topView = UIView()
    view.addSubview(topView!)
  }
  
  private func setupHelpButton() {
    helpButton = UIButton()
    helpButton?.layer.zPosition = 1.0
    helpButton?.addTarget(self, action: "toggleHelp", forControlEvents: .TouchUpInside)
    topView?.addSubview(helpButton!)
  }
  
  private func setupSearchButton() {
    searchButton = UIButton()
    searchButton?.layer.zPosition = 1.0
    searchButton?.addTarget(self, action: "searchButtonSelected", forControlEvents:  .TouchUpInside)
    topView?.addSubview(searchButton!)
  }
  
  public func toggleHelp() {
    
    Async.background { [weak self] in
      
      if self?.helpButton?.tag == 1 {
        
        self?.helpButton?.tag = 0
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "help-button")).resize(self?.helpButton?.frame.size)
        
        Async.main { [weak self] in
          
          self?.helpButton?.alpha = 0.0
          
          UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .CurveEaseInOut,
            animations: { [weak self] in
              self?.helpButton?.alpha = 1.0
              self?.helpButton?.frame.size = CGSizeMake(48, 48)
              self?.helpButton?.setImage(toucan?.image, forState: .Normal)
            },
            completion: nil
          )
          
          toucan = nil
        }
      
      } else {
        
        self?.helpButton?.tag = 1
        
        var toucan: Toucan? = Toucan(image: UIImage(named: "Icon-PopOver")).resize(self?.helpButton?.frame.size)

        Async.main { [weak self] in
          
          self?.helpButton?.alpha = 0.0
          
          UIView.animateWithDuration(
            0.2,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: 1.0,
            options: .CurveEaseInOut,
            animations: { [weak self] in
              self?.helpButton?.alpha = 1.0
              self?.helpButton?.frame.size = CGSizeMake(225, 225)
              self?.helpButton?.setImage(toucan?.image, forState: .Normal)
            },
            completion: nil
          )
          
          toucan = nil
        }
      }
    }
  }
    
  public func searchButtonSelected() {
    print("Search Button selected!")
  }
    
  public func presentCreateListingView(book: Book?) {
    
    previewLayer?.hidden = true
    identifiedBorder?.hidden = true
    session?.stopRunning()
    
//    pushViewController(CreateListingView().setBook(book), animated: true)
    presentViewController(CreateListingView().setBook(book), animated: true, completion: nil)
  }
  
  private func setupScanner() {
    
    var captureDevice: AVCaptureDevice? = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    var inputDevice: AVCaptureDeviceInput? = try? AVCaptureDeviceInput(device: captureDevice)
    captureDevice = nil
    
    session = AVCaptureSession()
    session?.addInput(inputDevice)
    inputDevice = nil
    
    setupPreviewLayer()
    
    identifiedBorder = DiscoveredBarCodeView(frame: view.bounds)
    identifiedBorder?.backgroundColor = UIColor.clearColor()
    identifiedBorder?.hidden = true;
    
    view.addSubview(identifiedBorder!)
    
    /* Check for metadata */
    var output: AVCaptureMetadataOutput? = AVCaptureMetadataOutput()
    session?.addOutput(output)
    output?.metadataObjectTypes = output?.availableMetadataObjectTypes
    output?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
    output = nil
    
    session?.startRunning()
  }
  
  /* Add the preview layer here */
  public func setupPreviewLayer() {
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    previewLayer?.bounds = self.view.bounds
    previewLayer?.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
    previewLayer?.zPosition = -1
    
    guard let previewLayer = previewLayer else { return }
    view.layer.addSublayer(previewLayer)
  }
  
  public func resetTimer() {
    timer?.invalidate()
    timer = nil
    timer = NSTimer.after(2.0) { [weak self] in
      self?.model.shouldHideBorder = true
    }
  }
  
  public func translatePoints(points : [AnyObject], fromView : UIView, toView: UIView) -> [CGPoint]? {
    var translatedPoints : [CGPoint] = []
    for point in points {
      
      guard let dict = point as? NSDictionary,
        let x = dict.objectForKey("X") as? NSNumber,
        let y = dict.objectForKey("Y") as? NSNumber
        else { return nil }
      
      let curr = CGPointMake(CGFloat(x.floatValue), CGFloat(y.floatValue))
      let currFinal = fromView.convertPoint(curr, toView: toView)
      translatedPoints.append(currFinal)
    }
    
    return translatedPoints
  }
  
  public func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
    for data in metadataObjects {
      
      guard let metaData = data as? AVMetadataObject,
        let transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject,
        let identifiedBorder = identifiedBorder,
        let view = view,
        let identifiedCorners = self.translatePoints(transformed.corners, fromView: view, toView: identifiedBorder)
        else { return }
      
      identifiedBorder.drawBorder(identifiedCorners)
      identifiedBorder.frame = transformed.bounds
      identifiedBorder.alpha = 0.5
      identifiedBorder.hidden = false
      
      resetTimer()
      
      // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
      var isbn: String? = metadataObjects.filter { $0.type == AVMetadataObjectTypeEAN8Code || $0.type == AVMetadataObjectTypeEAN13Code }.first?.stringValue
      
      // pass the acquired isbn to the controller
      controller.getBookFromServer(isbn)
      
      // deinit the isbn string
      isbn = nil
    }
  }
}

public class DiscoveredBarCodeView: UIView {
  
  var borderLayer : CAShapeLayer?
  
  public override init(frame: CGRect) {
    super.init(frame: frame)
    setMyView()
  }
  
  public required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  public func drawBorder(points : [CGPoint]) {
    guard let point = points.first else { return }
    var path: UIBezierPath? = UIBezierPath()
    path?.moveToPoint(point)
    for point in points { path?.addLineToPoint(point) }
    borderLayer?.path = path?.CGPath
    path = nil
  }
  
  public func setMyView() {
    borderLayer = CAShapeLayer()
    borderLayer?.strokeColor = UIColor.redColor().CGColor
    borderLayer?.lineWidth = 1.0
    borderLayer?.fillColor = UIColor.clearColor().CGColor
    layer.addSublayer(borderLayer!)
  }
}










