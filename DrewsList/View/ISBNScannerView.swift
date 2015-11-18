//
//  ISBNScannerView.swift
//  DrewsList
//
//  Created by Steven Yang on 11/10/15.
//  Copyright © 2015 Totem. All rights reserved.
//

import UIKit
import AVFoundation
import Neon

class ISBNScannerView: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    
    // MARK: Properties
    var previewView: UIView!
    
    var session: AVCaptureSession?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var metaDataOutput: AVCaptureMetadataOutput?
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.clipsToBounds = false
        self.view.contentMode = .ScaleToFill
        previewView = UIView()
        previewView.clipsToBounds = false
    }
    
    override func viewWillAppear(animated: Bool) {
        
        // Create the UI
        startCameraSession()
        createScanButton()
        createHelpButton()
        createCancelButton()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    // MARK: Camera
    func startCameraSession() {
        
        session = AVCaptureSession()
        session!.sessionPreset = AVCaptureSessionPresetPhoto
        
        let backCamera = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        // Check for errors before starting
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: backCamera)
        } catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if error == nil && session!.canAddInput(input) {
            session!.addInput(input)
            
            metaDataOutput = AVCaptureMetadataOutput()
            metaDataOutput!.metadataObjectTypes = metaDataOutput!.availableMetadataObjectTypes
            if session!.canAddOutput(metaDataOutput) {
                
                addPreviewLayer()
                metaDataOutput?.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
                session!.addOutput(metaDataOutput)
                session!.startRunning()
            }
        }
    }
    
    func addPreviewLayer() {
        print("Creating the preview layer")
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewLayer!.connection?.videoOrientation = AVCaptureVideoOrientation.Portrait
        previewLayer!.frame = self.view.layer.bounds
        previewView.layer.addSublayer(previewLayer!)
        previewView.layer.zPosition = -2
        
        self.view.addSubview(previewView)
    }
    
    // MARK: Scan Button
    func createScanButton() {
        print("Creating the scan button")
        let button = UIButton(type: .Custom)
        button.frame = CGRectMake(self.view.frame.width / 2.5, self.view.frame.height / 1.25, 100, 100)
        button.addTarget(self, action: "scanButtonPressed", forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor(red: 255, green: 255, blue: 255, alpha: 0.4)
        
        // border
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        button.layer.borderWidth = 5
        button.layer.borderColor = UIColor.whiteColor().CGColor
        
        button.layer.zPosition = 2
        
        self.view.addSubview(button)
    }
    
    func scanButtonPressed() {
        print("The scan button is being pressed!")
    }
    
    // MARK: Help Button
    func createHelpButton() {
        print("Creating the help button")
        let button = UIButton(type: .Custom)
        let label = UILabel()
        
        // Button
        button.frame = CGRectMake(self.view.frame.width * 0.05, self.view.frame.height * 0.05, 60, 60)
        button.addTarget(self, action: "helpButtonPressed", forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.orangeColor()
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        
        // Label
        label.text = "?"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = button.frame
        label.font = UIFont.boldSystemFontOfSize(36.0)
        
        button.layer.zPosition = 2
        label.layer.zPosition = 3
        
        self.view.addSubview(button)
        self.view.addSubview(label)
        
    }
    
    func helpButtonPressed() {
        print("The help button is being pressed!")
    }
    
    // MARK: Cancel Button
    func createCancelButton() {
        print("Creating the cancel button")
        let button = UIButton(type: .Custom)
        let label = UILabel()
        
        // Button
        button.frame = CGRectMake(self.view.frame.width * 0.85, self.view.frame.height * 0.05, 60, 60)
        button.addTarget(self, action: "cancelButtonPressed", forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 0.5 * button.bounds.size.width
        
        // Label
        label.text = "X"
        label.textColor = UIColor.whiteColor()
        label.textAlignment = .Center
        label.frame = button.frame
        label.font = UIFont.boldSystemFontOfSize(32.0)
        
        button.layer.zPosition = 2
        label.layer.zPosition = 3
        
        self.view.addSubview(button)
        self.view.addSubview(label)
        
    }
    
    func cancelButtonPressed() {
        print("The cancel button is being pressed!")
    }
    
    // MARK: Delegates
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        print("Barcode has been detected!")
    }
    
}