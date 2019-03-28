import UIKit
import Kingfisher
import FirebaseMLVision

class ViewController: UIViewController {
    
    var contacts = [BCData]() {
        didSet {
            tableView.reloadData()
        }
    }
    @IBOutlet weak var tableView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFBData()
        let vision = Vision.vision()
        var textRecognizer = vision.onDeviceTextRecognizer()
        let options = VisionCloudTextRecognizerOptions()
      //  options.languageHints = ["en", "hi"]
        textRecognizer = vision.cloudTextRecognizer(options: options)
        tableView.delegate = self
        tableView.dataSource = self 
    }
    
    
    @IBAction func addBCData(_ sender: UIBarButtonItem) {
        
    }
    
    func getFBData() {
        DBService.firestoreDB.collection(BCDataKeys.CollectionKey).getDocuments { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let snapshot = snapshot {
                self.contacts = snapshot.documents.map { BCData(document: $0.data()) }
                print("\(self.contacts)  please print")
            }
        }
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return contacts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCell", for: indexPath) as? MainViewCell else { return UICollectionViewCell() }
        let contactData = contacts[indexPath.row]
        cell.bcImage.kf.setImage(with: URL(string: (contactData.photoURL?.absoluteString)!))
        cell.nameLabel.text = contactData.name
        //cell.nameLabel.text = "Test"
        return cell
      
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyboard = UIStoryboard.init(name: "Detail", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
       let contactData = contacts[indexPath.row]
        viewController.contact = contactData
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 730)
        
    }
}
