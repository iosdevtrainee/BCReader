import UIKit

class SaveViewController: UITableViewController {
    public var image: UIImage!
    public var cardInfo: CardInfo!
    @IBOutlet weak var companyTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var telephoneTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var bcimageView: UIImageView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        bcimageView.image = image
        setupUI()
    }
    
    private func setupUI(){
        companyTextField.text = cardInfo?.company
        nameTextField.text = cardInfo?.name
        telephoneTextField.text = cardInfo?.phone
        emailTextField.text = cardInfo?.email
    }
    
    private func storeImage() {
        guard let imageData = bcimageView.image?.jpegData(compressionQuality: 1.0) else {
            print("Missing Fields")
            return
        }
        
        let docRef = DBService.firestoreDB.collection(BCDataKeys.CollectionKey).document()
        StorageService.postImage(imageData: imageData, imageName: docRef.documentID) { [weak self] (error, url) in
            if let error = error {
                print("\(error.localizedDescription)")
            } else if let url = url {
                self?.saveContact(url: url)
            }
        }
    }
    
    private func saveContact(url: URL) {
        let id = DBService.generateDocumentId
        guard let name = nameTextField.text,
            let telephone = telephoneTextField.text,
            let email = emailTextField.text,
            let company = companyTextField.text else {
                return
        }
        let date = Date.getISOTimestamp().formatISODateString(dateFormat: BCData.contactDateFormat)
        let bussinessCard = BCData(id: id, name: name, email: email, phoneNumber: telephone, company: company, photoURL: url, createdAt: date, companyURL: nil)
        DBService.createBCData(reviewer: bussinessCard) { (error) in
            if let error = error {
                print("Failed top Create Contact with Error: \(error.localizedDescription)")
            }
        }
    }
    
    

    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @IBAction func saveButtonPressed(_ sender: Any) {
        storeImage()
    }
}
