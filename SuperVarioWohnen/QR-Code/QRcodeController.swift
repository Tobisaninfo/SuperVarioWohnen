//
//  QRcodeController.swift
//  CookNow
//
//  Created by Tobias on 01.07.17.
//  Copyright © 2017 Tobias. All rights reserved.
//

import UIKit
import AVFoundation

/**
 Protocoll to handle events from ```QRcodeController```.
 */
public protocol QRcodeControllerDelegate {
    /**
     This function is called, than a QRcode is recognized. You have to call the method ```QRcodeController.finishReading(code:)``` to end up the recognition process.
     - Parameter code: QRcode as String
     - Parameter frame: Frame in camera view, there the code is recognized
     */
    func QRcodeDidDetect(code: String, frame: CGRect)
}

/**
 An UIViewController for QRcode Recogition. This ViewController adds a ```AVCaptureVideoPreviewLayer``` on top of the view stack and starts an ```AVCaptureSession```.
 */
public class QRcodeController: UIViewController {
    
    private var captureSession = AVCaptureSession()
    private var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    
    private let supportedCodeTypes = [AVMetadataObject.ObjectType.qr]
    
    // MARK: - Delegate
    
    /**
     Delegate for the QRcodeController.
     */
    public var delegate: QRcodeControllerDelegate?
    
    // MARK: - Properties
    
    /**
     Allow to recognize multiple codes at the same time.
     */
    public var allowMultipleMetadataObjects: Bool = false
    
    
    /**
     Enable the devices torch, if available.
     */
    public var isTorchEnable: Bool = false {
        didSet {
            if let captureDevice = AVCaptureDevice.default(for: .video) {
                if captureDevice.hasFlash && captureDevice.hasTorch {
                    do {
                        try captureDevice.lockForConfiguration()
                        
                        if isTorchEnable {
                            try captureDevice.setTorchModeOn(level: AVCaptureDevice.maxAvailableTorchLevel)
                        } else {
                            captureDevice.torchMode = AVCaptureDevice.TorchMode.off
                        }
                        captureDevice.unlockForConfiguration()
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
    // MARK: - ViewController
    
    /**
     Is called, then the view is loaded.
     */
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            print("Failed to get the camera device")
            return
        }
        
        do {
            try captureDevice.lockForConfiguration()
            captureDevice.focusPointOfInterest = CGPoint(x: 0.5, y: 0.5)
            captureDevice.autoFocusRangeRestriction = .near
            captureDevice.focusMode = .continuousAutoFocus
            captureDevice.unlockForConfiguration()
        } catch {
            print("Fail to set autofocus: \(error)")
        }
        
        do {
            // Get an instance of the AVCaptureDeviceInput class using the previous device object.
            let input = try AVCaptureDeviceInput(device: captureDevice)
            
            // Set the input device on the capture session.
            captureSession.addInput(input)
            
            // Initialize a AVCaptureMetadataOutput object and set it as the output device to the capture session.
            let captureMetadataOutput = AVCaptureMetadataOutput()
            captureSession.addOutput(captureMetadataOutput)
            
            // Set delegate and use the default dispatch queue to execute the call back
            captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureMetadataOutput.metadataObjectTypes = supportedCodeTypes
            //            captureMetadataOutput.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            
        } catch {
            // If any error occurs, simply print it out and don't continue any more.
            print(error)
            return
        }
        
        // Initialize the video preview layer and add it as a sublayer to the viewPreview view's layer.
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        videoPreviewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
        videoPreviewLayer?.frame = view.layer.bounds
        view.layer.addSublayer(videoPreviewLayer!)
        
        // Start video capture.
        captureSession.startRunning()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        // Start video capture.
    }
    
    override public func viewDidDisappear(_ animated: Bool) {
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private var processing: [String] = []
}

extension QRcodeController: AVCaptureMetadataOutputObjectsDelegate {
    
    /**
     Handles the recognized QRcodes.
     */
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Check if the metadataObjects array is not nil and it contains at least one object.
        if metadataObjects.count == 0 {
            return
        }
        
        // Get the metadata object.
        let metadataObj = metadataObjects[0] as! AVMetadataMachineReadableCodeObject
        
        if supportedCodeTypes.contains(metadataObj.type) {
            let barCodeObject = videoPreviewLayer?.transformedMetadataObject(for: metadataObj)
            if let code = metadataObj.stringValue, let bounds = barCodeObject?.bounds, !processing.contains(code) {
                processing.append(code)
                print(code)
                delegate?.QRcodeDidDetect(code: code, frame: bounds)
            }
        }
    }
    
    
    /**
     Mark QRcode as finish.
     - Parameter code: QRcode from the delegate method ```QRcodeControllerDelegate.QRcodeDidDetect(code:frame:)```
     */
    public func finishReding(code: String) {
        if let index = processing.index(of: code) {
            processing.remove(at: index)
        }
    }
}

