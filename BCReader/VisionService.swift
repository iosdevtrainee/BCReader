
import UIKit
import Firebase
final class VisionService {
    public static let vision = Vision.vision()
    
    public static func readText(image:UIImage){
        let textRecognizer = vision.cloudTextRecognizer()
        let options = VisionCloudTextRecognizerOptions()
        options.languageHints = ["en", "hi"]
        let visionImage = VisionImage(image:image)
        textRecognizer.process(visionImage) { (result, error) in
            guard error == nil, let result = result else {
                // ...
                print(error?.localizedDescription)
                return
            }
            let resultText = result.text
            print(resultText)
            for block in result.blocks {
                let blockText = block.text
                print("block \(blockText)")
//                let blockConfidence = block.confidence
//                let blockLanguages = block.recognizedLanguages
//                let blockCornerPoints = block.cornerPoints
//                let blockFrame = block.frame
                for line in block.lines {
                    let lineText = line.text
                    print("line: \(lineText)")
//                    let lineConfidence = line.confidence
//                    let lineLanguages = line.recognizedLanguages
//                    let lineCornerPoints = line.cornerPoints
//                    let lineFrame = line.frame
                    for element in line.elements {
                        let elementText = element.text
                        print("element: \(elementText)")
//                        let elementConfidence = element.confidence
//                        let elementLanguages = element.recognizedLanguages
//                        let elementCornerPoints = element.cornerPoints
//                        let elementFrame = element.frame
        }
        
                }
            }
        }
    }
}
