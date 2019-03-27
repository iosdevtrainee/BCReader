import Foundation
import FirebaseFirestore
import Firebase

struct BCDataKeys {
  static let CollectionKey = "BCData"
  static let BCDIdKey = "Id"
  static let NameKey = "name"
  static let LastNameKey = "lastname"
  static let EmailKey = "email"
  static let PhoneNumber = "number"
  static let PhotoURLKey = "photoURL"
  static let CreatedAt = "createdAt"
static let Company = "company"
}



final class DBService {
  private init() {}
  
  public static var firestoreDB: Firestore = {
    let db = Firestore.firestore()
    let settings = db.settings
    settings.areTimestampsInSnapshotsEnabled = true
    db.settings = settings
    return db
  }()
  
  static public var generateDocumentId: String {
    return firestoreDB.collection(BCDataKeys.CollectionKey).document().documentID
  }
  
  static public func createBCData(reviewer: BCData, completion: @escaping (Error?) -> Void) {
    firestoreDB.collection(BCDataKeys.CollectionKey)
      .document(reviewer.id)
      .setData([ BCDataKeys.CollectionKey : reviewer.id,
                                            BCDataKeys.EmailKey       : reviewer.email,
                                            BCDataKeys.NameKey : reviewer.name,
                                            BCDataKeys.PhotoURLKey    : reviewer.photoURL ?? "",
                                            BCDataKeys.CreatedAt  : reviewer.createdAt,
                                            BCDataKeys.PhoneNumber: reviewer.phoneNumber,
                                            BCDataKeys.Company: reviewer.company
    ]) { (error) in
      if let error = error {
        completion(error)
      } else {
        completion(nil)
      }
    }
  }
  
//  static public func postReview(review: BCData) {
//    firestoreDB.collection(BCDataKeys.CollectionKey)
//      .document(review.documentId).setData([
//                                          ReviewsCollectionKeys.CreatedDateKey     : review.createdDate,
//                                          ReviewsCollectionKeys.ReviwerId          : review.reviewerId,
//                                          ReviewsCollectionKeys.ReviewDescritionKey: review.reviewDescription,
//                                          ReviewsCollectionKeys.ImageURLKey        : review.imageURL,
//                                          ReviewsCollectionKeys.DocumentIdKey      : review.documentId
//      ])
//    { (error) in
//      if let error = error {
//        print("posting reviewe error: \(error)")
//      } else {
//        print("review posted successfully to ref: \(review.documentId)")
//      }
//    }
//  }
}

