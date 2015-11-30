//
//  ScannerController.swift
//  ISBN_Scanner_Prototype
//
//  Created by Andrew Aquino on 11/22/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit
import Signals
import SwiftyTimer

public class ScannerController: NSObject, AVCaptureMetadataOutputObjectsDelegate {
  
  private let model = ScannerModel()
  
  private weak var labelTimer: NSTimer?
  private var timer: NSTimer?
  private var session: AVCaptureSession?
  public weak var view: UIView?
  public var  identifiedBorder: DiscoveredBarCodeView?
  public var previewLayer: AVCaptureVideoPreviewLayer?
  public var shouldResetTimer = true
  
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
      identifiedBorder.alpha = 0.9
      identifiedBorder.hidden = false
      
      resetTimer()
      
      // The scanner is capable of capturing multiple 2-dimensional barcodes in one scan.
      let first = metadataObjects.filter { $0.type == AVMetadataObjectTypeEAN8Code || $0.type == AVMetadataObjectTypeEAN13Code }.first
      guard let isbn = first?.stringValue else { return }
      
      model.isbn = isbn
      print(isbn)
    
    }
  }
  
  public func getISBN() -> String? { return model.isbn }
  public func get_ISBN() -> Signal<String?> { return model._isbn }
  
  public func get_ShouldHideBorder() -> Signal<Bool> { return model._shouldHideBorder }
  
}