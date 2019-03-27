import Foundation

struct BCData {
    var id: String 
    var name: String
    var lastName: String
    var email: String
    var phoneNumber: String
    var company: String
    var photoURL: String
    var createdAt: String
    
    init(document:[String: Any]) {
        self.id = document[BCDataKeys.BCDIdKey] as? String ?? ""
        self.name = document[BCDataKeys.EmailKey] as? String ?? ""
        self.lastName = document[BCDataKeys.LastNameKey] as? String ?? ""
        self.email = document[BCDataKeys.EmailKey] as? String ?? ""
        self.phoneNumber = document[BCDataKeys.PhoneNumber] as? String ?? ""
        self.company = document[BCDataKeys.Company] as? String ?? ""
        self.photoURL = document[BCDataKeys.PhotoURLKey] as? String ?? ""
        self.createdAt = document[BCDataKeys.CreatedAt] as? String ?? "" 
        
        
        
    }
}




