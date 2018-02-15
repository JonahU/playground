//
//  RightViewController.swift
//  Playground
//
//  Created by Jonah U on 8/14/17.
//  Copyright © 2017 Jonah U. All rights reserved.
//

import UIKit
import AVFoundation

class RightViewController: UIViewController {
    
    @IBOutlet weak var previewView: UIView!
    
    var captureSession : AVCaptureSession?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    let emitterLayer = CAEmitterLayer()
    let emitterCell = CAEmitterCell()
    
    var capturePhotoOutput : AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let captureDevice = AVCaptureDevice.default(AVCaptureDevice.DeviceType.builtInWideAngleCamera, for: AVMediaType.video, position: .front) //front facing camera
        
        do{
            let input = try AVCaptureDeviceInput(device: captureDevice!)
            captureSession = AVCaptureSession()
            captureSession?.addInput(input)
            
            capturePhotoOutput = AVCapturePhotoOutput()
            capturePhotoOutput?.isHighResolutionCaptureEnabled = true
            
            captureSession?.addOutput(capturePhotoOutput!)
            
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            previewLayer?.frame = view.layer.bounds
            previewView.layer.addSublayer(previewLayer!)
            
            
            captureSession?.startRunning()
            
            setUpEmitterLayer()
            setUpEmitterCell()
            emitterLayer.emitterCells = [emitterCell]
            previewView.layer.addSublayer(emitterLayer)
        }catch{
            print(error)
            return
        }
    }
    
    func flashScreen(){
        let shutterView = UIView(frame: previewView.frame)
        shutterView.backgroundColor = UIColor.black
        view.addSubview(shutterView)
        UIView.animate(withDuration: 0.3, animations: {
            shutterView.alpha = 0
        }, completion: { (_) in
            shutterView.removeFromSuperview()
        })
    }
    
    @IBAction func viewTapped(_ sender: UITapGestureRecognizer) {
        capturePhoto()
    }
    
    func capturePhoto(){
        //make sure capturePhotoOutput is valid
        guard let capturePhotoOutput = self.capturePhotoOutput else { return }
        
        //get an instance of AVCapturePhotoSettings class
        let photoSettings = AVCapturePhotoSettings()
        
        //set photo settings for our need
        photoSettings.isAutoStillImageStabilizationEnabled = true
        photoSettings.isHighResolutionPhotoEnabled = true
        photoSettings.flashMode = .off
        
        //call capturePhoto method by passing our photo settings &
        //a delegate implementing AVCapturePhotoCaptureDelegate
        capturePhotoOutput.capturePhoto(with: photoSettings, delegate: self)
    }
    
    //MARK: -CAEmitterLayer functions
    
    func setUpEmitterLayer(){
        emitterLayer.frame = view.bounds
        emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
        emitterLayer.renderMode = kCAEmitterLayerBackToFront
        emitterLayer.drawsAsynchronously = true //improves performance when layer's contents need to be redrawn
        setEmitterPosition()
    }
    
    func setUpEmitterCell(){
        emitterCell.contents = UIImage(named: "flower")?.cgImage
        
        emitterCell.velocity = 50.0
        emitterCell.velocityRange = 500.0
        
        emitterCell.color = UIColor.white.cgColor
        emitterCell.redRange = 1.0
        emitterCell.greenRange = 1.0
        emitterCell.blueRange = 1.0
        emitterCell.alphaRange = 0.0
        emitterCell.redSpeed = 0.0
        emitterCell.greenSpeed = 0.0
        emitterCell.blueSpeed = 0.0
        emitterCell.alphaSpeed = -0.5
        
        let zeroDegreesInRadians = degreesToRadians(0.0)
        emitterCell.spin = degreesToRadians(580.0)
        emitterCell.spinRange = zeroDegreesInRadians
        emitterCell.emissionRange = degreesToRadians(360)
        
        emitterCell.lifetime = 5.0
        emitterCell.birthRate = 500.0
        emitterCell.xAcceleration = -800.0
        emitterCell.yAcceleration = 300.0
    }
    
    func setEmitterPosition(){
        emitterLayer.emitterPosition = CGPoint(x: view.bounds.maxX, y: view.bounds.minY)
    }
    
    func degreesToRadians(_ degrees: Double) -> CGFloat {
        return CGFloat(degrees * Double.pi / 180.0)
    }

}

extension RightViewController : AVCapturePhotoCaptureDelegate {
    func photoOutput(_ captureOutput: AVCapturePhotoOutput,
                 didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?,
                 previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?,
                 resolvedSettings: AVCaptureResolvedPhotoSettings,
                 bracketSettings: AVCaptureBracketedStillImageSettings?,
                 error: Error?){
        
        //make sure we get some photo sample buffer
        guard error == nil,
            let photoSampleBuffer = photoSampleBuffer else {
            print("Error capturing photo: \(String(describing: error))")
            return
        }
        
        //convert photo same buffer to jpeg image data by using AVCapturePhotoOutput
        guard let imageData = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: photoSampleBuffer, previewPhotoSampleBuffer: previewPhotoSampleBuffer) else {
            return
        }
        
        //initialise an UImage with out image data
        let capturedImage = UIImage.init(data: imageData, scale: 1.0)
        if let image = capturedImage{
            //save our captured image to photos album
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            flashScreen()
        }
    }
}
