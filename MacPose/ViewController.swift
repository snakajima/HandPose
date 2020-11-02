//
//  ViewController.swift
//  MacPose
//
//  Created by SATOSHI NAKAJIMA on 11/2/20.
//  Copyright © 2020 Apple. All rights reserved.
//

import AppKit
import AVFoundation

enum AppError: Error {
    case captureSessionSetup(reason: String)
    case visionError(error: Error)
    case otherError(error: Error)
    
    func dumpError() {
        switch self {
        case .captureSessionSetup(let reason):
            print("### AVSession Setup Error", reason)
        default:
            print("### ERROR", localizedDescription)
        }
    }
}

class ViewController: NSViewController {
    private let videoDataOutputQueue = DispatchQueue(label: "CameraFeedDataOutput", qos: .userInteractive)
    var captureSession: AVCaptureSession?
    var gestureEnabled = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        do {
            try setupAVSession()
        } catch {
            if let appError = error as? AppError {
                appError.dumpError()
            }
        }
        let previewLayer = AVCaptureVideoPreviewLayer()
        view.layer = previewLayer
        previewLayer.session = captureSession
        captureSession?.startRunning()
    }
    
    func setupAVSession() throws {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified) else {
            throw AppError.captureSessionSetup(reason: "Could not find a front facing camera.")
        }
        guard let deviceInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("#ERROR: failed to create Input Device")
            return
        }
        let session = AVCaptureSession()
        session.beginConfiguration()
        session.sessionPreset = .high
        guard session.canAddInput(deviceInput) else {
            print("#ERROR: can not add Input")
            return
        }
        session.addInput(deviceInput)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if session.canAddOutput(dataOutput) {
            session.addOutput(dataOutput)
            // Add a video data output.
            dataOutput.alwaysDiscardsLateVideoFrames = true
            dataOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
            dataOutput.setSampleBufferDelegate(self, queue: videoDataOutputQueue)
        } else {
            throw AppError.captureSessionSetup(reason: "Could not add video data output to the session")
        }
        
        session.commitConfiguration()
        self.captureSession = session
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    @IBAction func toggleGesture(_ sender:Any) {
        gestureEnabled = !gestureEnabled
        print("toggleGesture", gestureEnabled)
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    public func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        // no operation
    }
}
