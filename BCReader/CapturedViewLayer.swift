import UIKit
import AVFoundation

class AVCapturePreviewView: UIView {
    override class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var avPreviewLayer: AVCaptureVideoPreviewLayer { return layer as! AVCaptureVideoPreviewLayer }
}
