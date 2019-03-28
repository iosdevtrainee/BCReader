import UIKit
import Kingfisher
import FirebaseMLVision

class ViewController: UIViewController {
    
    
    
    var contacts = [BCData]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    var cellSpacing: CGFloat = 10.0
    var numberOfSpaces: CGFloat = 2.0
    var numberOfCells: CGFloat = 1.0
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
        let screenWidth = UIScreen.main.bounds.width
        let screenHeight = UIScreen.main.bounds.height
        let width = (screenWidth - (cellSpacing * numberOfSpaces)) / numberOfCells
        let height = (screenWidth / screenHeight) * width

        return CGSize(width: width , height: height)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: self.cellSpacing, left: self.cellSpacing, bottom: self.cellSpacing, right: self.cellSpacing)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.cellSpacing
    }
}
