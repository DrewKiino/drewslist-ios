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

public class ScannerView: UIViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate {
  
  // MARK: Properties
  
  private weak var labelTimer: NSTimer?
  private var timer: NSTimer?
  public var previewLayer: AVCaptureVideoPreviewLayer?
  public var identifiedBorder: DiscoveredBarCodeView?
  public var shouldResetTimer = true
  public var session: AVCaptureSession?
  
  private var focusImageView: UIImageView?

  private var topView: UIView?
  private var helpButton: UIButton?
  private var searchButton: UIButton?
  private var pulseContainer: UIView?
  private var searchPulse: LFTPulseAnimation?
  private var searchBookView: SearchBookView?
  
  // Search Bar
  private var searchBarContainer: UIView?
  private var searchBarTextField: UITextField?
  private var searchBarImageView: UIImageView?
  
  private let controller = ScannerController()
  private var model: ScannerModel { get { return controller.getModel() } }
  
 // MARK: Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupDataBinding()
    setupScanner()
    setupTopView()
    setupHelpButton()
    setupSearchButton()
    setupFocusImageView()
    setupSearchBar()
    
    FBSDKController.createCustomEventForName("UserScanner")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
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
    
    searchBarContainer?.anchorToEdge(.Top, padding: 0, width: 0, height: 48)
    searchBarTextField?.anchorAndFillEdge(.Left, xPad: 8, yPad: 8, otherSize: screen.width - 48)
    searchBarImageView?.alignAndFill(align: .ToTheRightCentered, relativeTo: searchBarTextField!, padding: 8)
    
    pulseContainer?.anchorInCorner(.BottomLeft, xPad: screen.width / 30, yPad: 0, width: screen.width / 10, height: screen.width / 10)
    searchButton?.anchorInCorner(.BottomLeft, xPad: screen.width / 30, yPad: 0, width: screen.width / 10, height: screen.width / 10)
    searchPulse?.anchorInCenter(width: 60, height: 60)

    helpButton?.setImage(Toucan(image: UIImage(named: "help-button")).resize(helpButton!.frame.size).image, forState: .Normal)
    searchButton?.setImage(Toucan(image: UIImage(named: "search-button")).resize(searchButton!.frame.size).image, forState: .Normal)
    
    focusImageView?.frame = CGRectMake(0, 0, screen.width * 0.75, 100)
    focusImageView?.center = CGPointMake(CGRectGetMidX(previewLayer!.frame), CGRectGetMidY(previewLayer!.frame))

    focusImageView?.image = Toucan(image: UIImage(named: "Icon-CameraFocus")).resize(focusImageView?.frame.size).image
  }

    // MARK: Setup
  
  private func setupSearchBar() {
    
    searchBarContainer = UIView()
    searchBarContainer?.backgroundColor = .soothingBlue()
    view.addSubview(searchBarContainer!)
    
    searchBarTextField = UITextField()
    searchBarTextField?.backgroundColor = .whiteColor()
    searchBarTextField?.layer.cornerRadius = 2.0
    searchBarTextField?.font = .asapRegular(16)
    searchBarTextField?.delegate = self
    searchBarTextField?.autocapitalizationType = .Words
    searchBarTextField?.spellCheckingType = .No
    //    searchBarTextField?.autocorrectionType = .No
    searchBarTextField?.clearButtonMode = .Always
    searchBarContainer?.addSubview(searchBarTextField!)
    
    searchBarImageView = UIImageView()
    searchBarContainer?.addSubview(searchBarImageView!)
    
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
    
//    searchBookView
    
  }
  
  private func setupTopView() {
    topView = UIView()
    view.addSubview(topView!)
    topView?.anchorAndFillEdge(.Top, xPad: 0, yPad: 0, otherSize: screen.height / 12)
  }
  
  private func setupHelpButton() {
    helpButton = UIButton()
    helpButton?.layer.zPosition = 2.0
    helpButton?.addTarget(self, action: "toggleHelp", forControlEvents: .TouchUpInside)
    topView?.addSubview(helpButton!)
  }
  
  private func setupSearchButton() {
    searchButton = UIButton()
    pulseContainer = UIView()
    searchBookView = SearchBookView()
    
    searchPulse = LFTPulseAnimation(repeatCount: Float.infinity, radius: 30, position: pulseContainer!.center)
    searchPulse?.animationDuration = NSTimeInterval(2.0)
    
    pulseContainer?.layer.insertSublayer(searchPulse!, below: pulseContainer!.layer)
    searchPulse?.backgroundColor = UIColor.juicyOrange().CGColor
    
    
    searchButton?.layer.zPosition = 2.0
    searchButton?.addTarget(self, action: "searchButtonSelected", forControlEvents:  .TouchUpInside)
    topView?.addSubview(pulseContainer!)
    topView?.addSubview(searchButton!)
    
  }
  
  private func setupFocusImageView() {
    focusImageView = UIImageView()
    view.addSubview(focusImageView!)
  }
  
  public func searchButtonSelected() {
    if let searchBookView = self.searchBookView {
      presentViewController(searchBookView, animated: true, completion: nil)
      
      SearchBookModel.sharedInstance()._book.removeListener(self)
      SearchBookModel.sharedInstance()._book.listen(self) { [weak self] book in
        self?.presentCreateListingView(book)
      }
      FBSDKController.createCustomEventForName("Scanner_SearchButtonSelected")
    }
  }
    
  public func presentCreateListingView(book: Book?) {
    
    previewLayer?.hidden = true
    identifiedBorder?.hidden = true
    session?.stopRunning()
    
    presentViewController(CreateListingView().setBook(book), animated: true, completion: nil)
  }
  
  private func setupScanner() {
    
    session = AVCaptureSession()
    session?.addInput(try? AVCaptureDeviceInput(device: AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)))

    setupPreviewLayer()

    identifiedBorder = DiscoveredBarCodeView(frame: view.bounds)
    identifiedBorder?.backgroundColor = UIColor.clearColor()
    identifiedBorder?.hidden = true
    
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
        let view = view
//        let identifiedCorners = self.translatePoints(transformed.corners, fromView: view, toView: identifiedBorder)
        else { return }
      
      UIView.animate { [weak self, weak transformed] in
        guard let transformed = transformed else { return }
        self?.focusImageView?.center = CGPointMake(CGRectGetMidX(transformed.bounds), CGRectGetMidY(transformed.bounds))
      }
      
      // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
      var isbn: String? = (metadataObjects.filter { ($0.type == AVMetadataObjectTypeEAN8Code) || ($0.type == AVMetadataObjectTypeEAN13Code) }).first?.stringValue
      
      // pass the acquired isbn to the controller
      controller.getBookFromServer(isbn)
      
      // deinit the isbn string
      isbn = nil
    }
  }
  
  public override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  public func hideHeaderView() {
    topView?.hidden = true
  }
  
  public func showTopView() {
    topView?.hidden = false
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










