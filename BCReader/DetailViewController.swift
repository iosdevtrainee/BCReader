import UIKit
import CoreTelephony
import SafariServices
import MessageUI

class DetailViewController: UITableViewController {
    var contact = BCData(id: "", name: "Jeon", email: "je@aol.com", phoneNumber: "718-559-7789", company: "Pursuit", photoURL: URL(string: "https://google.com")!, createdAt: "", companyURL: URL(string: "https://google.com")!)
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var companyLabel: UILabel!
    
    
    
    public func setupUI(){
        nameLabel.text = contact.name
        emailLabel.text = contact.email
        phoneLabel.text = contact.phoneNumber
        companyLabel.text = contact.company
        
        let websiteTapGesture = UITapGestureRecognizer(target: self, action: #selector(openContactWebsite))
        companyLabel.addGestureRecognizer(websiteTapGesture)
        companyLabel.isUserInteractionEnabled = true
        
        let phoneTapGesture = UITapGestureRecognizer(target: self, action: #selector(callContact))
        phoneLabel.addGestureRecognizer(phoneTapGesture)
        phoneLabel.isUserInteractionEnabled = true
        
        let emailTapGesture = UITapGestureRecognizer(target: self, action: #selector(EmailContact))
        emailLabel.addGestureRecognizer(emailTapGesture)
        emailLabel.isUserInteractionEnabled = true
    }

    @objc private func EmailContact(){
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true)
        } else {
            print()
        }
    }

    @objc public func callContact(){
        if let url = URL(string: "tel://1\(contact.phoneNumber)") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @objc public func openContactWebsite(){
        if let url = contact.companyURL {
            let companyWebsiteVC = SFSafariViewController(url: url)
            present(companyWebsiteVC, animated: true)
        }
    }
    

    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients([contact.email])
        mailComposerVC.setSubject("")
        mailComposerVC.setMessageBody("Hi, \(contact.name)", isHTML: false)
        return mailComposerVC
    }




    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
}

// MARK: MFMailComposeViewControllerDelegate

extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
    }
}


