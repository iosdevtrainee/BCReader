import UIKit
import Kingfisher

class ViewController: UIViewController {
    
    var contacts = [BCData]()
    @IBOutlet weak var tableView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getFBData()
        tableView.delegate = self
        tableView.dataSource = self 
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
       return 1 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainViewCell", for: indexPath) as? MainViewCell else { return UICollectionViewCell() }
        cell.bcImage.image = #imageLiteral(resourceName: "placeholder-image-2 (1)")
        cell.nameLabel.text = "Test"
        return cell
      
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 400, height: 730)
    }
}
