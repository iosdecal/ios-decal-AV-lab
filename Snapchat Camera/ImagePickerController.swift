//
//  ImagePickerViewController.swift
//  Snapchat Camera Lab
//
//  Created by Paige Plander on 3/11/17.
//  Copyright © 2017 org.iosdecal. All rights reserved.
//

import UIKit
import AVFoundation

// TODO: you'll need to edit this line to make your class conform to a protocol
class ImagePickerViewController: UIViewController {
    
    // Part 1 involves connecting these outlets
    @IBOutlet weak var imageViewOverlay: UIImageView!
    @IBOutlet weak var flipCameraButton: UIButton!
    @IBOutlet weak var takePhotoButton: UIButton!
    @IBOutlet weak var sendImageButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    // The image to send as a Snap
    var selectedImage = UIImage()
    
    // middleman between AVCaptureInput and AVCaptureOutputs
    var captureSession: AVCaptureSession?
    
    // the device we are capturing media from (i.e. front camera of an iPhone 7)
    var captureDevice : AVCaptureDevice?
    
    // view that will let us preview what is being captured from our input
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    // used to capture a single photo from our capture device
    let photoOutput: AVCapturePhotoOutput?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let _ = imageViewOverlay, let _ = takePhotoButton, let _ = sendImageButton, let _ = cancelButton, let _ = flipCameraButton else {
            print("Looks like you haven't connected all of your outlets!")
            return
        }
        
        // TODO: instantiate `captureSession` and `photoOutput` here (no need to pass in any 
        // parameters into their initializers
        
        // TODO: uncomment me when the README tells you to!
        // createAndLayoutPreviewLayer(fromSession: captureSession)
        // configureCaptureSession(forDevicePosition: .unspecified)
        
        captureSession?.startRunning()
        
        toggleUI(isInPreviewMode: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // hide the navigation bar while we are in this view
        navigationController?.navigationBar.isHidden = true
    }

    
    // Creates a new capture session, and starts updating it using the user's.
    /// You may want to add a parameter to this function for
    /// part 4 of the lab
    func configureCaptureSession(forDevicePosition devicePostion: AVCaptureDevice.Position) {
        guard let captureSession = captureSession else {
            print("captureSession has not been initialized")
            return
        }
        
        // specifies that we want high quality video captured from the device
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // this line will need to be edited for part 5
        let someConstantWithABadName = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: .video, position: devicePostion).devices[1]
    
        do {
            // TODO: add an input and output to our AVCaptureSession
        }
        catch {
            print(error.localizedDescription)
        }
    }
    
    /// This method should initialize a preview layer
    /// and add it to our view. It's not complete yet.
    ///
    /// - Parameter session: the current captureSession
    func createAndLayoutPreviewLayer(fromSession session: AVCaptureSession?) {
        // TODO: initialize previewLayer
    
        guard let previewLayer = previewLayer else {
            print("previewLayer hasn't been initialized yet!")
            return
        }
    
        // these two lines add the previewlayer to our
        // viewcontroller's view
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.layer.frame
        previewLayer.zPosition = -1
    }
    
    @IBAction func takePhoto(_ sender: UIButton) {
        // Instead of sending a squirrel pic every time, here we will want
        // to start the process of creating a photo from our photoOutput
        
        // TODO: delete this line
        selectedImage = UIImage(named: "squirrel") ?? UIImage()
        
        let photoSettings = AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecType.jpeg])
        
        // TODO: capture the photo using photoOutput
       
        toggleUI(isInPreviewMode: true)
    }
    
    /// Switch between front and back camera
    ///
    /// - Parameter sender: The flip camera button in the top left of the view
    @IBAction func flipCamera(_ sender: UIButton) {
        // TODO: allow user to switch between front and back camera
        // you will need to remove all of your inputs from
        // your capture session before switching cameras
    }
    
    @IBAction func cancelButtonWasPressed(_ sender: UIButton) {
        selectedImage = UIImage()
        toggleUI(isInPreviewMode: false)
    }
    
    @IBAction func sendImage(_ sender: UIButton) {
        performSegue(withIdentifier: "imagePickerToChooseThread", sender: nil)
    }
    
    // MARK: Do not edit below this line
    
    /// Toggles the UI depending on whether or not the user is
    /// viewing a photo they took, or is currently taking a photo.
    ///
    /// - Parameter isInPreviewMode: true if they just took a photo (and are viewing it)
    func toggleUI(isInPreviewMode: Bool) {
        if isInPreviewMode {
            imageViewOverlay.image = selectedImage
            takePhotoButton.isHidden = true
            sendImageButton.isHidden = false
            cancelButton.isHidden = false
            flipCameraButton.isHidden = true
            
        }
        else {
            takePhotoButton.isHidden = false
            sendImageButton.isHidden = true
            cancelButton.isHidden = true
            imageViewOverlay.image = nil
            flipCameraButton.isHidden = false
        }
    }
    
    // Called when we unwind from the ChooseThreadViewController
    @IBAction func unwindToImagePicker(segue: UIStoryboardSegue) {
        toggleUI(isInPreviewMode: false)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        navigationController?.navigationBar.isHidden = false
        let destination = segue.destination as! ChooseThreadViewController
        destination.chosenImage = selectedImage
        toggleUI(isInPreviewMode: false)
    }
}

