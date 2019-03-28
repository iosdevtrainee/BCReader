import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var shutterButton: UIButton!
    @IBOutlet weak var previewLayer: AVCapturePreviewView!
    
    @IBOutlet weak var previewView: AVCapturePreviewView!
    
    private var avSession = AVCaptureSession()
    
    private var backCamera: AVCaptureDevice?
    private var frontCamera: AVCaptureDevice?
    private var currentCamera: AVCaptureDevice?
    private var videoOrientation: AVCaptureVideoOrientation?
    
    private var photoOutput: AVCapturePhotoOutput?
    private let photoSessionPreset = AVCaptureSession.Preset.photo
    
    private let sessionQueue = DispatchQueue(label: "session Queue")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurePreview(view: previewView)
        self.cancel.addTarget(self, action: #selector(cancelSelected), for: .touchUpInside)
        self.shutterButton.addTarget(self, action:#selector(takePhoto) , for: .touchUpInside)
    }
    
    @objc func cancelSelected() {
    
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        let orientation = UIDevice.current.orientation
        let connection = previewView.videoPreviewLayer.connection
        
        guard let videoOrientation = AVCaptureVideoOrientation(deviceOrientation: orientation)
            else { return }
        connection?.videoOrientation = videoOrientation
        self.updateOrientation(orientation: videoOrientation)
    }
    
    private func setupCaptureSession() {
        setupPhotoCaptureSession()
        setupDevices()
        setUpCaptureSessionInput(position: .back)
        configureOrientation()
    }
    
    private func configureOrientation() {
        let statusBarOrientation = UIApplication.shared.statusBarOrientation
        if statusBarOrientation != .unknown,
            let videoOrientation = AVCaptureVideoOrientation(interfaceOrientation: statusBarOrientation) {
            self.videoOrientation = videoOrientation
        } else {
            self.videoOrientation = .portrait
        }
    }
    
    func captureImage(){
        takePhoto()
    }
    
    func configurePreview(view: AVCapturePreviewView) {
        setupCaptureSession()
        setupPreviewLayer(view: view)
        configureOutput()
        startRunningCaptureSession()
    }
    
    // This function sets up a switch to change the camera in use depending on current position when called.
    private func setUpCaptureSessionInput(position: AVCaptureDevice.Position) {
        switch position {
        case .back:
            currentCamera = backCamera
        case .front:
            currentCamera = frontCamera
        default:
            currentCamera = backCamera
        }
        
        setupInputOutput()
    }
    
    //This function will be called when the VC sets up the capture session so that the output connection is set before the first photo is taken so that it doesn't come out black.
    func configureOutput() {
        if let orientation = videoOrientation { self.photoOutput?.connection(with: .video)?.videoOrientation = orientation
        self.photoOutput?.isHighResolutionCaptureEnabled = true
        }
    }
    
    // Mark:- @objc functions for buttons
    // This is the function that will be called when the take photo button is pressed.
    @objc func takePhoto() {
        sessionQueue.async {
            if let orientation = self.videoOrientation { self.photoOutput?.connection(with: .video)?.videoOrientation = orientation
            let settings = AVCapturePhotoSettings()
            settings.isHighResolutionPhotoEnabled = true
            self.photoOutput?.capturePhoto(with: settings, delegate: self)
        }
        }
    }
    
    func updateOrientation(orientation: AVCaptureVideoOrientation) {
        videoOrientation = orientation
    }
    
    // AVCapturePhotoCaptureDelegate methods. This extension is used because you need to wait until the photo you took "didFinishProcessing" before you can handle the image.
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if let imageData = photo.fileDataRepresentation(),
            let image = UIImage(data: imageData) {
            let storyboard = UIStoryboard(name: "Save", bundle: nil)
            let saveVC = storyboard.instantiateViewController(withIdentifier: "SaveVC") as! SaveViewController
            saveVC.image = image
            VisionService.readText(image: image)
//            present(saveVC, animated: true)

        }
    }
    
    // Mark:- AVCapture Session Setup functions
    // This function sets up the photo capture session as well as the photo ouput instance and its settings.
    private func setupPhotoCaptureSession(){
        avSession.beginConfiguration()
        avSession.sessionPreset = photoSessionPreset
        avSession.commitConfiguration()
        
        photoOutput = AVCapturePhotoOutput()
        photoOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey: AVVideoCodecType.jpeg])], completionHandler: nil)
        avSession.addOutput(photoOutput!)
    }
    
    // This function allows you to have the application discover the devices camera(s)
    private func setupDevices(){
        let deviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [AVCaptureDevice.DeviceType.builtInWideAngleCamera], mediaType: AVMediaType.video, position: AVCaptureDevice.Position.unspecified)
        let devices = deviceDiscoverySession.devices
        
        for device in devices {
            if device.position == AVCaptureDevice.Position.back {
                backCamera = device
            } else if device.position == AVCaptureDevice.Position.front {
                frontCamera = device
            }
        }
    }
    
    // This function allows you to remove the current camera input in use and to set and enable a new camera input.
    private func setupInputOutput(){
        avSession.beginConfiguration()
        if let currentInput = avSession.inputs.first {
            avSession.removeInput(currentInput)
        }
        do {
            let captureDeviceInput = try AVCaptureDeviceInput(device: currentCamera!)
            avSession.addInput(captureDeviceInput)
        } catch {
            print(error)
        }
        avSession.commitConfiguration()
    }
    
    // This function creates a layer in the view that will enable a live feed of what your camera is observing.
    private func setupPreviewLayer(view: AVCapturePreviewView){
        if let orientation = videoOrientation {
            view.videoPreviewLayer.session = avSession
            view.videoPreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
            view.videoPreviewLayer.connection?.videoOrientation = orientation
        }
    }
    
    // Starts running the capture session after you set up the view.
    private func startRunningCaptureSession(){
        avSession.startRunning()
    }
    
}
