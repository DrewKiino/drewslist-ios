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

public class ScannerView: DLNavigationController, AVCaptureMetadataOutputObjectsDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource {
  
  // MARK: Properties
  
  private weak var labelTimer: NSTimer?
  private var timer: NSTimer?
  public var previewLayer: AVCaptureVideoPreviewLayer?
  public var identifiedBorder: DiscoveredBarCodeView?
  public var shouldResetTimer = true
  public var session: AVCaptureSession?
  
  private var focusImageView: UIImageView?
  private var keyboardActive: Bool = false

  // Search Bar
  private var searchBarContainer: UIView?
  private var searchBarTextField: UITextField?
  
  //  School List
  private var tableView: DLTableView?
  private var lastKeyboardFrame: CGRect?
  
  // MVC
  private let controller = ScannerController()
  private var model: ScannerModel { get { return controller.model } }
  
 // MARK: Lifecycle
  public override func viewDidLoad() {
    super.viewDidLoad()
    
    setupSelf()
    setupDataBinding()
    
    if UIDevice.currentDevice().name.hasSuffix("Simulator") { // Code executing on Simulator
    } else{ // Code executing on Device
      setupScanner()
      setupFocusImageView()
    }
    
    setupSearchBar()
    setupTableView()
    
    rootView?.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "viewTapped"))
    
    FBSDKController.createCustomEventForName("UserScanner")
  }
  
  public override func viewDidAppear(animated: Bool) {
    super.viewDidAppear(animated)
    resetUI()
  }
  
  public override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardDidShow:", name: UIKeyboardDidShowNotification, object: nil)
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    
    session?.startRunning()
  }
  
  public override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  public override func viewWillDisappear(animated: Bool) {
    super.viewWillDisappear(animated)
    
    // remove text on search bar if user leaves view
    searchBarTextField?.text = nil
    
    session?.stopRunning()
  }
  
  public override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    
    searchBarContainer?.anchorAndFillEdge(.Top, xPad: 8, yPad: 8, otherSize: 36)
    searchBarTextField?.anchorAndFillEdge(.Left, xPad: 8, yPad: 8, otherSize: screen.width - 32)
    
    if let previewLayer = previewLayer {
      focusImageView?.frame = CGRectMake(0, 0, screen.width * 0.75, 100)
      focusImageView?.center = CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen) - 64)

      focusImageView?.image = Toucan(image: UIImage(named: "Icon-CameraFocus")).resize(focusImageView?.frame.size).image?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
      focusImageView?.tintColor = .juicyOrange()
    }
  }

    // MARK: Setup
  
  private func setupSelf() {
    title = "Scan"
    rootView?.view.backgroundColor = .whiteColor()
  }
  
  private func setupSearchBar() {
    
    searchBarContainer = UIView()
    searchBarContainer?.backgroundColor = .whiteColor()
    searchBarContainer?.layer.cornerRadius = 5.0
    searchBarContainer?.userInteractionEnabled = true
    searchBarContainer?.multipleTouchEnabled = false

    rootView?.view.addSubview(searchBarContainer!)
    
    searchBarTextField = UITextField()
    searchBarTextField?.backgroundColor = .whiteColor()
    searchBarTextField?.font = .asapRegular(16)
    searchBarTextField?.delegate = self
    searchBarTextField?.autocapitalizationType = .Words
    searchBarTextField?.spellCheckingType = .No
    searchBarTextField?.placeholder = "Search by Title, ISBN, Author, etc."
//    searchBarTextField?.autocorrectionType = .No
    searchBarTextField?.clearButtonMode = .Always
    searchBarContainer?.addSubview(searchBarTextField!)
  }
  
  public override func setupDataBinding() {
    super.setupDataBinding()
    
    model.showRequestActivity.removeAllListeners()
    model.showRequestActivity.listen(self) { [weak self] bool in
      if bool {
        self?.rootView?.showActivity(.RightBarButton)
      } else {
        self?.rootView?.hideActivity(.RightBarButton)
      }
    }
    
    model._shouldHideBorder.removeAllListeners()
    model._shouldHideBorder.listen(self) { [weak self] bool in
      self?.identifiedBorder?.hidden = bool
    }
    
//    searchBookView
    
    model._books.removeAllListeners()
    model._books.listen(self) { [weak self] books in
      
      self?.tableView?.anchorAndFillEdge(.Top, xPad: 8, yPad: 48, otherSize: ((self?.model.books.count == 1) ? 166 : (screen.height - (self?.lastKeyboardFrame?.height ?? 0) - 116)))
      self?.tableView?.reloadData()
      
      if books.count == 0 {
        
        self?.tableView?.hidden = true
        self?.showAlert("Sorry!", message: "We did not find any matches!")
        
      } else if self?.keyboardActive == true || self?.lastKeyboardFrame == nil {
        
        self?.tableView?.hidden = false
        
        UIView.animateWithDuration(0.2, animations: { [weak self] in
          self?.tableView?.alpha = 1.0
        }) { [weak self] bool in
          self?.tableView?.setContentOffset(CGPointZero, animated:true)
        }
      }
    }
    
    model._book.removeAllListeners()
    model._book.listen(self) { [weak self] book in
      self?.presentCreateListingView(book)
    }
  }
  
  private func setupFocusImageView() {
    focusImageView = UIImageView()
    rootView?.view.addSubview(focusImageView!)
  }
  
  public func searchButtonSelected() {
    FBSDKController.createCustomEventForName("Scanner_SearchButtonSelected")
  }
    
  public func presentCreateListingView(book: Book?) {
    
    var alertController: UIAlertController! = UIAlertController(title: nil, message: nil, preferredStyle: .ActionSheet)
    alertController.addAction(UIAlertAction(title: "I'm Buying", style: .Default) { [weak self, weak alertController] action in
      self?.hideUI()
      self?.presentViewController(CreateListingView().setBook(book).setListType("buying"), animated: true, completion: nil)
    })
    alertController.addAction(UIAlertAction(title: "I'm Selling", style: .Default) { [weak self, weak alertController] action in
      self?.hideUI()
      self?.presentViewController(CreateListingView().setBook(book).setListType("selling"), animated: true, completion: nil)
    })
    alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel) { [weak self] action in
      self?.resetUI()
    })
    presentViewController(alertController, animated: true, completion: nil)
    alertController = nil
  }
  
  public func hideUI() {
    focusImageView?.tintColor = .whiteColor()
    focusImageView?.hidden = true
    previewLayer?.hidden = true
    identifiedBorder?.hidden = true
    searchBarContainer?.hidden = true
    searchBarTextField?.text = nil
    session?.stopRunning()
  }
  
  public func resetUI() {
    searchBarTextField?.text = nil
    focusImageView?.tintColor = .juicyOrange()
    focusImageView?.hidden = false
    searchBarContainer?.hidden = false
    focusImageView?.center = CGPointMake(CGRectGetMidX(screen), CGRectGetMidY(screen) - 64)
  }
  
  private func setupScanner() {
    
    if let view = rootView?.view {
      
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
      output?.metadataObjectTypes = [AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeEAN13Code]
      output?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
      output = nil
      
      session?.startRunning()
    }
  }
  
  /* Add the preview layer here */
  public func setupPreviewLayer() {
    previewLayer = AVCaptureVideoPreviewLayer(session: session)
    previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
    previewLayer?.bounds = self.view.bounds
    previewLayer?.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
    previewLayer?.zPosition = -1
    
    rootView?.view.layer.addSublayer(previewLayer!)
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
      
      if  let metaData = data as? AVMetadataObject,
          let transformed = previewLayer?.transformedMetadataObjectForMetadataObject(metaData) as? AVMetadataMachineReadableCodeObject
//          let identifiedBorder = identifiedBorder
      {
        
        UIView.animate { [weak self, weak transformed] in
          guard let transformed = transformed else { return }
          self?.focusImageView?.center = CGPointMake(CGRectGetMidX(transformed.bounds), CGRectGetMidY(transformed.bounds))
        }
        
        if let isbn: String? = metadataObjects.first?.stringValue {
          controller.getBookFromServer(isbn)
        }
      }
    }
  }
  
  public override func prefersStatusBarHidden() -> Bool {
    return true
  }
  
  public func viewTapped() {
    resignFirstResponder()
  }
  
  private func setupTableView() {
    tableView = DLTableView()
    tableView?.delegate = self
    tableView?.dataSource = self
    tableView?.showsVerticalScrollIndicator = true
    tableView?.backgroundColor = .whiteColor()
    tableView?.layer.cornerRadius = 5.0
    tableView?.alpha = 0.0
    rootView?.view.addSubview(tableView!)
  }
  
  // MARK: Functions
  
  public override func resignFirstResponder() -> Bool {
    super.resignFirstResponder()
    
    searchBarTextField?.resignFirstResponder()
    searchBarTextField?.text = nil
    model.lastSearchString = nil
    
    return true
  }
  
  public func cancel() {
    presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
  }
  
  public func search() {
    controller.searchBook()
  }
  
  // MARK: TextField Delegates
  
  public func textFieldDidBeginEditing(textField: UITextField) {
    if textField.text?.characters.count > 0 {
      UIView.animate(duration: 0.2) { [weak self] in
        self?.tableView?.alpha = 1.0
      }
    }
  }
  
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
      cell.bookView?.canShowBookProfile = false
      cell.setBook(model.books[indexPath.row])
      cell._cellPressed.removeAllListeners()
      cell._cellPressed.listen(self) { [weak self] bool in
        if bool == true {
          self?.model.book = self?.model.books[indexPath.row]
        }
      }
      
      return cell
    }
    return DLTableViewCell()
  }
  
  public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    model.book = model.books[indexPath.row]
  }
  
  // MARK: Keyboard observers
  func keyboardWillShow(notification: NSNotification) {
    
    focusImageView?.hidden = true
    
    if let keyboardFrame = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.CGRectValue() {
      lastKeyboardFrame = keyboardFrame
    }
  }
  
  func keyboardDidShow(notification: NSNotification) {
    keyboardActive = true
  }
  
  func keyboardWillHide(notification: NSNotification) {
    
    keyboardActive = false
    
    focusImageView?.hidden = false
    
    UIView.animate(duration: 0.2) { [weak self] in
      self?.tableView?.alpha = 0.0
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










