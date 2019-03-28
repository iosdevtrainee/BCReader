import Foundation

struct BCData {
    var id: String 
    var name: String
    var email: String
    var phoneNumber: String
    var company: String
    var photoURL: URL?
    var createdAt: String
    var companyURL: URL?
    
    static var contactDateFormat = ""
    init(document:[String: Any]) {
        self.id = document[BCDataKeys.BCDIdKey] as? String ?? ""
        self.name = document[BCDataKeys.NameKey] as? String ?? ""
        self.email = document[BCDataKeys.EmailKey] as? String ?? ""
        self.phoneNumber = document[BCDataKeys.PhoneNumber] as? String ?? ""
        self.company = document[BCDataKeys.Company] as? String ?? ""
        let photoURLString = document[BCDataKeys.PhotoURLKey] as? String ?? ""
        self.photoURL = URL(string: photoURLString)
        self.createdAt = document[BCDataKeys.CreatedAt] as? String ?? ""
        let companyURLString = document[BCDataKeys.CompanyURLKey] as? String ?? ""
        self.companyURL = URL(string: companyURLString)
    
    }
    
    init(id:String, name:String,
         email:String, phoneNumber:String,
         company:String, photoURL:URL,
         createdAt:String, companyURL:URL?){
        self.id = id
        self.name = name
        self.email = email
        self.phoneNumber = phoneNumber
        self.company = company
        self.photoURL = photoURL
        self.createdAt = createdAt
        self.companyURL = companyURL
    }
}




