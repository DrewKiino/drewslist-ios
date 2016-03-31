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

public class ScannerView: DLViewController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  
  // MARK: Properties
  
  private weak var labelTimer: NSTimer?
  private var timer: NSTimer?
  public var previewLayer: AVCaptureVideoPreviewLayer?
  public var identifiedBorder: DiscoveredBarCodeView?
  public var shouldResetTimer = true
  public var session: AVCaptureSession?
  
  private var focusImageView: UIImageView?

  // Search Bar
  private var searchBarContainer: UIView?
  private var searchBarTextField: UITextField?
  
  //  School List
  private var tableView: DLTableView?
  private var originalTableViewFrame: CGRect?
  private var lastKeyboardFrame: CGRect?
  
  // MVC
  private let controller = ScannerController()
  private var model: ScannerModel { get { return controller.model } }
  
 // MARK: Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    setupDataBinding()
    setupScanner()
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
    
    searchBarContainer?.anchorToEdge(.Top, padding: 20, width: screen.width, height: 48)
    searchBarTextField?.anchorAndFillEdge(.Left, xPad: 8, yPad: 8, otherSize: screen.width - 16)
    
    focusImageView?.frame = CGRectMake(0, 0, screen.width * 0.75, 100)
    focusImageView?.center = CGPointMake(CGRectGetMidX(previewLayer!.frame), CGRectGetMidY(previewLayer!.frame))

    focusImageView?.image = Toucan(image: UIImage(named: "Icon-CameraFocus")).resize(focusImageView?.frame.size).image
  }

    // MARK: Setup
  
  public override func setupSelf() {
    super.setupSelf()

    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTapped"))
  }
  
  private func setupSearchBar() {
    
    searchBarContainer = UIView()
    searchBarContainer?.backgroundColor = .clearColor()
    view.addSubview(searchBarContainer!)
    
    searchBarTextField = UITextField()
    searchBarTextField?.backgroundColor = .whiteColor()
    searchBarTextField?.layer.cornerRadius = 2.0
    searchBarTextField?.font = .asapRegular(16)
    searchBarTextField?.delegate = self
    searchBarTextField?.autocapitalizationType = .Words
    searchBarTextField?.spellCheckingType = .No
    searchBarTextField?.placeholder = "Search by Title, ISBN, Author, etc."
//    searchBarTextField?.autocorrectionType = .No
    searchBarTextField?.clearButtonMode = .Always
    searchBarContainer?.addSubview(searchBarTextField!)
    
  }
  
  private func setupDataBinding() {
    
    controller.model._shouldHideBorder.removeAllListeners()
    controller.model._shouldHideBorder.listen(self) { [weak self] bool in
      self?.identifiedBorder?.hidden = bool
    }
    
    controller.model._book.removeAllListeners()
    controller.model._book.listen(self) { [weak self] book in
      self?.presentCreateListingView(book)
    }
    
//    searchBookView
    
    model._books.removeAllListeners()
    model._books.listen(self) { [weak self] books in
      self?.tableView?.reloadData()
    }
    
    model._book.removeAllListeners()
    model._book.listen(self) { [weak self] book in
      self?.cancel()
    }
    
    model._shouldRefrainFromCallingServer.removeAllListeners()
    model._shouldRefrainFromCallingServer.listen(self) { [weak self] bool in
    }
  }
  
  private func setupFocusImageView() {
    focusImageView = UIImageView()
    view.addSubview(focusImageView!)
  }
  
  public func searchButtonSelected() {
    FBSDKController.createCustomEventForName("Scanner_SearchButtonSelected")
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
    
    view.layer.addSublayer(previewLayer!)
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
  
  public func viewTapped() {
    searchBarTextField?.resignFirstResponder()
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.showsVerticalScrollIndicator = true
    view.addSubview(tableView!)
  }
  
  // MARK: Functions
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    searchBarTextField?.resignFirstResponder()
    return true
  }
  
  public func cancel() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  public func search() {
    controller.searchBook()
  }
  
  // MARK: TextField Delegates
  public func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    if let text = textField.text {
      // this means the user inputted a backspace
      if string.characters.count == 0 {
        model.searchString = NSString(string: text).substringWithRange(NSRange(location: 0, length: text.characters.count - 1))
        // else, user has inputted some new strings
      } else { model.searchString = text + string }
    }
    return true
  }
  
  public func textFieldShouldReturn(textField: UITextField) -> Bool {
    controller.searchBook()
    resignFirstResponder()
    return false
  }
  
  // MARK: TableView Delegates
  
  public func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
    return 166
  }
  
  public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return model.books.count
  }
  
  public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    
    if let cell = tableView.dequeueReusableCellWithIdentifier("BookViewCell", forIndexPath: indexPath) as? BookViewCell {
      cell.setBook(model.books[indexPath.row])
      cell._cellPressed.removeAllListeners()
      cell._cellPressed.listen(self) { [weak self] bool in
        if bool == true {
          self?.model.book = self?.model.books[indexPath.row]
          
          self?.presentViewController(CreateListingView().setBook(self?.model.book), animated: true, completion: nil)
          //presentViewController(CreateListingView().setBook(self.model.book), animated: true, completion: nil)
        }
      }
      
      return cell
    }
    return DLTableViewCell()
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    model.book = model.books[indexPath.row]
  }
  
  public func scrollViewDidScroll(scrollView: UIScrollView) {
    if let frame = lastKeyboardFrame where screen.height - frame.height < scrollView.panGestureRecognizer.locationInView(self.view).y {
      resignFirstResponder()
    }
  }
  
  // MARK: Keyboard observers
  func keyboardWillShow(notification: NSNotification) {
    if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue(), let originalFrame = originalTableViewFrame {
      lastKeyboardFrame = keyboardFrame
      if let frame = tableView?.frame { tableView?.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.width, originalFrame.height - keyboardFrame.height) }
    }
  }
  
  func keyboardWillHide(notification: NSNotification) {
    if let frame = originalTableViewFrame { tableView?.frame = frame }
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










