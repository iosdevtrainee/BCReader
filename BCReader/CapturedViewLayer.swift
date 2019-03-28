import UIKit
import AVFoundation

class AVCapturePreviewView: UIView {
    override class var layerClass: Swift.AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("")
        }
        
        return layer
    }

}
