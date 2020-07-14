//
//  ViewController5.swift
//  EXCEL FENCING MOBILE APPLICATION
//  Created by Kyle Skyllingstad
//

// Import necessary kits/libraries
import UIKit
import Firebase
import FirebaseDatabase

// Class for screen 5, ViewController5
class ViewController5: UIViewController {
    
    // Set outlets for buttons and labels
    
    // Labels
    @IBOutlet weak var useridLabel: UILabel!
    @IBOutlet weak var firstnameLabel: UILabel!

    // Buttons
    @IBOutlet weak var letsFenceButton: UIButton!
    @IBOutlet weak var showPopUpButton: UIButton!
    
    
    // Main screen loading function
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the function to set up the UI elements
        setUpElements()
        
        // Call reception notification center function to receive incoming information (User ID and first name)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationUserID(_:)), name: Notification.Name("useridin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didGetNotificationFirstName(_:)), name: Notification.Name("firstnamein"), object: nil)
        
    }
    
    
    
    
    
    
    // Functions ////////////////////////////////
    
    
    
    // Function for setting up the UI elements
    func setUpElements() {
    
        // Style some buttons
        Utilities.styleHollowButton(letsFenceButton)
        Utilities.styleHollowButtonPopUp(showPopUpButton)
    }

    
    
    // Function for if User ID is received
    @objc func didGetNotificationUserID(_ notification: Notification) {
        
        // Take in raw notification
        let useridinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let useridin: String = useridinOptional as? String else {
            return
        }
        
        // Set the incoming User ID to the label to store it on this screen
        useridLabel.text = useridin
    }
    
    
    // Function for if the first name is received
    @objc func didGetNotificationFirstName(_ notification: Notification) {
        
        // Take in raw notification
        let firstnameinOptional = notification.object as! String?
        
        // Unwrap optional raw notification
        guard let firstnamein: String = firstnameinOptional as? String else {
            return
        }
        
        // Set the incoming first name to the label to store it on this screen
        firstnameLabel.text = firstnamein
    }
    
    
    // Function for showing the user popup menu when icon is pressed
    @IBAction func showPopUp(sender: AnyObject) {
        
        // Get User ID and user first name from the labels
        let useridString = useridLabel.text
        let firstnameStringOptional = firstnameLabel.text
        
        // Unwrap first name raw optional
        guard let firstnameStringRaw: String = firstnameStringOptional as? String else {
            return
        }
        
        // Get just the first name and nothing else
        let firstnameString = firstnameStringRaw.replacingOccurrences(of: "Hello, ", with: "")
        
        // Call the user popup menu
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "UserPopUpID") as! PopUpViewController
        
        // Present the user popup menu so it fills part of the screen but not all of it, and loads in properly
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        // Post the User ID and the user first name to the notification center for this screen and others
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: useridString)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstnameString)
        
    }
    
    
    
    // Function for if continue button from this screen (VC5) to the next one (VC6) is tapped
    @IBAction func didTapButton5to6() {
        
        // Get User ID and user first name from their storage labels
        let useridString = useridLabel.text
        let firstnameStringOptional = firstnameLabel.text
        
        // Unwrap user first name raw optional
        guard let firstnameStringRaw: String = firstnameStringOptional as? String else {
            return
        }
        
        // Get just the first name
        let firstnameString = firstnameStringRaw.replacingOccurrences(of: "Hello, ", with: "")
        
        // Create link to VC6
        guard let VC = storyboard?.instantiateViewController(identifier: "VC6") as? ViewController6 else {
            return
        }
        
        // Present (go to) VC6
        VC.modalPresentationStyle = .fullScreen
        VC.modalTransitionStyle = .coverVertical
        present(VC, animated: true)
        
        // Post the User ID and first name to the notification center so they can be accessed by this screen and others
        NotificationCenter.default.post(name: Notification.Name("useridin"), object: useridString)
        NotificationCenter.default.post(name: Notification.Name("firstnamein"), object: firstnameString)

    }
    
    
    



}
