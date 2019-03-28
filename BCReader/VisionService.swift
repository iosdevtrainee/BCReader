
import UIKit
import Firebase
import PhoneNumberKit

typealias CardInfo = (email:String, phone:String, company:String?, name:String?)

final class VisionService {
    
    private static func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    private static func isValidPhoneNumber(string:String) -> Bool {
        let phoneRegEx = "1?[\\s-]?\\(?(\\d{3})\\)?[\\s-]?\\d{3}[\\s-]?\\d{4}"
        let phoneNumTest = NSPredicate(format:"SELF EQUAL %@", phoneRegEx)
        return phoneNumTest.evaluate(with: string)
    }
    
    public static let vision = Vision.vision()
    
    public static func readText(image:UIImage, completion:@escaping(CardInfo) -> Void) {
        var cardEmail:String?
        var cardPhone:String!
        var cardCompany: String!
        var cardName: String?
            let textRecognizer = vision.onDeviceTextRecognizer()
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
                    let linesOfText = block.lines.map { $0.text }
                    cardCompany = linesOfText.first
                    if let email = (block.lines.filter { VisionService.isValidEmail(testStr: $0.text) }).first?.text {
                        cardEmail = email
                        print("Email: \(email)")
                    }
                    for line in block.lines {
                        let myRegex = "\\d{3}.\\d{3}.\\d{4}"
                        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
                        if let emailMatch = line.text.range(of: emailRegex, options: .regularExpression) {
                            cardEmail = line.text[emailMatch].description
                            
                        }
                        if let phoneNumMatch = line.text.range(of: myRegex, options: .regularExpression) {
                            let phoneNumber = line.text[phoneNumMatch]
                            print("PHONE NUMBER: \(phoneNumber)")
                            cardPhone = phoneNumber.description
                            print("BOB")
                            
                        }
                    }
                }
                var cardInfo: CardInfo
                cardInfo.company = cardCompany
                cardInfo.phone = cardPhone
                cardInfo.name = cardName
                cardInfo.email = cardEmail ?? ""
                completion(cardInfo)
            }
    }
}
